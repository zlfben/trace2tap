from autotapta.input.IoTCore import inputTrace
from autotapta.analyze.Analyze import calcMutualInformation, synthesizeRuleWithSatSolver, truncateTraceByLastAction
from autotapta.input.Template import template_dict


trace = inputTrace('data/traces-blase-2019-04-25.json',
                   ['Unknown.motionSensor_motion',
                    'Blases_Smartphone.presenceSensor_presence',
                    'Door_contact_sensor.contactSensor_contact',
                    'Hue_lightstrip_plus_2.switch_switch'])
                   # ['Unknown.motionSensor_motion', 'Hue_ambiance_lamp_1.switch_switch',
                   #  'Blases_Smartphone.presenceSensor_presence'])


# field_name_list = trace.system.getFieldNameList()
# mi_list = list()

target_action = 'Hue_lightstrip_plus_2.switch_switch=true'

truncateTraceByLastAction(trace, target_action)
trace.initial_state = trace.pre_condition[-4]
trace.actions = trace.actions[-4:-1]
trace.pre_condition = trace.pre_condition[-4:-1]
trace.is_ext_list = trace.is_ext_list[-4:-1]

# for field_name in field_name_list:
#     mi, entropy = calcMutualInformation(trace, field_name, target_action)
#     mi_list.append((field_name, mi / entropy))
#
# entropy_list = sorted(mi_list, reverse=True, key=lambda x: x[1])
#
# variable_list = [var_name for var_name, entropy in entropy_list[:3]]

synthesizeRuleWithSatSolver(trace, 'Hue_lightstrip_plus_2.switch_switch=true',
                            variable_list=trace.system.getFieldNameList(), template_dict=template_dict)

