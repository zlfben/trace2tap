from autotapmc.model.Tap import Tap
from autotapta.model.Util import TriggerExpression, EventExpression, ConditionExpression, \
                                 ActionExpression, Comparator, ComparatorRange, checkExpression
from abc import abstractmethod
import z3
import datetime
from typing import List, Dict, Any, Tuple


class Rule(object):
    # abstract class for a rule
    @abstractmethod
    def trigger(self, event: EventExpression, pre_condition_dict: Dict[str, Any]):
        """

        :param event: the event that happens
        :param pre_condition_dict: a dictionary of pre_conditions of the event,
               used to determine whether condition of the rule is satisfied
        :return: (action, cond): an action to be triggered, if cond is true.
                 when no action is triggered, return (None, None)
        """
        pass

    @abstractmethod
    def to_tap(self, var_resolve: dict={}):
        """

        :param var_resolve: a dict declaring values of all symbols used in the rule
        :return: a Tap object, which is a regular "Tap"
        """
        pass

    @abstractmethod
    def getAllZ3Variables(self):
        """
        return all z3 symbols as a dictionary, return their default values also as a dictionary
        :return:
        """
        pass

    @abstractmethod
    def getRangeVars(self):
        pass

    @abstractmethod
    def getSetVars(self):
        pass


class RegRule(Rule):
    # a regular rule, with a symbol for deletion
    def __init__(self, trigger: TriggerExpression, condition: List[ConditionExpression], action: ActionExpression, plain=False):
        self.plain = plain

        # trigger, condition and action
        self.trigger_e = trigger
        self.condition = condition
        self.action = action

        # showing symbol
        self.show_symb = z3.Bool('tap_%d' % id(self))
        self.z3_var_dict = {'tap_%d' % id(self): self.show_symb}
        self.z3_var_default_val_dict = {'tap_%d' % id(self): True}

    def trigger(self, event: EventExpression, pre_condition_dict: Dict[str, Any]):
        cond_sat = z3.And([cond.check(cond.var, pre_condition_dict[cond.var]) for cond in self.condition])
        cond_sat = z3.And(cond_sat, z3.Not(self.trigger_e.checkTrigger(pre_condition_dict[self.trigger_e.var])))
        if not self.plain:
            return self.action, z3.And(self.show_symb, self.trigger_e.check(event), cond_sat)
        else:
            return self.action, z3.And(self.trigger_e.check(event), cond_sat)

    def to_tap(self, var_resolve: dict={}):
        if str(self.show_symb) in var_resolve:
            if var_resolve[str(self.show_symb)] or self.plain:
                action = '%s=%s' % (self.action.var, self.action.val)
                if self.trigger_e.hold_t:
                    trigger = '%d*%s%s%s' % (self.trigger_e.hold_t, self.trigger_e.var, self.trigger_e.comp, self.trigger_e.val)
                elif self.trigger_e.delay:
                    trigger = '%d#%s%s%s' % (self.trigger_e.delay, self.trigger_e.var, self.trigger_e.comp, self.trigger_e.val)
                else:
                    trigger = '%s%s%s' % (self.trigger_e.var, self.trigger_e.comp, self.trigger_e.val)
                condition = ['%s%s%s' % (cond.var, cond.comp, cond.val) for cond in self.condition]
                return Tap(action=action, trigger=trigger, condition=condition)
            else:
                return None
        else:
            raise Exception('cannot translate symbolic rule into real tap without assignment')

    def getAllZ3Variables(self):
        return self.z3_var_dict, self.z3_var_default_val_dict

    def getRangeVars(self):
        return []

    def getSetVars(self):
        return []


