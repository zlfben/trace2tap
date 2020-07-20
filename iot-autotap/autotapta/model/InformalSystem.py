from autotapmc.channels.template.DbTemplate import template_dict as db_template_dict
from autotapmc.model.Tap import Tap

class InformalSystem(object):
    def __init__(self, cap_list, tap_list=[], init_value_dict={}, template_dict=db_template_dict):
        # set up initial value
        self.state_dict = dict()
        for cap in cap_list:
            channel_name = cap.split('.')[0]
            var_name = cap.split('.')[1]
            typ = template_dict[channel_name][var_name]
            if cap in init_value_dict:
                value = init_value_dict[cap]
            else:
                if typ.startswith('bool'):
                    value = False
                elif typ.startswith('numeric'):
                    value = 0
                elif typ.startswith('set'):
                    opt_list = typ.split('[')[-1][:-1].split(', ')
                    value = opt_list[0]
                else:
                    raise Exception('Unknown type %s' % typ)
            self.state_dict[cap] = value

        # set up trigger bits
        self.tap_list = tap_list
        self.trigger_bit = [False] * len(tap_list)

    def _resolveValue(self, value):
        if value == 'true':
            value = True
        elif value == 'false':
            value = False
        elif value.replace('.', '').replace('-', '').isnumeric():
            value = int(float(value))
        return value

    def _checkCondition(self, cond: str, curr_value):
        neg = False
        if cond.startswith('!'):
            neg = True
            cond = cond[1:]
        if '<=' in cond:
            cap = cond.split('<=')[0]
            value = cond.split('<=')[1]
            cmp = '<='
        elif '>=' in cond:
            cap = cond.split('>=')[0]
            value = cond.split('>=')[1]
            cmp = '>='
        elif '<' in cond:
            cap = cond.split('<')[0]
            value = cond.split('<')[1]
            cmp = '<'
        elif '>' in cond:
            cap = cond.split('>')[0]
            value = cond.split('>')[1]
            cmp = '>'
        elif '!=' in cond:
            cap = cond.split('!=')[0]
            value = cond.split('!=')[1]
            cmp = '!='
        else:
            cap = cond.split('=')[0]
            value = cond.split('=')[1]
            cmp = '='

        value = self._resolveValue(value)

        if cmp == '=':
            return (value == curr_value) != neg
        elif cmp == '<':
            return (curr_value < value) != neg
        elif cmp == '>':
            return (curr_value > value) != neg
        elif cmp == '<=':
            return (curr_value <= value) != neg
        elif cmp == '!=':
            return (value != curr_value) != neg
        else:
            return (curr_value >= value) != neg

    def _checkCurrentCondition(self, cond: str):
        if cond.startswith('!'):
            cond = cond[1:]
        if '<=' in cond:
            cap = cond.split('<=')[0]
        elif '>=' in cond:
            cap = cond.split('>=')[0]
        elif '<' in cond:
            cap = cond.split('<')[0]
        elif '>' in cond:
            cap = cond.split('>')[0]
        elif '!=' in cond:
            cap = cond.split('!=')[0]
        else:
            cap = cond.split('=')[0]
        curr_value = self.state_dict[cap]
        return self._checkCondition(cond, curr_value)

    def _checkActionCondition(self, action: str, cond: str):
        action_var = action.split('=')[0]
        if not cond.startswith(action_var):
            return False
        action_value = action.split('=')[1]
        action_value = self._resolveValue(action_value)
        return self._checkCondition(cond, action_value)

    def _setTriggerBits(self, action):
        for index, tap in zip(range(len(self.tap_list)), self.tap_list):
            trigger = tap.trigger
            cond_list = tap.condition
            act = tap.action

            action_sat = self._checkActionCondition(action, trigger)
            cond_sat = all([self._checkCurrentCondition(cond) for cond in cond_list])
            if action_sat and cond_sat:
                self.trigger_bit[index] = True

    def tapConditionSatisfied(self, tap: Tap, field=None):
        if field is not None:
            self.restoreFromStateVector(field)
        return all([self._checkCurrentCondition(cond) for cond in tap.condition])

    def conditionSatisfied(self, cond: str, field=None):
        if field:
            self.restoreFromStateVector(field)
        return self._checkCurrentCondition(cond)

    def applyAction(self, action):
        cap = action.split('=')[0]
        value = action.split('=')[1]
        # set trigger bits
        self._setTriggerBits(action)
        value = self._resolveValue(value)
        # apply action
        self.state_dict[cap] = value

    def applyActionBypassChannelModel(self, action):
        self.applyAction(action)

    def resolveTriggerBit(self):
        action_list = list()
        while any(self.trigger_bit):
            tap_index = self.trigger_bit.index(True)
            self.trigger_bit[tap_index] = False
            action = self.tap_list[tap_index].action
            action_list.append(action)
            self.applyAction(action)
        return action_list

    def restoreFromStateVector(self, field):
        if len(field) != len(self.state_dict.keys()):
            raise Exception('Length of state vector is wrong')

        for v, k in zip(field, sorted(self.state_dict.keys())):
            self.state_dict[k] = v

    def saveToStateVector(self):
        return [v for k, v in sorted(self.state_dict.items())]

    def getFieldNameList(self):
        return sorted(list(self.state_dict.keys()))
