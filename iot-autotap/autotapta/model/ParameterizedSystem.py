import abc
import z3
from typing import List, Tuple, Dict, Any
from autotapmc.channels.template.DbTemplate import template_dict as db_template_dict
from autotapmc.model.Tap import Tap
from autotapta.model.Rule import RegRule, SymbRule
from autotapta.model.Util import EventExpression, ActionExpression, ConditionExpression, TriggerExpression, \
                                 Comparator, ComparatorRange, checkExpression
import datetime


class ParameterizedSystem(object):

    @abc.abstractmethod
    def applyAction(self, action):
        pass

    @abc.abstractmethod
    def getStateValue(self, cap):
        pass

    @abc.abstractmethod
    def getAllZ3Variables(self):
        pass


class SynthParSystem(ParameterizedSystem):
    def __init__(self, cap_list, target_action, tap_list=[], init_value_dict={}, template_dict=db_template_dict):
        # total dict of z3 variables
        self.z3_var_dict = dict()
        self.z3_var_default_val_dict = dict()

        # construct z3 enum type for comparators
        self.Comparator = z3.Datatype('Comparator')
        self.Comparator.declare('eq')
        self.Comparator.declare('neq')
        self.Comparator = self.Comparator.create()
        self.ComparatorRange = z3.Datatype('ComparatorRange')
        self.ComparatorRange.declare('gt')
        self.ComparatorRange.declare('lt')
        self.ComparatorRange.declare('geq')
        self.ComparatorRange.declare('leq')
        self.ComparatorRange.declare('eq')
        self.ComparatorRange.declare('neq')
        self.ComparatorRange = self.ComparatorRange.create()

        # construct z3 enum for set types
        self.set_z3_dict = dict()
        for cap in cap_list:
            typ = template_dict[cap.split('.')[0]][cap.split('.')[1]]
            if typ.startswith('set'):
                opt_list = typ.split('[')[-1][:-1].split(', ')  # all possible actions of the set var
                var_z3_type, opt_z3_tuple = z3.EnumSort(cap, tuple(opt_list))  # turn the set var into z3 enum
                self.set_z3_dict[cap] = \
                    (var_z3_type, dict(zip(opt_list, opt_z3_tuple)))  # key: var name, value: (z3var, optdict)

        cap_type_list = [template_dict[cap.split('.')[0]][cap.split('.')[1]] for cap in cap_list]

        # z3 variables
        self.trigshow_list = list()
        self.trigcomp_list = list()
        self.trigval_list = list()
        self.apshow_list = list()
        self.apcomp_list = list()
        self.apval_list = list()

        for cap, typ in zip(cap_list, cap_type_list):
            self.trigshow_list.append(z3.Bool('trigshow_'+cap))
            self.apshow_list.append(z3.Bool('apshow_'+cap))
            self.z3_var_dict['trigshow_'+cap] = self.trigshow_list[-1]
            self.z3_var_dict['apshow_'+cap] = self.apshow_list[-1]
            self.z3_var_default_val_dict['trigshow_'+cap] = False
            self.z3_var_default_val_dict['apshow_'+cap] = False
            if typ.startswith('bool'):
                self.trigcomp_list.append(self.Comparator.eq)
                self.trigval_list.append(z3.Bool('trigval_'+cap))
                self.apcomp_list.append(z3.Const('apcomp_'+cap, self.Comparator))
                self.apval_list.append(z3.Bool('apval_'+cap))
                self.z3_var_dict['trigval_'+cap] = self.trigval_list[-1]
                self.z3_var_dict['apcomp_'+cap] = self.apcomp_list[-1]
                self.z3_var_dict['apval_'+cap] = self.apval_list[-1]
                self.z3_var_default_val_dict['trigval_'+cap] = False
                self.z3_var_default_val_dict['apcomp_'+cap] = self.Comparator.eq
                self.z3_var_default_val_dict['apval_'+cap] = False
            elif typ.startswith('set'):
                self.trigcomp_list.append(self.Comparator.eq)
                self.trigval_list.append(z3.Const('trigval_'+cap, self.set_z3_dict[cap][0]))
                self.apcomp_list.append(z3.Const('apcomp_' + cap, self.Comparator))
                self.apval_list.append(z3.Const('apval_'+cap, self.set_z3_dict[cap][0]))
                self.z3_var_dict['trigval_'+cap] = self.trigval_list[-1]
                self.z3_var_dict['apcomp_'+cap] = self.apcomp_list[-1]
                self.z3_var_dict['apval_'+cap] = self.apval_list[-1]
                self.z3_var_default_val_dict['trigval_'+cap] = list(self.set_z3_dict[cap][1].items())[0][1]
                self.z3_var_default_val_dict['apcomp_'+cap] = self.Comparator.eq
                self.z3_var_default_val_dict['apval_'+cap] = list(self.set_z3_dict[cap][1].items())[0][1]
            else:
                self.trigcomp_list.append(z3.Const('trigcomp_'+cap, self.ComparatorRange))
                self.trigval_list.append(z3.Int('trigval_'+cap))
                self.apcomp_list.append(z3.Const('apcomp_'+cap, self.ComparatorRange))
                self.apval_list.append(z3.Int('apval_'+cap))
                self.z3_var_dict['trigcomp_'+cap] = self.trigcomp_list[-1]
                self.z3_var_dict['trigval_'+cap] = self.trigval_list[-1]
                self.z3_var_dict['apcomp_'+cap] = self.apcomp_list[-1]
                self.z3_var_dict['apval_'+cap] = self.apval_list[-1]
                self.z3_var_default_val_dict['trigcomp_'+cap] = self.ComparatorRange.eq
                self.z3_var_default_val_dict['trigval_'+cap] = 0
                self.z3_var_default_val_dict['apcomp_'+cap] = self.ComparatorRange.eq
                self.z3_var_default_val_dict['apval_'+cap] = 0

        # running state value
        self.cap_list = cap_list
        self.cap_type_list = [typ.split(',')[0] for typ in cap_type_list]
        self.value_list = list()
        for cap, typ in zip(cap_list, cap_type_list):
            if cap in init_value_dict:
                if typ.startswith('bool'):
                    self.value_list.append(bool(init_value_dict[cap]))
                elif typ.startswith('set'):
                    self.value_list.append(self.set_z3_dict[cap][1][init_value_dict[cap]])
                else:
                    self.value_list.append(int(float(init_value_dict[cap])))
            else:
                if typ.startswith('bool'):
                    self.value_list.append(False)
                elif typ.startswith('set'):
                    self.value_list.append(list(self.set_z3_dict[cap][1].items())[0][1])
                else:
                    self.value_list.append(0)

        # target action
        self.target_action = target_action

        # tap rules
        self.tap_list = tap_list

    def resetInitState(self, init_value_dict={}):
        # running state value
        for cap, typ, index in zip(self.cap_list, self.cap_type_list, range(len(self.cap_list))):
            if cap in init_value_dict:
                if typ.startswith('bool'):
                    self.value_list[index] = bool(init_value_dict[cap])
                elif typ.startswith('set'):
                    self.value_list[index] = self.set_z3_dict[cap][1][init_value_dict[cap]]
                else:
                    self.value_list[index] = int(float(init_value_dict[cap]))
            else:
                if typ.startswith('bool'):
                    self.value_list[index] = False
                elif typ.startswith('set'):
                    self.value_list[index] = list(self.set_z3_dict[cap][1].items())[0][1]
                else:
                    self.value_list[index] = 0

    def _applyActionConditional(self, action, condition):
        cap_name = action.split('=')[0]
        if cap_name not in self.cap_list:
            return
        action_cap, action_comp, action_val = self._convertFormulaToZ3(action)

        # which old rule is triggered?
        trigger_bit_existing_taps = [False] * len(self.tap_list)
        for tap, tap_index in zip(self.tap_list, range(len(self.tap_list))):
            if action == tap.trigger:
                cond_sat_list = list()
                for cond in tap.condition:
                    cond_cap, cond_comp, cond_val = self._convertFormulaToZ3(cond)
                    cond_sat = self._checkCondition(cond_cap, cond_comp, cond_val)
                    cond_sat_list.append(cond_sat)
                trigger_bit = z3.And(cond_sat_list)
            else:
                trigger_bit = False
            trigger_bit_existing_taps[tap_index] = trigger_bit

        # whether the new rule is triggered?
        trigger_bit_new_rule_list = list()
        for trigger_cap, trigger_show, trigger_comp, trigger_value in \
                zip(self.cap_list, self.trigshow_list, self.trigcomp_list, self.trigval_list):
            trigger_sat = self._checkIfActionIsTrigger(action_cap, action_val,
                                                       trigger_cap, trigger_comp, trigger_value)
            trigger_sat = z3.And(trigger_show, trigger_sat)
            cond_sat_list = [z3.Implies(cond_show, self._checkCondition(cond_cap, cond_comp, cond_val))
                             for cond_show, cond_cap, cond_comp, cond_val in
                             zip(self.apshow_list, self.cap_list, self.apcomp_list, self.apval_list)]
            cond_sat = z3.And(cond_sat_list)
            trigger_bit_new_rule_list.append(z3.And(trigger_sat, cond_sat))
        trigger_bit_new_rule = z3.Or(trigger_bit_new_rule_list)

        # conditionally apply the action
        self.value_list[self.cap_list.index(action_cap)] = z3.If(condition,
                                                                 action_val,
                                                                 self.value_list[self.cap_list.index(action_cap)])

        # send back the triggered actions
        following_action_tup = list()
        for tap, trigger_bit in zip(self.tap_list, trigger_bit_existing_taps):
            following_action_tup.append((tap.action, z3.And(trigger_bit, condition)))
        following_action_tup.append((self.target_action, z3.And(trigger_bit_new_rule, condition)))
        return following_action_tup

    def applyAction(self, action):
        cap_name = action.split('=')[0]
        if cap_name not in self.cap_list:
            return

        action_cache = list()
        action_cache.append((action, True, 1))

        while action_cache:
            current_action, condition, depth = action_cache.pop(0)
            if depth < 3:
                additional_actions = self._applyActionConditional(current_action, condition)
                for additional_act, additional_cond in additional_actions:
                    action_cache.append((additional_act, additional_cond, depth+1))

    def getStateValue(self, cap):
        return self.value_list[self.cap_list.index(cap)]

    def getAllZ3Variables(self):
        return self.z3_var_dict, self.z3_var_default_val_dict

    def getZ3SetDict(self):
        return self.set_z3_dict

    def getTriggerZ3Vars(self):
        return self.trigshow_list, self.trigcomp_list, self.trigval_list

    def getApZ3Vars(self):
        return self.apshow_list, self.apcomp_list, self.apval_list

    def getRangeVars(self):
        range_var_list = [cap for cap, typ in zip(self.cap_list, self.cap_type_list) if typ.startswith('numeric')]
        trigval_list = ['trigval_'+cap for cap in range_var_list]
        apval_list = ['apval_'+cap for cap in range_var_list]
        return trigval_list + apval_list

    def _checkCondition(self, cond_cap: str, cond_comp, cond_val):
        # should return a z3 boolean formula representing the condition is satisfied
        cap_index = self.cap_list.index(cond_cap)
        cap_type = self.cap_type_list[cap_index]
        cap_value = self.value_list[cap_index]

        if cap_type == 'numeric':
            eq_clause = z3.And(cond_comp == self.ComparatorRange.eq, cap_value == cond_val)
            neq_clause = z3.And(cond_comp == self.ComparatorRange.neq, cap_value != cond_val)
            gt_clause = z3.And(cond_comp == self.ComparatorRange.gt, cap_value > cond_val)
            lt_clause = z3.And(cond_comp == self.ComparatorRange.lt, cap_value < cond_val)
            geq_clause = z3.And(cond_comp == self.ComparatorRange.geq, cap_value >= cond_val)
            leq_clause = z3.And(cond_comp == self.ComparatorRange.leq, cap_value <= cond_val)
            sat_clause = z3.Or(eq_clause, neq_clause, gt_clause, lt_clause, geq_clause, leq_clause)
        else:
            eq_clause = z3.And(cond_comp == self.Comparator.eq, cap_value == cond_val)
            neq_clause = z3.And(cond_comp == self.Comparator.neq, cap_value != cond_val)
            sat_clause = z3.Or(eq_clause, neq_clause)

        return sat_clause

    def _checkIfActionIsTrigger(self, action_cap, action_val, trigger_cap, trigger_comp, trigger_val):
        action_cap_type = self.cap_type_list[self.cap_list.index(action_cap)]
        if action_cap == trigger_cap:
            if action_cap_type == 'numeric':
                eq_clause = z3.And(trigger_comp == self.ComparatorRange.eq, action_val == trigger_val)
                neq_clause = z3.And(trigger_comp == self.ComparatorRange.neq, action_val != trigger_val)
                gt_clause = z3.And(trigger_comp == self.ComparatorRange.gt, action_val > trigger_val)
                lt_clause = z3.And(trigger_comp == self.ComparatorRange.lt, action_val < trigger_val)
                geq_clause = z3.And(trigger_comp == self.ComparatorRange.geq, action_val >= trigger_val)
                leq_clause = z3.And(trigger_comp == self.ComparatorRange.leq, action_val <= trigger_val)
                clause = z3.Or(eq_clause, neq_clause, gt_clause, lt_clause, geq_clause, leq_clause)
            else:
                eq_clause = z3.And(trigger_comp == self.Comparator.eq, action_val == trigger_val)
                neq_clause = z3.And(trigger_comp == self.Comparator.neq, action_val != trigger_val)
                clause = z3.Or(eq_clause, neq_clause)
        else:
            clause = False
        return clause

    def _convertFormulaToZ3(self, formula):
        neg = False
        if formula.startswith('!'):
            neg = True
            formula = formula[1:]

        if '=' in formula:
            cap = formula.split('=')[0]
            value = formula.split('=')[1]
            comp = '=' if not neg else '!='
        elif '<' in formula:
            cap = formula.split('<')[0]
            value = formula.split('<')[1]
            comp = '<' if not neg else '>='
        else:
            cap = formula.split('>')[0]
            value = formula.split('>')[1]
            comp = '>' if not neg else '<='

        cap_index = self.cap_list.index(cap)
        cap_type = self.cap_type_list[cap_index]

        if cap_type == 'bool':
            value = value == 'true'
            comp = self.Comparator.eq if comp == '=' else self.Comparator.neq
        elif cap_type == 'set':
            value = self.set_z3_dict[cap][1][value]
            comp = self.Comparator.eq if comp == '=' else self.Comparator.neq
        else:
            value = int(float(value))
            comp = self.ComparatorRange.eq if comp == '=' else \
                (self.ComparatorRange.neq if comp == '!=' else
                 (self.ComparatorRange.gt if comp == '>' else
                  (self.ComparatorRange.lt if comp == '<' else
                   (self.ComparatorRange.geq if comp == '>=' else
                    self.ComparatorRange.leq))))

        return cap, comp, value


