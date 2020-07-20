from autotapta.input.IoTCore import inputTrace, inputTraceFromList
from autotapta.analyze.Analyze import synthesizeRuleBasedOnMultipleEvents, extractEpisodes, \
    synthesizeRuleBasedOnEpisodes, calcTimingCorrelation, listTimingCandidates, \
    synthesizeTimingRuleBasedOnEpisodes, listRelatedCandidates, synthesizeTimingRuleBasedOnEpisodesSplit
from autotapta.analyze.Rank import calcScore
# from autotapta.input.Template import template_dict
from autotapta.model.Trace import enhanceTraceWithTiming, introduceTapToTrace, introduceHumanBehaviorToTrace
from autotapmc.model.Tap import Tap
from autotapta.analyze.DecisionTree import traceToTree
import datetime
import json


def inputFromJson(filename: str):
    with open(filename, 'r') as fp:
        dct = json.load(fp)
        return dct['trace'], dct['template_dict'], dct['boolean_map']


filename = 'data/trace-rob-0817.json'
trace_raw, template_dict, boolean_map = inputFromJson(filename)
tap_list = [Tap(action='table_lamp.power_onoff_setting=true',
                condition=[],
                trigger='multipurpose_sensor.contact_sensor_contact=true'),
            Tap(action='table_lamp.power_onoff_setting=false',
                condition=[],
                trigger='multipurpose_sensor.contact_sensor_contact=false')]
trace = inputTraceFromList(trace_raw, trunc_none=True, template_dict=template_dict, boolean_map=boolean_map, only_sensor=True)

for action, is_ext in zip(trace.actions, trace.is_ext_list):
    if not is_ext or 'table_lamp' in action[1]:
        print(is_ext, action)

human_tap = Tap(trigger='table_lamp.power_onoff_setting=true',
                condition=['aeotec_multisensor_6.illuminance_measurement_illuminance>100'],
                action='table_lamp.power_onoff_setting=false')
new_trace = introduceTapToTrace(trace, tap_list, template_dict)
new_trace = introduceHumanBehaviorToTrace(new_trace, human_tap, template_dict, 0.7)

traceToTree(new_trace, 'table_lamp.power_onoff_setting=false', template_dict)

# # target action, extrace episodes
# target_action = 'table_lamp.power_onoff_setting=false'
# episode_list = extractEpisodes(new_trace, target_action, post_time_span=datetime.timedelta(minutes=1))
#
# # find relevant vars
# cap_trigger = listTimingCandidates(new_trace, target_action, 3, template_dict=template_dict)
# cap_condition = listRelatedCandidates(new_trace, target_action, 3, template_dict=template_dict)
#
# cap_time_list = [(cap, time) for cap, time, _ in cap_trigger if time > 1]
# cap_trigger_list = [cap for cap, _, _ in cap_trigger]
# cap_condition_list = [cap for cap, _ in cap_condition]
#
# cap_list = [cap for cap, _, _ in cap_trigger]
# cap_list = cap_list + [cap for cap, _ in cap_condition]
# cap_list = list(set(cap_list))
# target_cap = target_action.split('=')[0]
# if target_cap not in cap_list:
#     cap_list.append(target_cap)
#
# # solve for patches
# tap_list = synthesizeTimingRuleBasedOnEpisodesSplit(episode_list, target_action, learning_rate=0.6,
#                                                     variable_list=cap_list, trig_var_list=cap_trigger_list,
#                                                     cond_var_list=cap_condition_list, timing_cap_list=cap_time_list,
#                                                     template_dict=template_dict)
#
# print(tap_list)
# # for time_action, pre_cond, is_ext in zip(new_trace.actions, new_trace.pre_condition, new_trace.is_ext_list):
# #     time, action = time_action
# #     if not is_ext:
# #         state = dict(zip(new_trace.system.getFieldNameList(), pre_cond))
# #         print(state)
# #         print(action)
# #         print('=====================')