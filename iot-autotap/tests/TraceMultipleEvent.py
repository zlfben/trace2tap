from autotapta.input.IoTCore import inputTrace, inputTraceFromList
from autotapta.analyze.Analyze import synthesizeRuleBasedOnMultipleEvents, extractEpisodes, \
    synthesizeRuleBasedOnEpisodes, calcTimingCorrelation, listTimingCandidates, \
    synthesizeTimingRuleBasedOnEpisodes, listRelatedCandidates, synthesizeTimingRuleBasedOnEpisodesSplit, \
    synthesizeRuleGeneral
from autotapta.analyze.Rank import calcScore
# from autotapta.input.Template import template_dict
from autotapta.model.Trace import enhanceTraceWithTiming
from autotapta.analyze.DecisionTree import traceToTree, traceToTreeTiming
import datetime
import json


def inputFromJson(filename: str):
    with open(filename, 'r') as fp:
        dct = json.load(fp)
        return dct['trace'], dct['template_dict'], dct['boolean_map']


# template_dict = {"lamp__sandy": {"brightness_level": "numeric", "power_onoff_setting": "bool", "color_temperature_colortemperature": "numeric"}, "weather": {"relative_humidity_measurement_humidity": "numeric, external", "current_temperature_temperature": "numeric, external", "weather_sensor_weather": "set, external, [Drizzle, Clouds, Mist, Rain, Thunderstorm, Snow, Smoke, Clear, Haze, Dust, Fog, Sand, Ash, Squall, Tornado]"}, "multipurpose_sensor": {"contact_sensor_contact": "bool, external", "acceleration_sensor_acceleration": "bool, external", "current_temperature_temperature": "numeric, external"}, "hue_color_lamp_2__annie": {"brightness_level": "numeric", "power_onoff_setting": "bool", "color_temperature_colortemperature": "numeric"}, "motion_sensor__sandy": {"detect_motion_status": "bool, external", "current_temperature_temperature": "numeric, external"}, "wifi_smart_plug_humidifier": {"power_onoff_setting": "bool", "power_meter_power": "numeric, external"}, "aeotec_multisensor_6": {"relative_humidity_measurement_humidity": "numeric, external", "tamper_alert_tamper": "bool, external", "ultraviolet_index_ultravioletindex": "numeric, external", "detect_motion_status": "bool, external", "current_temperature_temperature": "numeric, external", "illuminance_measurement_illuminance": "numeric, external"}, "button__sandy": {"current_temperature_temperature": "numeric, external"}, "motion_sensor_annie": {"detect_motion_status": "bool, external", "current_temperature_temperature": "numeric, external"}, "button__annie": {"current_temperature_temperature": "numeric, external"}}
# boolean_map = {'true': ['active', 'Yes', 'Awake', 'Raining', 'Smoke Detected', 'On', 'Open', 'Locked', 'detected', 'open', 'Day', 'Motion'], 'false': ['Unlocked', 'No', 'No Motion', 'clear', 'closed', 'Closed', 'Asleep', 'No Smoke Detected', 'inactive', 'Night', 'Not Raining', 'Off']}
filename = 'data/trace-pedro.json'
trace_raw, template_dict, boolean_map = inputFromJson(filename)

trace = inputTraceFromList(trace_raw, trunc_none=True, template_dict=template_dict, boolean_map=boolean_map)
                   # target_cap_list=['Unknown.motionSensor_motion',
                   #  'Blases_Smartphone.presenceSensor_presence',
                   #  'Hue_lightstrip_plus_2.switch_switch',
                   #  'Door_contact_sensor.contactSensor_contact',
                   #  'Lamp.switch_switch'])
                   # ['Unknown.motionSensor_motion', 'Hue_ambiance_lamp_1.switch_switch',
                   #  'Blases_Smartphone.presenceSensor_presence'])


target_action = 'hue_color_lamp_1.power_onoff_setting=false'
# traceToTree(trace, target_action, template_dict)

cap_trigger = listTimingCandidates(trace, target_action, 3, template_dict=template_dict)
cap_condition = listRelatedCandidates(trace, target_action, 3, template_dict=template_dict)