class SynthParSystemSplit(SynthParSystem):
    def __init__(self, cap_list, trig_cap_list, cond_cap_list, target_action,
                 tap_list=[], init_value_dict={}, template_dict=db_template_dict):
        # total dict of z3 variables
        self.z3_var_dict = dict()
        self.z3_var_default_val_dict = dict()

        # construct z3 enum type for comparators
        self.Comparator = z3.Datatype('Comparator')
        self.Comparator.declare('eq')
        self.Comparator.declare('neq')
        self.Comparator = self.Comparator.create()
        self.ComparatorRange = z3.Datatype('ComparatorRange')
        self.ComparatorRange.declare('gt')
        self.ComparatorRange.declare('lt')
        self.ComparatorRange.declare('geq')
        self.ComparatorRange.declare('leq')
        self.ComparatorRange.declare('eq')
        self.ComparatorRange.declare('neq')
        self.ComparatorRange = self.ComparatorRange.create()

        # construct z3 enum for set types
        self.set_z3_dict = dict()
        for cap in cap_list:
            typ = template_dict[cap.split('.')[0]][cap.split('.')[1]]
            if typ.startswith('set'):
                opt_list = typ.split('[')[-1][:-1].split(', ')  # all possible actions of the set var
                var_z3_type, opt_z3_tuple = z3.EnumSort(cap, tuple(opt_list))  # turn the set var into z3 enum
                self.set_z3_dict[cap] = \
                    (var_z3_type, dict(zip(opt_list, opt_z3_tuple)))  # key: var name, value: (z3var, optdict)

        cap_type_list = [template_dict[cap.split('.')[0]][cap.split('.')[1]] for cap in cap_list]
        trig_cap_type_list = [template_dict[cap.split('.')[0]][cap.split('.')[1]] for cap in trig_cap_list]
        cond_cap_type_list = [template_dict[cap.split('.')[0]][cap.split('.')[1]] for cap in cond_cap_list]

        # z3 variables
        self.trigshow_list = list()
        self.trigcomp_list = list()
        self.trigval_list = list()
        self.apshow_list = list()
        self.apcomp_list = list()
        self.apval_list = list()

        self.trig_cap_list = trig_cap_list
        for cap in trig_cap_list:
            typ = template_dict[cap.split('.')[0]][cap.split('.')[1]]
            self.trigshow_list.append(z3.Bool('trigshow_' + cap))
            self.z3_var_dict['trigshow_' + cap] = self.trigshow_list[-1]
            self.z3_var_default_val_dict['trigshow_' + cap] = False
            if typ.startswith('bool'):
                self.trigcomp_list.append(self.Comparator.eq)
                self.trigval_list.append(z3.Bool('trigval_' + cap))
                self.z3_var_dict['trigval_' + cap] = self.trigval_list[-1]
                self.z3_var_default_val_dict['trigval_' + cap] = False
            elif typ.startswith('set'):
                self.trigcomp_list.append(self.Comparator.eq)
                self.trigval_list.append(z3.Const('trigval_' + cap, self.set_z3_dict[cap][0]))
                self.z3_var_dict['trigval_' + cap] = self.trigval_list[-1]
                self.z3_var_default_val_dict['trigval_' + cap] = list(self.set_z3_dict[cap][1].items())[0][1]
            else:
                self.trigcomp_list.append(z3.Const('trigcomp_' + cap, self.ComparatorRange))
                self.trigval_list.append(z3.Int('trigval_' + cap))
                self.z3_var_dict['trigcomp_' + cap] = self.trigcomp_list[-1]
                self.z3_var_dict['trigval_' + cap] = self.trigval_list[-1]
                self.z3_var_default_val_dict['trigcomp_' + cap] = self.ComparatorRange.eq
                self.z3_var_default_val_dict['trigval_' + cap] = 0

        self.cond_cap_list = cond_cap_list
        for cap in cond_cap_list:
            typ = template_dict[cap.split('.')[0]][cap.split('.')[1]]
            self.apshow_list.append(z3.Bool('apshow_' + cap))
            self.z3_var_dict['apshow_' + cap] = self.apshow_list[-1]
            self.z3_var_default_val_dict['apshow_' + cap] = False
            if typ.startswith('bool'):
                self.apcomp_list.append(z3.Const('apcomp_' + cap, self.Comparator))
                self.apval_list.append(z3.Bool('apval_' + cap))
                self.z3_var_dict['apcomp_' + cap] = self.apcomp_list[-1]
                self.z3_var_dict['apval_' + cap] = self.apval_list[-1]
                self.z3_var_default_val_dict['apcomp_' + cap] = self.Comparator.eq
                self.z3_var_default_val_dict['apval_' + cap] = False
            elif typ.startswith('set'):
                self.apcomp_list.append(z3.Const('apcomp_' + cap, self.Comparator))
                self.apval_list.append(z3.Const('apval_' + cap, self.set_z3_dict[cap][0]))
                self.z3_var_dict['apcomp_' + cap] = self.apcomp_list[-1]
                self.z3_var_dict['apval_' + cap] = self.apval_list[-1]
                self.z3_var_default_val_dict['apcomp_' + cap] = self.Comparator.eq
                self.z3_var_default_val_dict['apval_' + cap] = list(self.set_z3_dict[cap][1].items())[0][1]
            else:
                self.apcomp_list.append(z3.Const('apcomp_' + cap, self.ComparatorRange))
                self.apval_list.append(z3.Int('apval_' + cap))
                self.z3_var_dict['apcomp_' + cap] = self.apcomp_list[-1]
                self.z3_var_dict['apval_' + cap] = self.apval_list[-1]
                self.z3_var_default_val_dict['apcomp_' + cap] = self.ComparatorRange.eq
                self.z3_var_default_val_dict['apval_' + cap] = 0

        # running state value
        self.cap_list = cap_list
        self.cap_type_list = [typ.split(',')[0] for typ in cap_type_list]
        self.trig_cap_type_list = [typ.split(',')[0] for typ in trig_cap_type_list]
        self.cond_cap_type_list = [typ.split(',')[0] for typ in cond_cap_type_list]
        self.value_list = list()
        for cap, typ in zip(cap_list, cap_type_list):
            if cap in init_value_dict:
                if typ.startswith('bool'):
                    self.value_list.append(bool(init_value_dict[cap]))
                elif typ.startswith('set'):
                    self.value_list.append(self.set_z3_dict[cap][1][init_value_dict[cap]])
                else:
                    self.value_list.append(int(float(init_value_dict[cap])))
            else:
                if typ.startswith('bool'):
                    self.value_list.append(False)
                elif typ.startswith('set'):
                    self.value_list.append(list(self.set_z3_dict[cap][1].items())[0][1])
                else:
                    self.value_list.append(0)

        # target action
        self.target_action = target_action

        # tap rules
        self.tap_list = tap_list

    def _applyActionConditional(self, action, condition):
        cap_name = action.split('=')[0]
        if cap_name not in self.cap_list:
            return
        action_cap, action_comp, action_val = self._convertFormulaToZ3(action)

        # which old rule is triggered?
        trigger_bit_existing_taps = [False] * len(self.tap_list)
        for tap, tap_index in zip(self.tap_list, range(len(self.tap_list))):
            if action == tap.trigger:
                cond_sat_list = list()
                for cond in tap.condition:
                    cond_cap, cond_comp, cond_val = self._convertFormulaToZ3(cond)
                    cond_sat = self._checkCondition(cond_cap, cond_comp, cond_val)
                    cond_sat_list.append(cond_sat)
                trigger_bit = z3.And(cond_sat_list)
            else:
                trigger_bit = False
            trigger_bit_existing_taps[tap_index] = trigger_bit

        # whether the new rule is triggered?
        trigger_bit_new_rule_list = list()
        for trigger_cap, trigger_show, trigger_comp, trigger_value in \
                zip(self.trig_cap_list, self.trigshow_list, self.trigcomp_list, self.trigval_list):
            trigger_sat = self._checkIfActionIsTrigger(action_cap, action_val,
                                                       trigger_cap, trigger_comp, trigger_value)
            trigger_sat = z3.And(trigger_show, trigger_sat)
            cond_sat_list = [z3.Implies(cond_show, self._checkCondition(cond_cap, cond_comp, cond_val))
                             for cond_show, cond_cap, cond_comp, cond_val in
                             zip(self.apshow_list, self.cond_cap_list, self.apcomp_list, self.apval_list)]
            cond_sat = z3.And(cond_sat_list)
            trigger_bit_new_rule_list.append(z3.And(trigger_sat, cond_sat))
        trigger_bit_new_rule = z3.Or(trigger_bit_new_rule_list)

        # conditionally apply the action
        self.value_list[self.cap_list.index(action_cap)] = z3.If(condition,
                                                                 action_val,
                                                                 self.value_list[self.cap_list.index(action_cap)])

        # send back the triggered actions
        following_action_tup = list()
        for tap, trigger_bit in zip(self.tap_list, trigger_bit_existing_taps):
            following_action_tup.append((tap.action, z3.And(trigger_bit, condition)))
        following_action_tup.append((self.target_action, z3.And(trigger_bit_new_rule, condition)))
        return following_action_tup

    def getRangeVars(self):
        range_var_list = [cap for cap, typ in zip(self.cap_list, self.cap_type_list) if typ.startswith('numeric')]
        trigval_list = ['trigval_'+cap for cap in self.trig_cap_list if cap in range_var_list]
        apval_list = ['apval_'+cap for cap in self.cond_cap_list if cap in range_var_list]
        return trigval_list + apval_list