class SymbRule(Rule):
    # a symbolic rule. trigger and condition are chosen among multiple candidates. action is deterministic
    def __init__(self, trig_caps: List[Tuple[str, int]], cond_caps: List[str],
                 action: ActionExpression, template_dict: Dict[str, Dict], set_z3_dict: Dict[str, Tuple]):
        """

        :param trig_caps: a list of tuple (cap name, time). Time is for timing in triggers.
                          It will be ignored if set to 0. Those caps are candidates for trigger.
        :param cond_caps: a list of cap names. Those caps are for condition
        :param action: an action
        :param template_dict:
        :param set_z3_dict:
        """
        # action
        self.action = action
        action_dev, action_var = action.var.split('.')
        self.action_cap_typ = template_dict[action_dev][action_var].split(', ')[0]

        # z3 dict
        self.z3_var_dict = dict()
        self.z3_var_default_val_dict = dict()

        # show symbol
        self.show_symb = z3.Bool('tap_%d' % id(self))
        self.z3_var_dict['tap_%d' % id(self)] = self.show_symb
        self.z3_var_default_val_dict[str(self.show_symb)] = True

        # list of candidate caps
        self.trig_cap_list = list()
        self.trig_cap_typ_list = list()
        self.timing_cap_list = list()
        self.timing_cap_typ_list = list()
        self.ap_cap_list = list()
        self.ap_cap_typ_list = list()

        # trigger symbols
        self.trig_show_list = list()
        self.trig_comp_list = list()
        self.trig_val_list = list()
        # timing symbols
        self.timing_trig_show_list = list()
        self.timing_trig_comp_list = list()
        self.timing_trig_val_list = list()
        # clock symbol
        self.clock_trig_show = z3.Bool('clocktrigshow_' + str(id(self)))
        self.clock_trig_val = z3.Int('clocktrigval_' + str(id(self)))
        self.z3_var_dict[str(self.clock_trig_show)] = self.clock_trig_show
        self.z3_var_dict[str(self.clock_trig_val)] = self.clock_trig_val
        self.z3_var_default_val_dict[str(self.clock_trig_show)] = False
        self.z3_var_default_val_dict[str(self.clock_trig_val)] = 0
        # ap symbols
        self.ap_show_list = list()
        self.ap_comp_list = list()
        self.ap_val_list = list()

        # generate list of candidate caps
        for cap, time in trig_caps:
            dev, var = cap.split('.')
            typ = template_dict[dev][var]
            typ = typ.split(', ')[0]
            if time == 0:
                self.trig_cap_list.append(cap)
                self.trig_cap_typ_list.append(typ)
            else:
                self.timing_cap_list.append((cap, time))
                self.timing_cap_typ_list.append(typ)
        for cap in cond_caps:
            dev, var = cap.split('.')
            typ = template_dict[dev][var]
            typ = typ.split(', ')[0]
            self.ap_cap_list.append(cap)
            self.ap_cap_typ_list.append(typ)

        # initialize trigger z3 variables
        for cap, typ in zip(self.trig_cap_list, self.trig_cap_typ_list):
            var_name_app = '%s_%d' % (cap, id(self))
            trig_show = z3.Bool('trigshow_' + var_name_app)
            self.trig_show_list.append(trig_show)
            self.z3_var_dict['trigshow_' + var_name_app] = trig_show
            self.z3_var_default_val_dict['trigshow_' + var_name_app] = False
            if typ == 'bool':
                self.trig_comp_list.append(Comparator.eq)
                trig_val = z3.Bool('trigval_' + var_name_app)
                self.trig_val_list.append(trig_val)
                self.z3_var_dict['trigval_' + var_name_app] = trig_val
                self.z3_var_default_val_dict['trigval_' + var_name_app] = False
            elif typ == 'set':
                SetType, option_dict = set_z3_dict[cap]
                self.trig_comp_list.append(Comparator.eq)
                trig_val = z3.Const('trigval_' + var_name_app, SetType)
                self.trig_val_list.append(trig_val)
                self.z3_var_dict['trigval_' + var_name_app] = trig_val
                self.z3_var_default_val_dict['trigval_' + var_name_app] = list(option_dict.items())[0][1]
            else:  # range
                trig_comp = z3.Const('trigcomp_' + var_name_app, ComparatorRange)
                self.trig_comp_list.append(trig_comp)
                self.z3_var_dict['trigcomp_' + var_name_app] = trig_comp
                self.z3_var_default_val_dict['trigcomp_' + var_name_app] = ComparatorRange.eq
                trig_val = z3.Int('trigval_' + var_name_app)
                self.trig_val_list.append(trig_val)
                self.z3_var_dict['trigval_' + var_name_app] = trig_val
                self.z3_var_default_val_dict['trigval_' + var_name_app] = 0

        # initialize trigger z3 time variables
        for cap_t, typ in zip(self.timing_cap_list, self.timing_cap_typ_list):
            cap, t = cap_t
            var_name_app = '%s_%d' % (cap, id(self))
            trig_show = z3.Bool('timingtrigshow_' + var_name_app)
            self.timing_trig_show_list.append(trig_show)
            self.z3_var_dict['timingtrigshow_' + var_name_app] = trig_show
            self.z3_var_default_val_dict['timingtrigshow_' + var_name_app] = False
            if typ == 'bool':
                self.timing_trig_comp_list.append(Comparator.eq)
                trig_val = z3.Bool('timingtrigval_' + var_name_app)
                self.timing_trig_val_list.append(trig_val)
                self.z3_var_dict['timingtrigval_' + var_name_app] = trig_val
                self.z3_var_default_val_dict['timingtrigval_' + var_name_app] = False
            elif typ == 'set':
                SetType, option_dict = set_z3_dict[cap]
                self.timing_trig_comp_list.append(Comparator.eq)
                trig_val = z3.Const('timingtrigval_' + var_name_app, SetType)
                self.timing_trig_val_list.append(trig_val)
                self.z3_var_dict['timingtrigval_' + var_name_app] = trig_val
                self.z3_var_default_val_dict['timingtrigval_' + var_name_app] = list(option_dict.items())[0][1]
            else:  # range
                trig_comp = z3.Const('timingtrigcomp_' + var_name_app, ComparatorRange)
                self.timing_trig_comp_list.append(trig_comp)
                self.z3_var_dict['timingtrigcomp_' + var_name_app] = trig_comp
                self.z3_var_default_val_dict['timingtrigcomp_' + var_name_app] = ComparatorRange.eq
                trig_val = z3.Int('timingtrigval_' + var_name_app)
                self.timing_trig_val_list.append(trig_val)
                self.z3_var_dict['timingtrigval_' + var_name_app] = trig_val
                self.z3_var_default_val_dict['timingtrigval_' + var_name_app] = 0

        # initialize ap z3 list
        for cap, typ in zip(self.ap_cap_list, self.ap_cap_typ_list):
            var_name_app = '%s_%d' % (cap, id(self))
            ap_show = z3.Bool('apshow_' + var_name_app)
            self.ap_show_list.append(ap_show)
            self.z3_var_dict['apshow_' + var_name_app] = ap_show
            self.z3_var_default_val_dict['apshow_' + var_name_app] = False
            ap_comp = z3.Const('apcomp_' + var_name_app, ComparatorRange if typ == 'numeric' else Comparator)
            self.ap_comp_list.append(ap_comp)
            self.z3_var_dict['apcomp_' + var_name_app] = ap_comp
            self.z3_var_default_val_dict['apcomp_' + var_name_app] = \
                ComparatorRange.eq if typ == 'numeric' else Comparator.eq
            if typ == 'bool':
                ap_val = z3.Bool('apval_' + var_name_app)
                self.ap_val_list.append(ap_val)
                self.z3_var_dict['apval_' + var_name_app] = ap_val
                self.z3_var_default_val_dict['apval_' + var_name_app] = False
            elif typ == 'set':
                SetType, option_dict = set_z3_dict[cap]
                ap_val = z3.Const('apval_' + var_name_app, SetType)
                self.ap_val_list.append(ap_val)
                self.z3_var_dict['apval_' + var_name_app] = ap_val
                self.z3_var_default_val_dict['apval_' + var_name_app] = list(option_dict.items())[0][1]
            else:  # range
                ap_val = z3.Int('apval_' + var_name_app)
                self.ap_val_list.append(ap_val)
                self.z3_var_dict['apval_' + var_name_app] = ap_val
                self.z3_var_default_val_dict['apval_' + var_name_app] = 0

    def trigger(self, event: EventExpression, pre_condition_dict: Dict[str, Any]):
        if event.hold_t:
            if (event.var, event.hold_t) not in self.timing_cap_list:
                return None, None
            trigger_time_index = self.timing_cap_list.index((event.var, event.hold_t))
            trigger_time_typ = self.timing_cap_typ_list[trigger_time_index]
            trigger_time_show = self.timing_trig_show_list[trigger_time_index]
            trigger_time_comp = self.timing_trig_comp_list[trigger_time_index]
            trigger_time_val = self.timing_trig_val_list[trigger_time_index]
            trigger_sat = z3.And(checkExpression(event.val, trigger_time_val, trigger_time_comp, trigger_time_typ),
                                  trigger_time_show)
        else:
            if event.var not in self.trig_cap_list:
                return None, None
            trigger_index = self.trig_cap_list.index(event.var)
            trigger_typ = self.trig_cap_typ_list[trigger_index]
            trigger_show = self.trig_show_list[trigger_index]
            trigger_comp = self.trig_comp_list[trigger_index]
            trigger_val = self.trig_val_list[trigger_index]
            # we need to check whether trigger is satisfied previously
            trigger_p_sat = checkExpression(pre_condition_dict[event.var], trigger_val, trigger_comp, trigger_typ)
            trigger_sat = z3.And(checkExpression(event.val, trigger_val, trigger_comp, trigger_typ), 
                                 trigger_show, z3.Not(trigger_p_sat))

        cond_sat_list = [z3.Implies(ap_show, checkExpression(pre_condition_dict[ap_cap], ap_val, ap_comp, ap_typ))
                         for ap_cap, ap_typ, ap_show, ap_comp, ap_val in
                         zip(self.ap_cap_list, self.ap_cap_typ_list, self.ap_show_list,
                             self.ap_comp_list, self.ap_val_list)]
        cond_sat = z3.And(cond_sat_list)

        return self.action, z3.And(self.show_symb, trigger_sat, cond_sat)

    def timePass(self, start_time: datetime.datetime, end_time: datetime.datetime, pre_condition_dict: Dict[str, Any]):
        # TODO: check jump of day
        start_date = start_time.date()
        end_date = end_time.date()
        current_date = start_date
        clock_sat_list = []
        while current_date <= end_date:
            st = start_time.time() if current_date == start_date else datetime.time.min
            et = end_time.time() if current_date == end_date else datetime.time.max
            st_sec = st.hour * 3600 + st.minute * 60 + st.second
            et_sec = et.hour * 3600 + et.minute * 60 + et.second
            clock_sat_entry = z3.And(self.clock_trig_val > st_sec \
                                     if current_date == start_date \
                                     else self.clock_trig_val >= st_sec,
                                     self.clock_trig_val <= et_sec)
            clock_sat_list.append(clock_sat_entry)
            current_date += datetime.date.resolution
        clock_sat = z3.And(z3.And(clock_sat_list), self.clock_trig_show)
        cond_sat_list = [z3.Implies(ap_show, checkExpression(pre_condition_dict[ap_cap], ap_val, ap_comp, ap_typ))
                         for ap_cap, ap_typ, ap_show, ap_comp, ap_val in
                         zip(self.ap_cap_list, self.ap_cap_typ_list, self.ap_show_list,
                             self.ap_comp_list, self.ap_val_list)]
        cond_sat = z3.And(cond_sat_list)

        return self.action, z3.And(self.show_symb, clock_sat, cond_sat)

    def to_tap(self, var_resolve: dict=None):
        if var_resolve is None:
            var_resolve = dict()

        if str(self.show_symb) in var_resolve and var_resolve[str(self.show_symb)]:
            # showing the rule
            trigger = None
            comp_dict = {'eq': '=', 'neq': '!=', 'gt': '>', 'lt': '<', 'geq': '>=', 'leq': '<='}
            # resolving the trigger
            for trig_show, trig_cap, trig_comp, trig_val, trig_typ in zip(self.trig_show_list, self.trig_cap_list,
                                                                          self.trig_comp_list, self.trig_val_list,
                                                                          self.trig_cap_typ_list):
                if str(trig_show) in var_resolve and var_resolve[str(trig_show)]:
                    # this is the trigger to be selected
                    val = str(var_resolve[str(trig_val)]).lower() if trig_typ == 'bool' \
                        else str(var_resolve[str(trig_val)])
                    comp = comp_dict[str(var_resolve[str(trig_comp)])] if trig_typ == 'numeric' else '='

                    trigger = trig_cap + comp + val
                    break
            else:
                for timing_trig_show, timing_trig_cap_t, timing_trig_comp, timing_trig_val, timing_trig_typ in \
                        zip(self.timing_trig_show_list, self.timing_cap_list,
                            self.timing_trig_comp_list, self.timing_trig_val_list, self.timing_cap_typ_list):
                    timing_trig_cap, timing_trig_time = timing_trig_cap_t
                    if str(timing_trig_show) in var_resolve and var_resolve[str(timing_trig_show)]:
                        # this is the trigger to be selected
                        val = str(var_resolve[str(timing_trig_val)]).lower() if timing_trig_typ == 'bool' \
                            else str(var_resolve[str(timing_trig_val)])
                        comp = comp_dict[str(var_resolve[str(timing_trig_comp)])] \
                            if timing_trig_typ == 'numeric' else '='
                        trigger = str(timing_trig_time) + '*' + timing_trig_cap + comp + val
                        break
                else:
                    if str(self.clock_trig_show) in var_resolve and var_resolve[str(self.clock_trig_show)]:
                        # the clock trigger is chosen
                        clock_trig_val = int(var_resolve[str(self.clock_trig_val)].as_long())
                        trigger = 'clock.clock_time=%d' % clock_trig_val
                    else:
                        raise Exception('rule is shown but no trigger is selected')
            # resolving the condition
            condition = list()
            for ap_show, ap_cap, ap_comp, ap_val, ap_typ in zip(self.ap_show_list, self.ap_cap_list,
                                                                self.ap_comp_list, self.ap_val_list,
                                                                self.ap_cap_typ_list):
                if str(ap_show) in var_resolve and var_resolve[str(ap_show)]:
                    # this ap is selected
                    val = str(var_resolve[str(ap_val)]).lower() if ap_typ == 'bool' else str(var_resolve[str(ap_val)])
                    comp = comp_dict[str(var_resolve[str(ap_comp)])]
                    condition.append(ap_cap + comp + val)
            # resolving the action
            action_val = str(self.action.val).lower() if self.action_cap_typ == 'bool' else str(self.action.val)
            action = self.action.var + self.action.comp + action_val

            return Tap(trigger=trigger, condition=condition, action=action)
        else:
            # not showing the rule
            return None

    def getSyntaxConstraints(self):
        """
        this one will get all syntax constraints within the system
        1) when clause doesn't show up, use default value
        2) for boolean ap, keep using '=false' instead of '!=true'
        3) cap in trigger should not show up in condition
        4) for range ap, shouldn't be using '=' or '!='
        5) only one trigger is selected
        6) for clock trigger, we should only do exact seconds
        :return:
        """
        constraints = list()
        # 0) when rule doesn't show up, not showing all triggers and aps
        for trig_show in self.trig_show_list:
            constraints.append(z3.Implies(z3.Not(self.show_symb), z3.Not(trig_show)))
        for timing_trig_show in self.timing_trig_show_list:
            constraints.append(z3.Implies(z3.Not(self.show_symb), z3.Not(timing_trig_show)))
        for ap_show in self.ap_show_list:
            constraints.append(z3.Implies(z3.Not(self.show_symb), z3.Not(ap_show)))
        # 1) when clause doesn't show up, use default value
        for trig_show, trig_comp, trig_val in zip(self.trig_show_list, self.trig_comp_list, self.trig_val_list):
            if str(trig_comp) in self.z3_var_dict:
                constraints.append(z3.Implies(z3.Not(trig_show),
                                              trig_comp == self.z3_var_default_val_dict[str(trig_comp)]))
            if str(trig_val) in self.z3_var_dict:
                constraints.append(z3.Implies(z3.Not(trig_show),
                                              trig_val == self.z3_var_default_val_dict[str(trig_val)]))
        for timing_trig_show, timing_trig_comp, timing_trig_val in zip(self.timing_trig_show_list,
                                                                       self.timing_trig_comp_list,
                                                                       self.timing_trig_val_list):
            if str(timing_trig_comp) in self.z3_var_dict:
                constraints.append(z3.Implies(z3.Not(timing_trig_show),
                                              timing_trig_comp == self.z3_var_default_val_dict[str(timing_trig_comp)]))
            if str(timing_trig_val) in self.z3_var_dict:
                constraints.append(z3.Implies(z3.Not(timing_trig_show),
                                              timing_trig_val == self.z3_var_default_val_dict[str(timing_trig_val)]))
        for ap_show, ap_comp, ap_val in zip(self.ap_show_list, self.ap_comp_list, self.ap_val_list):
            if str(ap_comp) in self.z3_var_dict:
                constraints.append(z3.Implies(z3.Not(ap_show), ap_comp == self.z3_var_default_val_dict[str(ap_comp)]))
            if str(ap_val) in self.z3_var_dict:
                constraints.append(z3.Implies(z3.Not(ap_show), ap_val == self.z3_var_default_val_dict[str(ap_val)]))
        # 2) for boolean ap, keep using '=false' instead of '!=true'
        for ap_comp, ap_typ in zip(self.ap_comp_list, self.ap_cap_typ_list):
            if ap_typ == 'bool':
                constraints.append(ap_comp == Comparator.eq)
        # 3) cap in trigger should not show up in condition
        for trig_cap, trig_show in zip(self.trig_cap_list, self.trig_show_list):
            if trig_cap in self.ap_cap_list:
                ap_index = self.ap_cap_list.index(trig_cap)
                ap_show = self.ap_show_list[ap_index]
                constraints.append(z3.Not(z3.And(trig_show, ap_show)))
        for timing_trig_cap_t, timing_trig_show in zip(self.timing_cap_list, self.timing_trig_show_list):
            timing_trig_cap, _ = timing_trig_cap_t
            if timing_trig_cap in self.ap_cap_list:
                ap_index = self.ap_cap_list.index(timing_trig_cap)
                ap_show = self.ap_show_list[ap_index]
                constraints.append(z3.Not(z3.And(timing_trig_show, ap_show)))
        # 4) for range ap, shouldn't be using '=', '!=', '<=' or '>='
        for trig_show, trig_comp, trig_typ in zip(self.trig_show_list, self.trig_comp_list, self.trig_cap_typ_list):
            if trig_typ == 'numeric':
                constraints.append(z3.Implies(trig_show, trig_comp != ComparatorRange.eq))
                constraints.append(z3.Implies(trig_show, trig_comp != ComparatorRange.neq))
                constraints.append(z3.Implies(trig_show, trig_comp != ComparatorRange.geq))
                constraints.append(z3.Implies(trig_show, trig_comp != ComparatorRange.leq))
        for timing_trig_show, timing_trig_comp, timing_trig_typ in zip(self.timing_trig_show_list,
                                                                       self.timing_trig_comp_list,
                                                                       self.timing_cap_typ_list):
            if timing_trig_typ == 'numeric':
                constraints.append(z3.Implies(timing_trig_show, timing_trig_comp != ComparatorRange.eq))
                constraints.append(z3.Implies(timing_trig_show, timing_trig_comp != ComparatorRange.neq))
                constraints.append(z3.Implies(timing_trig_show, timing_trig_comp != ComparatorRange.geq))
                constraints.append(z3.Implies(timing_trig_show, timing_trig_comp != ComparatorRange.leq))
        for ap_show, ap_comp, ap_typ in zip(self.ap_show_list, self.ap_comp_list, self.ap_cap_typ_list):
            if ap_typ == 'numeric':
                constraints.append(z3.Implies(ap_show, ap_comp != ComparatorRange.eq))
                constraints.append(z3.Implies(ap_show, ap_comp != ComparatorRange.neq))
                constraints.append(z3.Implies(ap_show, ap_comp != ComparatorRange.geq))
                constraints.append(z3.Implies(ap_show, ap_comp != ComparatorRange.leq))
        # 5) only one trigger is selected
        constraints += [z3.Implies(self.show_symb, sum([z3.If(lbd, 1, 0) for lbd in self.trig_show_list] +
                                                       [z3.If(lbd, 1, 0) for lbd in self.timing_trig_show_list] +
                                                       [z3.If(self.clock_trig_show, 1, 0)]) == 1)]
        # 6) for clock trigger, we should only do exact seconds
        constraints += [self.clock_trig_val % 60 == 0]
        return constraints

    def getAllZ3Variables(self):
        return self.z3_var_dict, self.z3_var_default_val_dict

    def _getTypeVars(self, typ):
        result = []
        for trig_val, trig_typ in zip(self.trig_val_list, self.trig_cap_typ_list):
            if trig_typ == typ:
                result.append(str(trig_val))
        for timing_trig_val, timing_trig_typ in zip(self.timing_trig_val_list, self.timing_cap_typ_list):
            if timing_trig_typ == typ:
                result.append(str(timing_trig_val))
        for ap_val, ap_typ in zip(self.ap_val_list, self.ap_cap_typ_list):
            if ap_typ == typ:
                result.append(str(ap_val))
        result.append(str(self.clock_trig_val))
        return result

    def getRangeVars(self):
        return self._getTypeVars('numeric')

    def getSetVars(self):
        return self._getTypeVars('set')
