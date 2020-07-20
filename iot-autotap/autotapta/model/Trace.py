import datetime
from autotapta.model.InformalSystem import InformalSystem
import random


class Trace(object):
    def __init__(self, initial_state, system, initial_actions=list(), start_time=None, end_time=None):
        if initial_actions:
            if start_time is None:
                start_time = initial_actions[0][0]
            if end_time is None:
                end_time = initial_actions[-1][0]
        self.start_time = start_time
        self.end_time = end_time
        self.initial_state = initial_state
        self.actions = list()
        self.system = system
        initial_actions = sorted(initial_actions, key=lambda x: x[0])
        self.pre_condition = list()
        self.is_ext_list = list()
        for time, action, is_ext in initial_actions:
            self.addAction(time, action, is_ext)

    def addAction(self, time, action, is_ext=True):
        if not self.actions or time >= self.actions[-1][0]:
            if not self.actions:
                self.system.restoreFromStateVector(self.initial_state)
            else:
                self.system.restoreFromStateVector(self.pre_condition[-1])
                if '#' not in self.actions[-1][1] and '*' not in self.actions[-1][1]:
                    self.system.applyActionBypassChannelModel(self.actions[-1][1])
            if '#' in action or '*' in action or not self.pre_condition or not self.system.conditionSatisfied(action):
                self.pre_condition.append(self.system.saveToStateVector())
                self.actions.append((time, action))
                self.is_ext_list.append(is_ext)
        else:
            raise Exception('too late')

    def print(self):
        result = '=== initial state ===\n'
        result = result + str(self.initial_state) + '\n'
        result = result + '===    events     ===\n'
        result = result + '\n'.join([str(t) for t in self.actions]) + '\n'
        result = result + '=====================\n'
        return result

    def getPostCondition(self):
        self.system.restoreFromStateVector(self.pre_condition[-1])
        if '#' not in self.actions[-1][1] and '*' not in self.actions[-1][1]:
            self.system.applyActionBypassChannelModel(self.actions[-1][1])
        return self.system.saveToStateVector()


def enhanceTraceWithTiming(trace: Trace, timing_tup: list, symbol='#'):
    new_time_actions = list()

    for cap, time_span in timing_tup:
        action_time_event_list = list()

        for time_action, pre_condition, is_ext in zip(trace.actions, trace.pre_condition, trace.is_ext_list):
            time, action = time_action
            while action_time_event_list and time >= action_time_event_list[0][0]:
                t, e = action_time_event_list.pop(0)
                new_time_actions.append((t, e))

            if action.startswith(cap):
                action_list = [a for _, a in action_time_event_list]
                # if '%d#%s' % (time_span, action) not in action_list:
                action_time_event_list = [(time, action)
                                          for time, action in action_time_event_list
                                          if cap not in action]
                action_time_event_list.append((time+datetime.timedelta(seconds=time_span),
                                               '%d%s%s' % (time_span, symbol, action)))
                action_time_event_list = sorted(action_time_event_list, key=lambda x: x[0])
                # else:
                #     index = action_list.index('%d#%s' % (time_span, action))
                #     action_time_event_list[index] = (time+datetime.timedelta(seconds=time_span),
                #                                      '%d#%s' % (time_span, action))

    new_time_actions = sorted(new_time_actions, key=lambda x: x[0])

    new_actions = list()
    new_pre_condition = list()
    new_is_ext = list()
    for time_action, pre_condition, is_ext in zip(trace.actions, trace.pre_condition, trace.is_ext_list):
        time, action = time_action
        while new_time_actions and time >= new_time_actions[0][0]:
            t, a = new_time_actions.pop(0)
            new_actions.append((t, a))
            new_pre_condition.append(pre_condition)
            new_is_ext.append(is_ext)

        new_actions.append(time_action)
        new_pre_condition.append(pre_condition)
        new_is_ext.append(is_ext)

    new_trace = Trace(trace.initial_state, trace.system, [], trace.start_time, trace.end_time)
    new_trace.actions = new_actions
    new_trace.pre_condition = new_pre_condition
    new_trace.is_ext_list = new_is_ext

    return new_trace


def introduceTapToTrace(trace, tap_list, template_dict):
    orig_system = trace.system
    cap_list = orig_system.getFieldNameList()
    init_value_dict = dict(zip(cap_list, trace.initial_state))
    new_system = InformalSystem(cap_list, tap_list, init_value_dict, template_dict)

    new_action_list = list()
    for time_action, is_ext in zip(trace.actions, trace.is_ext_list):
        time, action = time_action
        # append original event
        new_action_list.append((time, action, is_ext))
        # append triggered event
        new_system.applyAction(action)
        triggered_event_list = new_system.resolveTriggerBit()
        new_action_list = new_action_list + [(time, event, False) for event in triggered_event_list]

    new_system_no_tap = InformalSystem(cap_list, [], init_value_dict, template_dict)
    init_field_no_tap = new_system_no_tap.saveToStateVector()

    new_trace = Trace(init_field_no_tap, new_system_no_tap, new_action_list)
    return new_trace


def introduceHumanBehaviorToTrace(trace, tap, template_dict, probability=1.0):
    """

    :param trace:
    :param tap: the "TAP" program in human's head
    :param template_dict:
    :return:
    """
    new_action_list = list()
    system = trace.system
    system.restoreFromStateVector(trace.initial_state)

    for time_action, is_ext in zip(trace.actions, trace.is_ext_list):
        time, action = time_action
        # append original event
        new_action_list.append((time, action, is_ext))
        # apply action
        system.applyAction(action)
        # append triggered event
        if action == tap.trigger and all([system.conditionSatisfied(cond) for cond in tap.condition]):
            if random.random() < probability:
                new_action_list.append((time, tap.action, True))

    new_trace = Trace(trace.initial_state, system, new_action_list)
    return new_trace


def getSubTraceBasedOnCaps(trace: Trace, target_cap_list):
    # Find indexs for remaining caps
    orig_cap_list = trace.system.getFieldNameList()
    cap_mask = [cap in target_cap_list for cap in orig_cap_list]

    # Delete unused caps in init_state
    trace.initial_state = [val for val, m in zip(trace.initial_state, cap_mask) if m]

    # Delete actions with unused caps
    # For the remaining ones, delete unused caps in pre_cond
    new_time_actions = []
    new_pre_conditions = []
    new_is_exts = []
    for ta, is_ext, pre_c in zip(trace.actions, trace.is_ext_list, trace.pre_condition):
        _time, action = ta
        cap, val = action.split('=')  # We assume there's not enhanced timing actions
        if cap in target_cap_list:
            new_time_actions.append((_time, action))
            new_pre_c = [val for val, m in zip(pre_c, cap_mask) if m]
            new_pre_conditions.append(new_pre_c)
            new_is_exts.append(is_ext)
    
    trace.actions = new_time_actions
    trace.pre_condition = new_pre_conditions
    trace.is_ext_list = new_is_exts
    
    # Delete the unused caps in system
    for cap in orig_cap_list:
        if cap not in target_cap_list:
            del trace.system.state_dict[cap]
    
    # We assume there's no rules in the system
    return trace