class SynthTimeSystem(SynthParSystem):
    def __init__(self, cap_list, target_action, tap_list=[], init_value_dict={},
                 template_dict=db_template_dict, timing_cap_list=list()):
        super(SynthTimeSystem, self).__init__(cap_list, target_action, tap_list, init_value_dict, template_dict)

        self.timing_cap_list = timing_cap_list
        self.timing_cap_type_list = [self.cap_type_list[self.cap_list.index(cap)] for cap, _ in self.timing_cap_list]
        self.timing_trigshow_list = list()
        self.timing_trigcomp_list = list()
        self.timing_trigval_list = list()

        for timing_cap_tup, timing_cap_type in zip(self.timing_cap_list, self.timing_cap_type_list):
            timing_cap, time = timing_cap_tup
            self.timing_trigshow_list.append(z3.Bool('timingtrigshow_'+timing_cap))
            self.z3_var_dict['timingtrigshow_'+timing_cap] = self.timing_trigshow_list[-1]
            self.z3_var_default_val_dict['timingtrigshow_'+timing_cap] = False

            if timing_cap_type.startswith('bool'):
                self.timing_trigcomp_list.append(self.Comparator.eq)
                self.timing_trigval_list.append(z3.Bool('timingtrigval_'+timing_cap))
                self.z3_var_dict['timingtrigval_'+timing_cap] = self.timing_trigval_list[-1]
                self.z3_var_default_val_dict['timingtrigval_'+timing_cap] = False
            elif timing_cap_type.startswith('set'):
                self.timing_trigcomp_list.append(self.Comparator.eq)
                self.timing_trigval_list.append(z3.Const('timingtrigval_' + timing_cap,
                                                         self.set_z3_dict[timing_cap][0]))
                self.z3_var_dict['timingtrigval_' + timing_cap] = self.timing_trigval_list[-1]
                self.z3_var_default_val_dict['timingtrigval_' + timing_cap] = \
                    list(self.set_z3_dict[timing_cap][1].items())[0][1]
            else:
                self.timing_trigcomp_list.append(z3.Const('timingtrigcomp_' + timing_cap, self.ComparatorRange))
                self.timing_trigval_list.append(z3.Int('timingtrigval_' + timing_cap))
                self.z3_var_dict['timingtrigcomp_' + timing_cap] = self.timing_trigcomp_list[-1]
                self.z3_var_dict['timingtrigval_' + timing_cap] = self.timing_trigval_list[-1]
                self.z3_var_default_val_dict['timingtrigcomp_' + timing_cap] = self.ComparatorRange.eq
                self.z3_var_default_val_dict['timingtrigval_' + timing_cap] = 0

    def _applyActionConditional(self, action, condition):
        if '#' in action:
            time_span, raw_action = action.split('#')
            time_span = int(time_span)
        else:
            time_span = None
            raw_action = action

        cap_name = raw_action.split('=')[0]
        if cap_name not in self.cap_list:
            return
        action_cap, action_comp, action_val = self._convertFormulaToZ3(raw_action)

        # send back the triggered actions
        following_action_tup = list()

        if not time_span:  # not a timing event
            # which old rule is triggered?
            trigger_bit_existing_taps = [False] * len(self.tap_list)
            for tap, tap_index in zip(self.tap_list, range(len(self.tap_list))):
                if action == tap.trigger:
                    cond_sat_list = list()
                    for cond in tap.condition:
                        cond_cap, cond_comp, cond_val = self._convertFormulaToZ3(cond)
                        cond_sat = self._checkCondition(cond_cap, cond_comp, cond_val)
                        cond_sat_list.append(cond_sat)
                    trigger_bit = z3.And(cond_sat_list)
                else:
                    trigger_bit = False
                trigger_bit_existing_taps[tap_index] = trigger_bit

            # whether the new rule is triggered?
            trigger_bit_new_rule_list = list()
            for trigger_cap, trigger_show, trigger_comp, trigger_value in \
                    zip(self.cap_list, self.trigshow_list, self.trigcomp_list, self.trigval_list):
                trigger_sat = self._checkIfActionIsTrigger(action_cap, action_val,
                                                           trigger_cap, trigger_comp, trigger_value)
                trigger_sat = z3.And(trigger_show, trigger_sat)
                cond_sat_list = [z3.Implies(cond_show, self._checkCondition(cond_cap, cond_comp, cond_val))
                                 for cond_show, cond_cap, cond_comp, cond_val in
                                 zip(self.apshow_list, self.cap_list, self.apcomp_list, self.apval_list)]
                cond_sat = z3.And(cond_sat_list)
                trigger_bit_new_rule_list.append(z3.And(trigger_sat, cond_sat))
            trigger_bit_new_rule = z3.Or(trigger_bit_new_rule_list)

            # conditionally apply the action
            self.value_list[self.cap_list.index(action_cap)] = z3.If(condition,
                                                                     action_val,
                                                                     self.value_list[self.cap_list.index(action_cap)])

            for tap, trigger_bit in zip(self.tap_list, trigger_bit_existing_taps):
                following_action_tup.append((tap.action, z3.And(trigger_bit, condition)))
            following_action_tup.append((self.target_action, z3.And(trigger_bit_new_rule, condition)))

        else:  # a timing event
            # whether the new rule (timing related) is triggered
            trigger_bit_new_timing_rule_list = list()
            for timing_cap_time, timing_trigger_show, timing_trigger_comp, timing_trigger_val in \
                    zip(self.timing_cap_list, self.timing_trigshow_list,
                        self.timing_trigcomp_list, self.timing_trigval_list):
                timing_trigger_cap, timing_trigger_time = timing_cap_time
                trigger_sat = self._checkIfActionIsTrigger(action_cap, action_val,
                                                           timing_trigger_cap, timing_trigger_comp, timing_trigger_val)
                trigger_sat = z3.And(timing_trigger_show, trigger_sat)
                cond_sat_list = [z3.Implies(cond_show, self._checkCondition(cond_cap, cond_comp, cond_val))
                                 for cond_show, cond_cap, cond_comp, cond_val in
                                 zip(self.apshow_list, self.cap_list, self.apcomp_list, self.apval_list)]
                cond_sat = z3.And(cond_sat_list)
                trigger_bit_new_timing_rule_list.append(z3.And(trigger_sat, cond_sat))
            trigger_bit_new_timing_rule = z3.Or(trigger_bit_new_timing_rule_list)
            # no need to apply action for timing events
            following_action_tup.append((self.target_action, z3.And(trigger_bit_new_timing_rule, condition)))

        return following_action_tup

    def applyAction(self, action):
        if '#' not in action:
            cap_name = action.split('=')[0]
        else:
            cap_name = action.split('#')[1].split('=')[0]
        if cap_name not in self.cap_list:
            return

        action_cache = list()
        action_cache.append((action, True, 1))

        while action_cache:
            current_action, condition, depth = action_cache.pop(0)
            if depth < 3:
                additional_actions = self._applyActionConditional(current_action, condition)
                for additional_act, additional_cond in additional_actions:
                    action_cache.append((additional_act, additional_cond, depth+1))

    def getTimingZ3Vars(self):
        return self.timing_trigshow_list, self.timing_trigcomp_list, self.timing_trigval_list

    def getRangeVars(self):
        range_var_list = [cap for cap, typ in zip(self.cap_list, self.cap_type_list) if typ.startswith('numeric')]
        trigval_list = ['trigval_'+cap for cap in range_var_list]
        time_trigval_list = ['timingtrigval_' + timing_tup[0]
                             for timing_tup, typ in zip(self.timing_cap_list, self.timing_cap_type_list)
                             if typ.startswith('numeric')]
        apval_list = ['apval_'+cap for cap in range_var_list]
        return trigval_list + apval_list + time_trigval_list