cap_time_list = [(cap, time) for cap, time, _ in cap_trigger if time > 1]
cap_trigger_list = [cap for cap, _, _ in cap_trigger]
cap_condition_list = [cap for cap, _ in cap_condition]

cap_list = [cap for cap, _, _ in cap_trigger]
cap_list = cap_list + [cap for cap, _ in cap_condition]
cap_list = list(set(cap_list))
target_cap = target_action.split('=')[0]
if target_cap not in cap_list:
    cap_list.append(target_cap)

# cap_list = ['motion_sensor_annie.current_temperature_temperature', 'multipurpose_sensor.acceleration_sensor_acceleration', 'wifi_smart_plug_humidifier.power_meter_power', 'multipurpose_sensor.contact_sensor_contact', 'aeotec_multisensor_6.current_temperature_temperature', 'motion_sensor_annie.detect_motion_status', 'lamp__sandy.power_onoff_setting']

trace = inputTraceFromList(trace_raw, trunc_none=True, target_cap_list=cap_list, template_dict=template_dict, boolean_map=boolean_map)
new_trace = enhanceTraceWithTiming(trace, cap_time_list, '*')
#
# field_name_list = trace.system.getFieldNameList()
episode_list = extractEpisodes(new_trace, target_action,
                               pre_time_span=datetime.timedelta(minutes=5),
                               post_time_span=datetime.timedelta(minutes=5))
# tap_list = synthesizeTimingRuleBasedOnEpisodesSplit(episode_list, target_action, learning_rate=0.7,
#                                                     variable_list=cap_list, trig_var_list=cap_trigger_list,
#                                                     cond_var_list=cap_condition_list, timing_cap_list=cap_time_list,
#                                                     template_dict=template_dict)

mask = '1' * len(episode_list)
while True:
    episode_list = [episode for episode, m in zip(episode_list, mask) if m == '1']
    synthesizeRuleGeneral(episode_list, target_action, learning_rate=0.5,
                          variable_list=cap_list, trig_var_list=cap_trigger_list,
                          cond_var_list=cap_condition_list, timing_cap_list=cap_time_list,
                          template_dict=template_dict)
    mask = input('Input mask (1 for considered entries, 0 for discarded): ')

# tap_list = synthesizeTimingRuleBasedOnEpisodes(episode_list, target_action, learning_rate=0.6,
#                                                template_dict=template_dict, timing_cap_list=cap_time_list)

# print('========== Finished ==========')
# score_tap_list = [(calcScore(new_trace, target_action, tap), tap) for tap in tap_list]
# score_tap_list = sorted(score_tap_list, key=lambda x: x[0][0], reverse=True)
# if len(score_tap_list) > 50:
#     score_tap_list = score_tap_list[:50]
# for score, tap in score_tap_list:
#     print(score, tap)

# display_dict = dict()
# for score, tap in score_tap_list:
#     trigger = tap.trigger
#     # if '#' in trigger:
#     #     trigger = trigger.split('#')[1]
#     if trigger not in display_dict:
#         display_dict[trigger] = [(score, tap)]
#     else:
#         display_dict[trigger].append((score, tap))
#
# for key in display_dict.keys():
#     display_dict[key] = sorted(display_dict[key], key=lambda x: x[0][0], reverse=True)
#
# for key in display_dict.keys():
#     cond_cap_list = list()
#     for score, tap in display_dict[key]:
#         for cond in tap.condition:
#             cond = cond.split('<=')[0]
#             cond = cond.split('>=')[0]
#             cond = cond.split('!=')[0]
#             cond = cond.split('>')[0]
#             cond = cond.split('<')[0]
#             cond = cond.split('=')[0]
#             if cond not in cond_cap_list:
#                 cond_cap_list.append(cond)
#     print('Trigger: %s, max score=%f' % (key, display_dict[key][0][0][0]))
#     print('Condition cap list: %s' % str(cond_cap_list))
#     for score, tap in display_dict[key]:
#         print('\t(score %s) %s' % (str(score), str(tap)))
# # calcTimingCorrelation(trace, 'Hue_lightstrip_plus_2.switch_switch=false',
# #                       'Unknown.motionSensor_motion', datetime.timedelta(seconds=780))
# # synthesizeRuleBasedOnEpisodes(episode_list, target_action, learning_rate=0.5, template_dict=template_dict)
