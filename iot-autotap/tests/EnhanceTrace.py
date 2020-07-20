## enhance trace with a TAP rule. Calculate times when the tap rule is triggered

from autotapta.input.IoTCore import inputTrace, inputTraceFromList
from autotapmc.model.Tap import Tap
from autotapta.analyze.Analyze import calcTriggerTime, extractEpisodes
from autotapta.model.Trace import enhanceTraceWithTiming
import json
import datetime


def inputFromJson(filename: str):
    with open(filename, 'r') as fp:
        dct = json.load(fp)
        return dct['trace'], dct['template_dict'], dct['boolean_map']




filename = 'data/trace-pedro.json'
trace_raw, template_dict, boolean_map = inputFromJson(filename)

trace = inputTraceFromList(trace_raw, trunc_none=True, template_dict=template_dict, boolean_map=boolean_map)
trace = enhanceTraceWithTiming(trace, [('aeotec_multisensor_6.detect_motion_status', 60)])

tap = Tap(trigger='60#aeotec_multisensor_6.detect_motion_status=false',
          condition=['aeotec_multisensor_6.detect_motion_status=false',
                     'multipurpose_sensor.acceleration_sensor_acceleration=false',
                     'aeotec_multisensor_6.illuminance_measurement_illuminance<72',
                     'wifi_smart_plug__kettle.power_meter_power>-1'],
          action='hue_color_lamp_1.power_onoff_setting=false')
target_action = tap.action

episode_list = extractEpisodes(trace, target_action,
                               pre_time_span=datetime.timedelta(minutes=5),
                               post_time_span=datetime.timedelta(minutes=5))

for episode in episode_list:
    start_time = episode.actions[0][0]

    trigger_time_list = calcTriggerTime(tap, episode)
    trigger_time_dct_list = [{'time': t.strftime('%Y-%m-%d %H:%M:%S'), 'rule': str(tap)} for t in trigger_time_list]

    print(trigger_time_dct_list)

# outputname = 'data/trace-pedro-enhanced-temp.json'
# with open(outputname, 'w+') as fp:
#     json.dump({'trace': trace_raw, 'template_dict': template_dict, 'boolean_map': boolean_map,
#                'trigger_time': trigger_time_dct_list}, fp)

# print(trigger_time_dct_list)
