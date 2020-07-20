import numpy
import abc
import math
import random
import autotapmc.channels.template.Evaluation as DeviceList
from autotapmc.channels.template.DbTemplate import template_dict as db_template_dict
from autotapmc.model.IoTSystem import generateIoTSystem
from autotapta.model.InformalSystem import InformalSystem
from autotapmc.analyze.Build import generateTimeExp, getChannelList, \
    generateCriticalValue, generateChannelDict, namedTapFormat, textToformula
from autotapta.model.Trace import Trace


class Generator(object):
    @abc.abstractmethod
    def next(self, current_time):
        """

        :param current_time: current time (integer)
        :return: time when next event happen
        """
        pass


class ValueGenerator(object):
    @abc.abstractmethod
    def next(self, current_value):
        pass

    @abc.abstractmethod
    def generateAction(self, var, value):
        pass


class PoiisonGenerator(Generator):
    def __init__(self, lambd):
        self.lambd = lambd

    def next(self, current_time):
        inteval = math.ceil(numpy.random.exponential(self.lambd, size=1))
        return current_time + inteval


class RandomWalkValueGenerator(ValueGenerator):
    def __init__(self, step, target: int):
        self.step = step
        self.target = target

    def next(self, current_value: int):
        if current_value > self.target:
            toss = random.random() > 0.8
            return current_value + self.step if toss else current_value - self.step
        elif current_value < self.target:
            toss = random.random() > 0.8
            return current_value - self.step if toss else current_value + self.step
        else:
            toss = random.random() > 0.5
            return current_value - self.step if toss else current_value + self.step

    def generateAction(self, var, value):
        return str(var) + '=' + str(int(value))

class BooleanGenerator(ValueGenerator):
    def __init__(self):
        pass

    def next(self, current_value: bool):
        return not current_value

    def generateAction(self, var, value):
        return str(var) + '=' + ('true' if value else 'false')


class SetGenerator(ValueGenerator):
    def __init__(self, opt_list: list):
        self.opt_list = opt_list

    def next(self, current_value: str):
        if current_value not in self.opt_list:
            raise Exception("%s is not a valid value" % current_value)

        other_opt = [opt for opt in self.opt_list if opt != current_value]
        return random.choice(other_opt)

    def generateAction(self, var, value):
        return str(var) + '=' + str(value)


def generateTrace(cap_dict, tap_dict, length=100000, template_dict=vars(DeviceList)):
    """

    :param cap_dict: key: capability name, value: event generator (Generator)
    :param tap_dict:  key: name of the rule, value: TAP class
    :param length: maximum time
    :param template_dict: dict of template
    :return: a trace object (or list of events?)
    """
    tap_list = [val for key, val in tap_dict.items()]
    exp_t_list, record_exp_list = generateTimeExp('0', tap_list)
    crit_value_dict = generateCriticalValue('0', tap_list)
    cap_name_list = list(set([cap_name for cap_name, gen in cap_dict.items()]))
    channel_name_list = list(set([cap_name.split('.')[0] for cap_name, gen in cap_dict.items()]))
    tap_dict = namedTapFormat(tap_dict, crit_value_dict)

    channel_dict = generateChannelDict(channel_name_list, crit_value_dict,
                                       {}, cap_name_list, template_dict)
    system = generateIoTSystem('temp', channel_dict, tap_dict, exp_t_list, build_ts=False)
    init_field = system.saveToStateVector()

    current_time = 0
    event_time_list = list()
    while current_time < length:
        time_dict = {cap_name: gen.next(current_time) for cap_name, gen in cap_dict.items()}
        nearest_event_time = min([time for cap_name, time in time_dict.items()])
        smallest_timer = system.getSmallestTimerValue()
        if smallest_timer + current_time <= nearest_event_time:
            # should apply tick
            current_time = current_time + smallest_timer
            system.applyTick()
            event_list = system.resolveTriggeredRules()
            event_time_list = event_time_list + [(current_time, textToformula(event), True) for event in event_list]
        else:
            # should apply the nearest event
            selected_cap_list = [cap_name for cap_name, time in time_dict.items() if time == nearest_event_time]
            selected_cap = random.choice(selected_cap_list)
            event_list = system.getPossibleEvents(selected_cap)
            selected_event = random.choice(event_list)
            interval = time_dict[selected_cap] - current_time
            current_time = time_dict[selected_cap]
            system.applyTick(time=interval)
            system.applyAction(selected_event)
            following_event_list = system.resolveTriggeredRules()
            event_time_list.append((current_time, textToformula(selected_event), True))
            event_time_list = event_time_list + \
                              [(current_time, textToformula(event), True) for event in following_event_list]

    system.restoreFromStateVector(init_field)

    system_no_tap = generateIoTSystem('temp', channel_dict, {}, exp_t_list, build_ts=False)
    init_field_no_tap = system_no_tap.saveToStateVector()

    return Trace(init_field_no_tap, system_no_tap, event_time_list)
    # return event_time_list, init_field, system


def generateTraceEnhanced(cap_dict, tap_dict, length=10000, template_dict=db_template_dict):
    """

    :param cap_dict: key: capability name, value: (event generator: Generator, value generator: ValueGenerator)
    :param tap_dict:  key: name of the rule, value: TAP class
    :param length: maximum time
    :param template_dict: dict of template
    :return: a trace object (or list of events?)
    """
    tap_list = [val for key, val in tap_dict.items()]
    cap_name_list = list(set([cap_name for cap_name, gen in cap_dict.items()]))

    system = InformalSystem(cap_name_list, tap_list, db_template_dict)
    init_field = system.saveToStateVector()

    cap_list = list(cap_dict.keys())
    generator_list = [cap_dict[key][0] for key in cap_list]
    value_generator_list = [cap_dict[key][1] for key in cap_list]

    current_time = 0
    event_time_list = list()
    while current_time < length:
        time_list = [gen.next(current_time) for gen in generator_list]
        nearest_event_time = min(time_list)

        # should apply the nearest event
        selected_cap_list = [cap_name for cap_name, time in zip(cap_list, time_list) if time == nearest_event_time]
        selected_cap = random.choice(selected_cap_list)
        selected_cap_index = cap_list.index(selected_cap)
        next_value = value_generator_list[selected_cap_index].next(system.state_dict[selected_cap])
        selected_event = value_generator_list[selected_cap_index].generateAction(selected_cap, next_value)
        system.applyAction(selected_event)

        following_event_list = system.resolveTriggerBit()
        event_time_list.append((current_time, selected_event, True))
        event_time_list = event_time_list + [(current_time, event, False) for event in following_event_list]

        current_time = nearest_event_time

    system.restoreFromStateVector(init_field)

    system_no_tap = InformalSystem(cap_dict.keys(), [], template_dict)
    init_field_no_tap = system_no_tap.saveToStateVector()

    return Trace(init_field_no_tap, system_no_tap, event_time_list)