class SynthTimeSystemSplit(SynthParSystemSplit):
    def __init__(self, cap_list, target_action, trig_cap_list, cond_cap_list, tap_list=[], init_value_dict={},
                 template_dict=db_template_dict, timing_cap_list=list()):
        super(SynthTimeSystemSplit, self).__init__(cap_list, trig_cap_list, cond_cap_list,
                                                   target_action, tap_list, init_value_dict, template_dict)

        self.timing_cap_list = timing_cap_list
        self.timing_cap_type_list = [self.cap_type_list[self.cap_list.index(cap)] for cap, _ in self.timing_cap_list]
        self.timing_trigshow_list = list()
        self.timing_trigcomp_list = list()
        self.timing_trigval_list = list()

        for timing_cap_tup, timing_cap_type in zip(self.timing_cap_list, self.timing_cap_type_list):
            timing_cap, time = timing_cap_tup
            self.timing_trigshow_list.append(z3.Bool('timingtrigshow_'+timing_cap))
            self.z3_var_dict['timingtrigshow_'+timing_cap] = self.timing_trigshow_list[-1]
            self.z3_var_default_val_dict['timingtrigshow_'+timing_cap] = False

            if timing_cap_type.startswith('bool'):
                self.timing_trigcomp_list.append(self.Comparator.eq)
                self.timing_trigval_list.append(z3.Bool('timingtrigval_'+timing_cap))
                self.z3_var_dict['timingtrigval_'+timing_cap] = self.timing_trigval_list[-1]
                self.z3_var_default_val_dict['timingtrigval_'+timing_cap] = False
            elif timing_cap_type.startswith('set'):
                self.timing_trigcomp_list.append(self.Comparator.eq)
                self.timing_trigval_list.append(z3.Const('timingtrigval_' + timing_cap,
                                                         self.set_z3_dict[timing_cap][0]))
                self.z3_var_dict['timingtrigval_' + timing_cap] = self.timing_trigval_list[-1]
                self.z3_var_default_val_dict['timingtrigval_' + timing_cap] = \
                    list(self.set_z3_dict[timing_cap][1].items())[0][1]
            else:
                self.timing_trigcomp_list.append(z3.Const('timingtrigcomp_' + timing_cap, self.ComparatorRange))
                self.timing_trigval_list.append(z3.Int('timingtrigval_' + timing_cap))
                self.z3_var_dict['timingtrigcomp_' + timing_cap] = self.timing_trigcomp_list[-1]
                self.z3_var_dict['timingtrigval_' + timing_cap] = self.timing_trigval_list[-1]
                self.z3_var_default_val_dict['timingtrigcomp_' + timing_cap] = self.ComparatorRange.eq
                self.z3_var_default_val_dict['timingtrigval_' + timing_cap] = 0

    def _applyActionConditional(self, action, condition):
        if '#' in action:
            time_span, raw_action = action.split('#')
            time_span = int(time_span)
        else:
            time_span = None
            raw_action = action

        cap_name = raw_action.split('=')[0]
        if cap_name not in self.cap_list:
            return
        action_cap, action_comp, action_val = self._convertFormulaToZ3(raw_action)

        # send back the triggered actions
        following_action_tup = list()

        if not time_span:  # not a timing event
            # which old rule is triggered?
            trigger_bit_existing_taps = [False] * len(self.tap_list)
            for tap, tap_index in zip(self.tap_list, range(len(self.tap_list))):
                if action == tap.trigger:
                    cond_sat_list = list()
                    for cond in tap.condition:
                        cond_cap, cond_comp, cond_val = self._convertFormulaToZ3(cond)
                        cond_sat = self._checkCondition(cond_cap, cond_comp, cond_val)
                        cond_sat_list.append(cond_sat)
                    trigger_bit = z3.And(cond_sat_list)
                else:
                    trigger_bit = False
                trigger_bit_existing_taps[tap_index] = trigger_bit

            # whether the new rule is triggered?
            trigger_bit_new_rule_list = list()
            for trigger_cap, trigger_show, trigger_comp, trigger_value in \
                    zip(self.trig_cap_list, self.trigshow_list, self.trigcomp_list, self.trigval_list):
                trigger_sat = self._checkIfActionIsTrigger(action_cap, action_val,
                                                           trigger_cap, trigger_comp, trigger_value)
                trigger_sat = z3.And(trigger_show, trigger_sat)
                cond_sat_list = [z3.Implies(cond_show, self._checkCondition(cond_cap, cond_comp, cond_val))
                                 for cond_show, cond_cap, cond_comp, cond_val in
                                 zip(self.apshow_list, self.cond_cap_list, self.apcomp_list, self.apval_list)]
                cond_sat = z3.And(cond_sat_list)
                trigger_bit_new_rule_list.append(z3.And(trigger_sat, cond_sat))
            trigger_bit_new_rule = z3.Or(trigger_bit_new_rule_list)

            # conditionally apply the action
            self.value_list[self.cap_list.index(action_cap)] = z3.If(condition,
                                                                     action_val,
                                                                     self.value_list[self.cap_list.index(action_cap)])

            for tap, trigger_bit in zip(self.tap_list, trigger_bit_existing_taps):
                following_action_tup.append((tap.action, z3.And(trigger_bit, condition)))
            following_action_tup.append((self.target_action, z3.And(trigger_bit_new_rule, condition)))

        else:  # a timing event
            # whether the new rule (timing related) is triggered
            trigger_bit_new_timing_rule_list = list()
            for timing_cap_time, timing_trigger_show, timing_trigger_comp, timing_trigger_val in \
                    zip(self.timing_cap_list, self.timing_trigshow_list,
                        self.timing_trigcomp_list, self.timing_trigval_list):
                timing_trigger_cap, timing_trigger_time = timing_cap_time
                trigger_sat = self._checkIfActionIsTrigger(action_cap, action_val,
                                                           timing_trigger_cap, timing_trigger_comp, timing_trigger_val)
                trigger_sat = z3.And(timing_trigger_show, trigger_sat)
                cond_sat_list = [z3.Implies(cond_show, self._checkCondition(cond_cap, cond_comp, cond_val))
                                 for cond_show, cond_cap, cond_comp, cond_val in
                                 zip(self.apshow_list, self.cond_cap_list, self.apcomp_list, self.apval_list)]
                cond_sat = z3.And(cond_sat_list)
                trigger_bit_new_timing_rule_list.append(z3.And(trigger_sat, cond_sat))
            trigger_bit_new_timing_rule = z3.Or(trigger_bit_new_timing_rule_list)
            # no need to apply action for timing events
            following_action_tup.append((self.target_action, z3.And(trigger_bit_new_timing_rule, condition)))

        return following_action_tup

    def applyAction(self, action):
        if '#' not in action:
            cap_name = action.split('=')[0]
        else:
            cap_name = action.split('#')[1].split('=')[0]
        if cap_name not in self.cap_list:
            return

        action_cache = list()
        action_cache.append((action, True, 1))

        while action_cache:
            current_action, condition, depth = action_cache.pop(0)
            if depth < 3:
                additional_actions = self._applyActionConditional(current_action, condition)
                for additional_act, additional_cond in additional_actions:
                    action_cache.append((additional_act, additional_cond, depth+1))

    def getTimingZ3Vars(self):
        return self.timing_trigshow_list, self.timing_trigcomp_list, self.timing_trigval_list

    def getRangeVars(self):
        range_var_list = [cap for cap, typ in zip(self.cap_list, self.cap_type_list) if typ.startswith('numeric')]
        trigval_list = ['trigval_'+cap for cap in self.trig_cap_list if cap in range_var_list]
        apval_list = ['apval_'+cap for cap in self.cond_cap_list if cap in range_var_list]
        time_trigval_list = ['timingtrigval_'+timing_cap
                             for timing_cap, time in self.timing_cap_list
                             if timing_cap in range_var_list]
        return trigval_list + apval_list + time_trigval_list

    def getSetVars(self):
        set_var_list = [cap for cap, typ in zip(self.cap_list, self.cap_type_list) if typ.startswith('set')]
        trigval_list = ['trigval_' + cap for cap in self.trig_cap_list if cap in set_var_list]
        apval_list = ['apval_' + cap for cap in self.cond_cap_list if cap in set_var_list]
        time_trigval_list = ['timingtrigval_' + timing_cap
                             for timing_cap, time in self.timing_cap_list
                             if timing_cap in set_var_list]
        return trigval_list + apval_list + time_trigval_list


