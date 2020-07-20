import json
import datetime
from autotapta.input.Template import translateCapability, template_dict, isInTemplate, boolean_map
from autotapta.model.InformalSystem import InformalSystem
from autotapta.model.Trace import Trace
from autotapta.log.LogSystem import LogSystem, Event


def inputTrace(filename: str, target_cap_list=None, trunc_none=False,
               template_dict=template_dict, boolean_map=boolean_map):
    with open(filename, 'r') as fp:
        data = json.load(fp)

    return inputTraceFromList(data, target_cap_list, trunc_none, template_dict, boolean_map)


def inputTraceFromList(data, target_cap_list=None, trunc_none=False,
                       template_dict=template_dict, boolean_map=boolean_map, only_sensor=False,
                       if_disting_ext=False):
    if not target_cap_list:
        cap_list = list()
        for entry in data:
            dev_name, cap_name, value = translateCapability(entry, template_dict=template_dict, boolean_map=boolean_map)
            if dev_name in template_dict and cap_name in template_dict[dev_name]:
                if dev_name + '.' + cap_name not in cap_list:
                    cap_list.append(dev_name + '.' + cap_name)
    else:
        cap_list = [cap for cap in target_cap_list if isInTemplate(cap, template_dict)]

    value_list = [None] * len(cap_list)
    init_value_dict = {cap: None for cap in cap_list}

    system = InformalSystem(cap_list, [], init_value_dict, template_dict)
    action_list = []

    for entry in data:
        time = datetime.datetime.strptime(entry['time'], '%Y-%m-%d %H:%M:%S')
        dev_name, cap_name, value = translateCapability(entry, template_dict=template_dict, boolean_map=boolean_map)
        # if only_sensor and dev_name in template_dict and cap_name in template_dict[dev_name] and \
        #         'external' not in template_dict[dev_name][cap_name]:
        #     continue
        cap_name = dev_name + '.' + cap_name
        if cap_name in cap_list:
            if type(value) == int:
                value = str(value)
            elif type(value) == bool:
                value = 'true' if value else 'false'
            else:
                value = value
            action = cap_name + '=' + value
            action_list.append((time, action, entry['external'] if if_disting_ext else True))

    trace = Trace(system.saveToStateVector(), system, action_list)

    if trunc_none:
        no_none = [all([v is not None for v in vl]) for vl in trace.pre_condition]
        try:
            first_index = no_none.index(True)
            trace.actions = trace.actions[first_index:]
            trace.is_ext_list = trace.is_ext_list[first_index:]
            trace.pre_condition = trace.pre_condition[first_index:]
            trace.initial_state = trace.pre_condition[0]
        except ValueError:
            trace.actions = []
            trace.is_ext_list = []
            trace.pre_condition = []

    if only_sensor:
        time_list = [t for t, _ in trace.actions]
        action_list = [a for _, a in trace.actions]
        is_ext_list = [i for i in trace.is_ext_list]

        tai_list = [(t, a, i)
                    for t, a, i in zip(time_list, action_list, is_ext_list)
                    if 'external' in template_dict[a.split('=')[0].split('.')[0]][a.split('=')[0].split('.')[1]]]

        trace = Trace(trace.initial_state, system, tai_list)

    return trace


def updateTraceFromList(trace, log_list, template_dict=template_dict, boolean_map=boolean_map, if_disting_ext=False):
    cap_list = trace.system.getFieldNameList()
    for entry in log_list:
        time = datetime.datetime.strptime(entry['time'], '%Y-%m-%d %H:%M:%S')
        dev_name, cap_name, value = translateCapability(entry, template_dict=template_dict, boolean_map=boolean_map)
        # if only_sensor and dev_name in template_dict and cap_name in template_dict[dev_name] and \
        #         'external' not in template_dict[dev_name][cap_name]:
        #     continue
        cap_name = dev_name + '.' + cap_name
        if cap_name in cap_list:
            if type(value) == int:
                value = str(value)
            elif type(value) == bool:
                value = 'true' if value else 'false'
            else:
                value = value
            action = cap_name + '=' + value
            trace.addAction(time, action, is_ext=entry['external'] if if_disting_ext else True)
    return trace


def inputLogWithoutTAP(filename: str):
    """
    Translate a IoTCore log into a LogSystem object. It currently has no TAP support.
    :param filename:
    :return:
    """
    with open(filename, 'r') as fp:
        data = json.load(fp)

    cap_list = list({(entry['device_id'], entry['capability'], entry['attribute']) for entry in data})
    init_value_dict = {key: None for key in cap_list}
    ls = LogSystem(cap_list=cap_list, tap_dict={}, init_value_dict=init_value_dict, start_time=datetime.datetime.min)

    for entry in data:
        current_time = datetime.datetime.strptime(entry['time'], '%Y-%m-%d %H:%M:%S')
        device_id = entry['device_id']
        capability = entry['capability']
        attribute = entry['attribute']
        _, _, value = translateCapability(entry)

        event = Event(device_id=device_id, cap_name=capability, attribute_name=attribute, value=value)
        ls.addEvent(event, current_time, is_ext=True)

    return ls