class ModifyParSystem(SynthParSystem):
    def __init__(self, cap_list, target_action, tap_list=[], init_value_dict={}, template_dict=db_template_dict):
        super(ModifyParSystem, self).__init__(cap_list, target_action, tap_list, init_value_dict, template_dict)

        self.tapdel_list = list()
        for tap, index in zip(self.tap_list, range(len(self.tap_list))):
            self.tapdel_list.append(z3.Bool('tapdel_'+str(index)))
            self.z3_var_dict['tapdel_'+str(index)] = self.tapdel_list[-1]
            self.z3_var_default_val_dict['tapdel_'+str(index)] = False

    def _applyActionConditional(self, action, condition):
        cap_name = action.split('=')[0]
        if cap_name not in self.cap_list:
            return
        action_cap, action_comp, action_val = self._convertFormulaToZ3(action)

        # which old rule is triggered?
        trigger_bit_existing_taps = [False] * len(self.tap_list)
        for tap, tapdel, tap_index in zip(self.tap_list, self.tapdel_list, range(len(self.tap_list))):
            if action == tap.trigger:
                cond_sat_list = list()
                for cond in tap.condition:
                    cond_cap, cond_comp, cond_val = self._convertFormulaToZ3(cond)
                    cond_sat = self._checkCondition(cond_cap, cond_comp, cond_val)
                    cond_sat_list.append(cond_sat)
                trigger_bit = z3.And(cond_sat_list)
            else:
                trigger_bit = False
            trigger_bit_existing_taps[tap_index] = z3.And(z3.Not(tapdel), trigger_bit)

        # whether the new rule is triggered?
        trigger_bit_new_rule_list = list()
        for trigger_cap, trigger_show, trigger_comp, trigger_value in \
                zip(self.cap_list, self.trigshow_list, self.trigcomp_list, self.trigval_list):
            trigger_sat = self._checkIfActionIsTrigger(action_cap, action_val,
                                                       trigger_cap, trigger_comp, trigger_value)
            trigger_sat = z3.And(trigger_show, trigger_sat)
            cond_sat_list = [z3.Implies(cond_show, self._checkCondition(cond_cap, cond_comp, cond_val))
                             for cond_show, cond_cap, cond_comp, cond_val in
                             zip(self.apshow_list, self.cap_list, self.apcomp_list, self.apval_list)]
            cond_sat = z3.And(cond_sat_list)
            trigger_bit_new_rule_list.append(z3.And(trigger_sat, cond_sat))
        trigger_bit_new_rule = z3.Or(trigger_bit_new_rule_list)

        # conditionally apply the action
        self.value_list[self.cap_list.index(action_cap)] = z3.If(condition,
                                                                 action_val,
                                                                 self.value_list[self.cap_list.index(action_cap)])

        # send back the triggered actions
        following_action_tup = list()
        for tap, trigger_bit in zip(self.tap_list, trigger_bit_existing_taps):
            following_action_tup.append((tap.action, z3.And(trigger_bit, condition)))
        following_action_tup.append((self.target_action, z3.And(trigger_bit_new_rule, condition)))
        return following_action_tup


class PatchSystem(ParameterizedSystem):
    """
    Universal system, support adding one rule, modifying rule and deleting rule
    This class uses the new Rule system in autotapta.model.Rule
    """
    def __init__(self, cap_list: List[str], target_action: str, trig_cap_list: List[str],
                 trig_cap_time_list: List[Tuple[str, int]], cond_cap_list: List[str], tap_list=None,
                 init_value_dict=None, template_dict=db_template_dict):
        if tap_list is None:
            tap_list = []
        if init_value_dict is None:
            init_value_dict = {}
        self.template_dict = template_dict

        # construct z3 enum for set types
        self.set_z3_dict = dict()
        for dev in template_dict:
            for par in template_dict[dev]:
                cap = '%s.%s' % (dev, par)
                typ = template_dict[dev][par]
                if typ.startswith('set'):
                    opt_list = typ.split('[')[-1][:-1].split(', ')  # all possible actions of the set var
                    var_z3_type, opt_z3_tuple = z3.EnumSort(cap, tuple(opt_list))  # turn the set var into z3 enum
                    self.set_z3_dict[cap] = \
                        (var_z3_type, dict(zip(opt_list, opt_z3_tuple)))  # key: var name, value: (z3var, optdict)

        # construct all caps and their types
        cap_type_list = [template_dict[cap.split('.')[0]][cap.split('.')[1]] for cap in cap_list]
        self.cap_list = cap_list
        self.cap_type_list = [typ.split(',')[0] for typ in cap_type_list]

        # running value of the variables
        self.value_list = list()
        for cap, typ in zip(cap_list, cap_type_list):
            if cap in init_value_dict:
                if typ.startswith('bool'):
                    self.value_list.append(bool(init_value_dict[cap]))
                elif typ.startswith('set'):
                    self.value_list.append(self.set_z3_dict[cap][1][init_value_dict[cap]])
                else:
                    self.value_list.append(int(float(init_value_dict[cap])))
            else:
                if typ.startswith('bool'):
                    self.value_list.append(False)
                elif typ.startswith('set'):
                    self.value_list.append(list(self.set_z3_dict[cap][1].items())[0][1])
                else:
                    self.value_list.append(0)

        self.existing_rule_list = list()
        # initialize existing rules
        for tap in tap_list:
            tap_trigger = self._formulaToExpression(tap.trigger, 'trigger')
            tap_condition = [self._formulaToExpression(cond, 'condition') for cond in tap.condition]
            tap_action = self._formulaToExpression(tap.action, 'action')
            rule = RegRule(tap_trigger, tap_condition, tap_action)
            self.existing_rule_list.append(rule)

        # initialize new rule
        trig_caps = [(cap, 0) for cap in trig_cap_list] + trig_cap_time_list
        self.target_action = self._formulaToExpression(target_action, 'action')
        self.new_rule = SymbRule(trig_caps, cond_cap_list, self.target_action, self.template_dict, self.set_z3_dict)

    def resetInitState(self, init_value_dict=None):
        if init_value_dict is None:
            init_value_dict = dict()
        # running state value
        for cap, typ, index in zip(self.cap_list, self.cap_type_list, range(len(self.cap_list))):
            if cap in init_value_dict:
                if typ.startswith('bool'):
                    self.value_list[index] = bool(init_value_dict[cap])
                elif typ.startswith('set'):
                    self.value_list[index] = self.set_z3_dict[cap][1][init_value_dict[cap]]
                else:
                    self.value_list[index] = int(float(init_value_dict[cap]))
            else:
                if typ.startswith('bool'):
                    self.value_list[index] = False
                elif typ.startswith('set'):
                    self.value_list[index] = list(self.set_z3_dict[cap][1].items())[0][1]
                else:
                    self.value_list[index] = 0

    def _formulaToExpression(self, formula: str, typ: str):
        """
        translate autotap's formula "xxx.xxx=xxx" into the Expression objects above
        :param formula:
        :param typ: could be 'trigger', 'condition', 'action' or 'event'
        :return: an expression
        """
        if formula.startswith('tick['):
            formula = formula[5:-1]  # lagacy formula use tick[time*event]
        if typ in ('trigger', 'event'):
            hold_t = None
            delay = None
            if '#' in formula:
                t, simple_formula = formula.split('#')
                delay = int(t)
            elif '*' in formula:
                t, simple_formula = formula.split('*')
                hold_t = int(t)
            else:
                simple_formula = formula
            var, comp, val = self._parseSimpleFormula(simple_formula)
            return TriggerExpression(var, comp, val, hold_t, delay)
        elif typ == 'action':
            var, comp, val = self._parseSimpleFormula(formula)
            return ActionExpression(var, comp, val)
        else:  # condition:
            simple_formula = formula[1:] if formula.startswith('!') else formula
            neg = formula.startswith('!')
            var, comp, val = self._parseSimpleFormula(simple_formula)
            if neg:
                revert_map = {'=': '!=', '!=': '=', '<': '>=', '>': '<=', '<=': '>', '>=': '<'}
                comp = revert_map[comp]
            return ConditionExpression(var, comp, val)

    def _parseSimpleFormula(self, formula):
        if '<=' in formula:
            comp = '<='
            cap, val = formula.split('<=')
        elif '>=' in formula:
            comp = '>='
            cap, val = formula.split('>=')
        elif '<' in formula:
            comp = '<'
            cap, val = formula.split('<')
        elif '>' in formula:
            comp = '>'
            cap, val = formula.split('>')
        elif '!=' in formula:
            comp = '!='
            cap, val = formula.split('!=')
        else:
            comp = '='
            cap, val = formula.split('=')

        dev, var = cap.split('.')
        typ = self.template_dict[dev][var]
        if typ.startswith('bool'):
            val = val == 'true'
        elif typ.startswith('set'):
            val = self.set_z3_dict[cap][1][val]
        elif typ.startswith('numeric'):
            val = int(float(val))
        else:
            raise Exception('Unknown type %s' % typ)

        return cap, comp, val

    def parseSimpleFormula(self, formula):
        return self._parseSimpleFormula(formula)

    def applyAction(self, event_f):
        event = self._formulaToExpression(event_f, 'event')
        pre_cond_dict = dict(zip(self.cap_list, self.value_list))
        # apply the event
        if event.var in self.cap_list:
            event_index = self.cap_list.index(event.var)
            self.value_list[event_index] = event.val
        else:
            return
        # trigger all existing rules
        for rule in self.existing_rule_list:
            action, trig_cond = rule.trigger(event, pre_cond_dict)
            if action is not None and trig_cond is not None:
                action_index = self.cap_list.index(action.var)
                self.value_list[action_index] = z3.If(trig_cond, action.val, self.value_list[action_index])
        # trigger new rule
        action, trig_cond = self.new_rule.trigger(event, pre_cond_dict)
        if action is not None and trig_cond is not None:
            action_index = self.cap_list.index(action.var)
            self.value_list[action_index] = z3.If(trig_cond, action.val, self.value_list[action_index])

    def timePass(self, start_time: datetime.datetime, end_time: datetime.datetime):
        pre_cond_dict = dict(zip(self.cap_list, self.value_list))
        # trigger new rule
        action, trig_cond = self.new_rule.timePass(start_time, end_time, pre_cond_dict)
        if action is not None and trig_cond is not None:
            action_index = self.cap_list.index(action.var)
            self.value_list[action_index] = z3.If(trig_cond, action.val, self.value_list[action_index])

    def getStateValue(self, cap):
        cap_index = self.cap_list.index(cap)
        return self.value_list[cap_index]

    def getAllZ3Variables(self):
        """
        return all Z3 Variables
        should contain all the del symb of existing rules and all symbs in new rule
        :return:
        """
        z3_variable_dict = dict()
        z3_default_value_dict = dict()

        for rule in self.existing_rule_list:
            var_d, val_d = rule.getAllZ3Variables()
            z3_variable_dict = {**z3_variable_dict, **var_d}
            z3_default_value_dict = {**z3_default_value_dict, **val_d}

        var_d, val_d = self.new_rule.getAllZ3Variables()
        z3_variable_dict = {**z3_variable_dict, **var_d}
        z3_default_value_dict = {**z3_default_value_dict, **val_d}

        return z3_variable_dict, z3_default_value_dict

    def getRangeVars(self):
        return self.new_rule.getRangeVars()

    def getSetVars(self):
        return self.new_rule.getSetVars()

    def getSyntaxConstraints(self):
        """
        this one will get all syntax constraints within the system
        1) when clause doesn't show up, use default value
        2) for boolean ap, keep using '=false' instead of '!=true'
        3) cap in trigger should not show up in condition
        4) for range ap, shouldn't be using '=' or '!='
        :return:
        """
        return self.new_rule.getSyntaxConstraints()

    def getConstraintsForDeleting(self):
        """
        deleting one existing rule
        :return:
        """
        # constraints = self.getSyntaxConstraints()
        constraints = []
        constraints.append(z3.Not(self.new_rule.show_symb))
        constraints.append(sum([z3.If(rule.show_symb, 0, 1) for rule in self.existing_rule_list]) == 1)
        return constraints

    def getConstraintsForAdding(self):
        """
        adding one new rule
        :return:
        """
        # constraints = self.getSyntaxConstraints()
        constraints = []
        constraints.append(self.new_rule.show_symb)
        constraints = constraints + [rule.show_symb for rule in self.existing_rule_list]
        return constraints

    def _getTriggerConstraint(self, rule):
        """
            constraints we need to have if we are modifying a rule
        """
        constraints = []

        comparator_range_dict = {
            '=': ComparatorRange.eq,
            '!=': ComparatorRange.neq,
            '<': ComparatorRange.lt,
            '>': ComparatorRange.gt,
            '<=': ComparatorRange.leq,
            '>=': ComparatorRange.geq
        }
        comparator_dict = {
            '=': Comparator.eq,
            '!=': Comparator.neq
        }

        trigger_e = rule.trigger_e

        time_symb = None
        time = None
        if trigger_e.hold_t is not None:
            time_symb = '*'
            time = trigger_e.hold_t
        elif rule.trigger_e.delay is not None:
            # however, this cannot be handled. Consider this the same as *
            time_symb = '#'
            time = trigger_e.delay

        if time is not None:
            if (trigger_e.var, int(time)) in self.new_rule.timing_cap_list:
                trig_index = self.new_rule.timing_cap_list.index((trigger_e.var, int(time)))
                # must select the trigger if this rule is being modified
                constraints.append(z3.Implies(z3.Not(rule.show_symb), self.new_rule.timing_trig_show_list[trig_index]))
                # the trig val must be the same as this rule
                constraints.append(z3.Implies(z3.Not(rule.show_symb), self.new_rule.timing_trig_val_list[trig_index] == trigger_e.val))
                # the trig comp must be the same
                if self.new_rule.timing_cap_typ_list[trig_index] == 'numeric':
                    constraints.append(z3.Implies(z3.Not(rule.show_symb), 
                                                self.new_rule.timing_trig_comp_list[trig_index] == comparator_range_dict[trigger_e.comp]))
                else:
                    constraints.append(z3.Implies(z3.Not(rule.show_symb), 
                                                self.new_rule.timing_trig_comp_list[trig_index] == comparator_dict[trigger_e.comp]))
            else:
                constraints.append(rule.show_symb)
        else:
            if trigger_e.var in self.new_rule.trig_cap_list:
                # the rule's trigger is in the trigger list
                trig_index = self.new_rule.trig_cap_list.index(trigger_e.var)
                # must select the trigger if this rule is being modified
                constraints.append(z3.Implies(z3.Not(rule.show_symb), self.new_rule.trig_show_list[trig_index]))
                # the trig val must be the same as this rule
                constraints.append(z3.Implies(z3.Not(rule.show_symb), self.new_rule.trig_val_list[trig_index] == trigger_e.val))
                # the trig comp must be the same
                if self.new_rule.trig_cap_typ_list[trig_index] == 'numeric':
                    constraints.append(z3.Implies(z3.Not(rule.show_symb), 
                                                self.new_rule.trig_comp_list[trig_index] == comparator_range_dict[trigger_e.comp]))
                else:
                    constraints.append(z3.Implies(z3.Not(rule.show_symb), 
                                                self.new_rule.trig_comp_list[trig_index] == comparator_dict[trigger_e.comp]))
            else:
                constraints.append(rule.show_symb)
        return constraints

    def getConstraintsForModifying(self):
        """
        modifying one rule
        changing the condition of one rule
        :return:
        """
        # constraints = self.getSyntaxConstraints()
        constraints = []
        constraints.append(self.new_rule.show_symb)
        constraints.append(sum([z3.If(rule.show_symb, 0, 1) for rule in self.existing_rule_list]) == 1)
        for rule in self.existing_rule_list:
            if rule.action.var == self.target_action.var and rule.action.val == self.target_action.val:
                # The rule's action is our target action. We could modify this rule
                constraints += self._getTriggerConstraint(rule)
            else:
                # Otherwise we cannot modify the rule
                constraints.append(rule.show_symb)
        return constraints


class DebugSystem(ParameterizedSystem):
    """
    A system that tries to handle FPs by
    1) adding one condition to a rule
    2) deleting one rule
    """
    def __init__(self, cap_list: List[str], target_action: str, cond_cap_list: List[str], 
                 tap_list=None, init_value_dict=None, template_dict=db_template_dict):
        if tap_list is None:
            tap_list = []
        if init_value_dict is None:
            init_value_dict = {}
        self.template_dict = template_dict

        # construct z3 enum for set types
        self.set_z3_dict = dict()
        for dev in template_dict:
            for par in template_dict[dev]:
                cap = '%s.%s' % (dev, par)
                typ = template_dict[dev][par]
                if typ.startswith('set'):
                    opt_list = typ.split('[')[-1][:-1].split(', ')  # all possible actions of the set var
                    var_z3_type, opt_z3_tuple = z3.EnumSort(cap, tuple(opt_list))  # turn the set var into z3 enum
                    self.set_z3_dict[cap] = \
                        (var_z3_type, dict(zip(opt_list, opt_z3_tuple)))  # key: var name, value: (z3var, optdict)

        # construct all caps and their types
        cap_type_list = [template_dict[cap.split('.')[0]][cap.split('.')[1]] for cap in cap_list]
        self.cap_list = cap_list
        self.cap_type_list = [typ.split(',')[0] for typ in cap_type_list]

        # running value of the variables
        self.value_list = [None] * len(cap_list)
        self.resetInitState(init_value_dict)

        self.existing_rule_list = list()
        # initialize existing rules
        for tap in tap_list:
            tap_trigger = self._formulaToExpression(tap.trigger, 'trigger')
            tap_condition = [self._formulaToExpression(cond, 'condition') for cond in tap.condition]
            tap_action = self._formulaToExpression(tap.action, 'action')
            rule = RegRule(tap_trigger, tap_condition, tap_action, plain=True)
            self.existing_rule_list.append(rule)
        
        # z3 dict for variables and default values
        self.z3_var_dict = dict()
        self.z3_var_default_val_dict = dict()

        # initialize mode bits
        self.mode_symb = z3.Bool('mode_symb_%s' % str(id(self)))  # 0 is modify, 1 is delete
        self.z3_var_dict.update({str(self.mode_symb): self.mode_symb})
        self.z3_var_default_val_dict.update({str(self.mode_symb): False})

        # initialize rule selection bits
        self.tap_sel_list = [z3.Bool('tap_sel_%s_%s' % (str(id(rule)), str(id(self)))) for rule in self.existing_rule_list]
        self.z3_var_dict.update({str(tap_sel): tap_sel for tap_sel in self.tap_sel_list})
        self.z3_var_default_val_dict.update({str(tap_sel): False for tap_sel in self.tap_sel_list})

        # initialize condition selection bits
        self.cond_cap_list = cond_cap_list
        cond_cap_type_list = [template_dict[cap.split('.')[0]][cap.split('.')[1]] for cap in self.cond_cap_list]
        self.cond_cap_type_list = [typ.split(',')[0] for typ in cond_cap_type_list]
        self.cond_show_list = [z3.Bool('cond_show_%s_%s' % (cap, str(id(self)))) for cap in self.cond_cap_list]
        self.z3_var_dict.update({str(v): v for v in self.cond_show_list})
        self.z3_var_default_val_dict.update({str(v): False for v in self.cond_show_list})

        # initialize condition comp bits
        self.cond_comp_list = []
        for cap, typ in zip(self.cond_cap_list, self.cond_cap_type_list):
            if typ == 'numeric':
                self.cond_comp_list.append(z3.Const('cond_comp_%s_%s' % (cap, str(id(self))), ComparatorRange))
            else:
                self.cond_comp_list.append(z3.Const('cond_comp_%s_%s' % (cap, str(id(self))), Comparator))
        self.z3_var_dict.update({str(v): v for v in self.cond_comp_list})
        findDefaultComp = lambda typ: ComparatorRange.eq if typ == 'numeric' else Comparator.eq
        self.z3_var_default_val_dict.update({str(v): findDefaultComp(typ) 
                                             for v, typ in zip(self.cond_comp_list, self.cond_cap_type_list)})

        # initialize condition val bits
        self.cond_val_list = []
        for cap, typ in zip(self.cond_cap_list, self.cond_cap_type_list):
            if typ == 'set':
                SetType = self.set_z3_dict[cap][0]
                self.cond_val_list.append(z3.Const('cond_val_%s_%s' % (cap, str(id(cap))), SetType))
            elif typ == 'numeric':
                self.cond_val_list.append(z3.Int('cond_val_%s_%s' % (cap, str(id(cap)))))
            else:
                self.cond_val_list.append(z3.Bool('cond_val_%s_%s' % (cap, str(id(cap)))))
        self.z3_var_dict.update({str(v): v for v in self.cond_val_list})
        for cap, typ, val_symb in zip(self.cond_cap_list, self.cond_cap_type_list, self.cond_val_list):
            if typ == 'set':
                default_val = list(self.set_z3_dict[cap][1].items())[0][1]
                self.z3_var_default_val_dict[str(val_symb)] = default_val
            elif typ == 'numeric':
                self.z3_var_default_val_dict[str(val_symb)] = 0
            else:
                self.z3_var_default_val_dict[str(val_symb)] = False

    def resetInitState(self, init_value_dict=None):
        if init_value_dict is None:
            init_value_dict = dict()
        # running state value
        for cap, typ, index in zip(self.cap_list, self.cap_type_list, range(len(self.cap_list))):
            if cap in init_value_dict:
                if typ.startswith('bool'):
                    self.value_list[index] = bool(init_value_dict[cap])
                elif typ.startswith('set'):
                    self.value_list[index] = self.set_z3_dict[cap][1][init_value_dict[cap]]
                else:
                    self.value_list[index] = int(float(init_value_dict[cap]))
            else:
                if typ.startswith('bool'):
                    self.value_list[index] = False
                elif typ.startswith('set'):
                    self.value_list[index] = list(self.set_z3_dict[cap][1].items())[0][1]
                else:
                    self.value_list[index] = 0

    def _formulaToExpression(self, formula: str, typ: str):
        """
        translate autotap's formula "xxx.xxx=xxx" into the Expression objects above
        :param formula:
        :param typ: could be 'trigger', 'condition', 'action' or 'event'
        :return: an expression
        """
        if formula.startswith('tick['):
            formula = formula[5:-1]  # lagacy formula use tick[time*event]
        if typ in ('trigger', 'event'):
            hold_t = None
            delay = None
            if '#' in formula:
                t, simple_formula = formula.split('#')
                delay = int(t)
            elif '*' in formula:
                t, simple_formula = formula.split('*')
                hold_t = int(t)
            else:
                simple_formula = formula
            var, comp, val = self._parseSimpleFormula(simple_formula)
            return TriggerExpression(var, comp, val, hold_t, delay)
        elif typ == 'action':
            var, comp, val = self._parseSimpleFormula(formula)
            return ActionExpression(var, comp, val)
        else:  # condition:
            simple_formula = formula[1:] if formula.startswith('!') else formula
            neg = formula.startswith('!')
            var, comp, val = self._parseSimpleFormula(simple_formula)
            if neg:
                revert_map = {'=': '!=', '!=': '=', '<': '>=', '>': '<=', '<=': '>', '>=': '<'}
                comp = revert_map[comp]
            return ConditionExpression(var, comp, val)

    def _parseSimpleFormula(self, formula):
        if '<=' in formula:
            comp = '<='
            cap, val = formula.split('<=')
        elif '>=' in formula:
            comp = '>='
            cap, val = formula.split('>=')
        elif '<' in formula:
            comp = '<'
            cap, val = formula.split('<')
        elif '>' in formula:
            comp = '>'
            cap, val = formula.split('>')
        elif '!=' in formula:
            comp = '!='
            cap, val = formula.split('!=')
        else:
            comp = '='
            cap, val = formula.split('=')

        dev, var = cap.split('.')
        typ = self.template_dict[dev][var]
        if typ.startswith('bool'):
            val = val == 'true'
        elif typ.startswith('set'):
            val = self.set_z3_dict[cap][1][val]
        elif typ.startswith('numeric'):
            val = int(float(val))
        else:
            raise Exception('Unknown type %s' % typ)

        return cap, comp, val

    def parseSimpleFormula(self, formula):
        return self._parseSimpleFormula(formula)

    def applyAction(self, event_f):
        """this is not used in DebugSystem"""
        # event = self._formulaToExpression(event_f, 'event')
        # pre_cond_dict = dict(zip(self.cap_list, self.value_list))
        # additional_cond = None  # TODO: calculate additional cond
        # # trigger all existing rules
        # trigger_bits = []
        # for rule, rule_sel in zip(self.existing_rule_list, self.tap_sel_list):
        #     action, trig_cond = rule.trigger(event, pre_cond_dict)
        #     modify_cond = z3.And(trig_cond, z3.Implies(rule_sel, additional_cond))
        #     delete_cond = z3.And(z3.Not(rule_sel), trig_cond)
        #     trigger_bits.append(z3.If(self.mode_symb, modify_cond, delete_cond))
        #     if action is not None and trig_cond is not None:
        #         action_index = self.cap_list.index(action.var)
        #         self.value_list[action_index] = z3.If(trig_cond, action.val, self.value_list[action_index])
        pass
    
    def testIfRuleTriggered(self, event_f):
        event = self._formulaToExpression(event_f, 'event')
        pre_cond_dict = dict(zip(self.cap_list, self.value_list))
        cond_sat_list = []
        for cond, cond_show, cond_type, cond_comp, cond_val in zip(self.cond_cap_list, self.cond_show_list, 
                                                                   self.cond_cap_type_list, self.cond_comp_list, 
                                                                   self.cond_val_list):
            cond_sat = checkExpression(pre_cond_dict[cond], cond_val, cond_comp, cond_type)
            cond_sat = z3.Implies(cond_show, cond_sat)
            cond_sat_list.append(cond_sat)
        additional_cond = z3.And(cond_sat_list)  # calculate additional cond
        # trigger all existing rules
        trigger_bits = []
        for rule, rule_sel in zip(self.existing_rule_list, self.tap_sel_list):
            _, trig_cond = rule.trigger(event, pre_cond_dict)
            modify_cond = z3.And(trig_cond, z3.Implies(rule_sel, additional_cond))
            delete_cond = z3.And(z3.Not(rule_sel), trig_cond)
            trigger_bits.append(z3.If(self.mode_symb, delete_cond, modify_cond))
        return z3.Or(trigger_bits)

    def timePass(self, start_time: datetime.datetime, end_time: datetime.datetime):
        pass

    def getStateValue(self, cap):
        cap_index = self.cap_list.index(cap)
        return self.value_list[cap_index]

    def getAllZ3Variables(self):
        """
        return all Z3 Variables
        should contain all the del symb of existing rules and all symbs in new rule
        :return:
        """
        return self.z3_var_dict, self.z3_var_default_val_dict

    def getRangeVars(self):
        return [str(val) for val, typ in zip(self.cond_val_list, self.cond_cap_type_list) if typ == 'numeric']

    def getSetVars(self):
        return [str(val) for val, typ in zip(self.cond_val_list, self.cond_cap_type_list) if typ == 'set']

    def getSyntaxConstraints(self):
        """
        this one will get all syntax constraints within the system
        1) when clause doesn't show up, use default value
        2) for boolean ap, keep using '=false' instead of '!=true'
        3) for range ap, shouldn't be using '=' or '!='
        4) there should only be one rule being changed
        :return:
        """
        constraints = []
        # 1) when clause doesn't show up, use default value
        for cond_show, cond_comp, cond_val in zip(self.cond_show_list, self.cond_comp_list, self.cond_val_list):
            constraints.append(z3.Implies(z3.Not(cond_show), cond_comp == self.z3_var_default_val_dict[str(cond_comp)]))
            constraints.append(z3.Implies(z3.Not(cond_show), cond_val == self.z3_var_default_val_dict[str(cond_val)]))
        # 2) for boolean ap, keep using '=false' instead of '!=true'
        for cond_show, cond_typ, cond_comp in zip(self.cond_show_list, self.cond_cap_type_list, self.cond_comp_list):
            if cond_typ == 'bool':
                constraints.append(z3.Implies(cond_show, cond_comp == Comparator.eq))
        # 3) for range ap, shouldn't be using '=', '!=', '<=' or '>='
        for cond_show, cond_typ, cond_comp in zip(self.cond_show_list, self.cond_cap_type_list, self.cond_comp_list):
            if cond_typ == 'numeric':
                constraints.append(z3.Implies(cond_show, 
                                              z3.And(cond_comp != ComparatorRange.eq, 
                                                     cond_comp != ComparatorRange.neq,
                                                     cond_comp != ComparatorRange.geq,
                                                     cond_comp != ComparatorRange.leq)))
        # 4) there should only be one rule being changed
        tap_sel_list_n = [z3.If(tap_sel, 1, 0) for tap_sel in self.tap_sel_list]
        constraints.append(sum(tap_sel_list_n) == 1)
        return constraints

    def getConstraintsForDeleting(self):
        """
        deleting one existing rule
        :return:
        1) mode is 1
        2) all aps not showing up
        """
        # constraints = self.getSyntaxConstraints()
        constraints = []
        constraints.append(self.mode_symb)
        constraints += [z3.Not(cond_show) for cond_show in self.cond_show_list]
        return constraints

    def getConstraintsForModifying(self):
        """
        modifying one rule
        changing the condition of one rule
        :return:
        1) mode is 0
        2) there should only be one ap being selected (TBD)
        """
        # constraints = self.getSyntaxConstraints()
        constraints = []
        constraints.append(z3.Not(self.mode_symb))
        constraints.append(sum([z3.If(rule.show_symb, 0, 1) for rule in self.existing_rule_list]) == 1)
        constraints.append(sum([z3.If(cond_show, 1, 0) for cond_show in self.cond_show_list]) == 1)
        return constraints

    def getNewConditionInFormula(self, z3_eval_dict):
        comp_dict = {'eq': '=', 'neq': '!=', 'gt': '>', 'lt': '<', 'geq': '>=', 'leq': '<='}
        for cond, cond_typ, cond_show, cond_comp, cond_val in zip(self.cond_cap_list, self.cond_cap_type_list, 
                                                                  self.cond_show_list, self.cond_comp_list, 
                                                                  self.cond_val_list):
            if z3_eval_dict[str(cond_show)]:
                val = str(z3_eval_dict[str(cond_val)]) if cond_typ != 'bool' else str(z3_eval_dict[str(cond_val)]).lower()
                comp = comp_dict[str(z3_eval_dict[str(cond_comp)])]
                return '%s%s%s' % (cond, comp, val)

    def getSelectedRuleIndex(self, z3_eval_dict):
        for rule_sel, index in zip(self.tap_sel_list, range(len(self.tap_sel_list))):
            if z3_eval_dict[str(rule_sel)]:
                return index