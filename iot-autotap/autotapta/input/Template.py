template_dict = {
    'Round_lamp_1':
        {
            'switch_switch': 'bool',
            'colorTemperature_colorTemperature': 'numeric',
            'colorControl_saturation': 'numeric',
            'colorControl_hue': 'numeric',
            # 'colorControl_color': '???',
            'switchLevel_level': 'numeric'
        },
    'Blases_Smartphone':
        {
            'presenceSensor_presence': 'bool, external',
            'occupancySensor_occupancy': 'bool, external'
        },
    'Hue_ambiance_lamp_1':
        {
            'switch_switch': 'bool',
            'colorTemperature_colorTemperature': 'numeric',
            'switchLevel_level': 'numeric'
        },
    'Hue_lightstrip_plus_1':
        {
            'switch_switch': 'bool',
            'colorTemperature_colorTemperature': 'numeric',
            # 'colorControl_color': '???',
            'colorControl_saturation': 'numeric',
            'colorControl_hue': 'numeric',
            'switchLevel_level': 'numeric'
        },
    'Hue_bloom_1': {
            'switch_switch': 'bool',
            # 'colorControl_color': '???',
            'colorControl_hue': 'numeric',
            'colorControl_saturation': 'numeric',
            'switchLevel_level': 'numeric'
        },
    'Hue_lightstrip_plus_2':
        {
            'switch_switch': 'bool',
            'colorTemperature_colorTemperature': 'numeric',
            'colorControl_saturation': 'numeric',
            'colorControl_hue': 'numeric',
            # 'colorControl_color': '???',
            'switchLevel_level': 'numeric'
        },
    'Square_lamp_1':
        {
            'switch_switch': 'bool',
            'colorTemperature_colorTemperature': 'numeric',
            'colorControl_hue': 'numeric',
            'colorControl_saturation': 'numeric',
            # 'colorControl_color': '???',
            'switchLevel_level': 'numeric'
        },
    'Hue_ambiance_lamp_2':
        {
            'switch_switch': 'bool',
            'colorTemperature_colorTemperature': 'numeric',
            'switchLevel_level': 'numeric'
        },
    'Unknown':
        {
            'temperatureMeasurement_temperature': 'numeric, external',
            'motionSensor_motion': 'bool, external',
            'battery_battery': 'numeric, external'
        },
    'Lamp':
        {
            'switch_switch': 'bool'
        },
    'Door_contact_sensor':
        {
            'temperatureMeasurement_temperature': 'numeric, external',
            'contactSensor_contact': 'bool, external'
        }
}

boolean_map = {
    'true': ['on', 'present', 'occupied', 'active', 'open'],
    'false': ['off', 'not present', 'unoccupied', 'inactive', 'closed']
}


def translateCapability(data: dict, template_dict=template_dict, boolean_map=boolean_map):
    device_name = ''.join([ch for ch in data['device_name'].replace(' ', '_') if ch.isalnum() or ch == '_']).lower()
    cap_name = ''.join([ch for ch in data['capability'].replace(' ', '_') if ch.isalnum() or ch == '_']).lower()
    att_name = ''.join([ch for ch in data['attribute'].replace(' ', '_') if ch.isalnum() or ch == '_']).lower()
    cap_name = cap_name + '_' + att_name

    if device_name in template_dict and cap_name in template_dict[device_name]:
        value = data['current_value']
        if template_dict[device_name][cap_name].startswith('bool'):
            value = value in boolean_map['true']
        elif template_dict[device_name][cap_name].startswith('numeric'):
            value = int(float(value))
        else:
            value = value
    else:
        value = None

    return device_name, cap_name, value


def isInTemplate(cap_name: str, template_dict=template_dict):
    dev_name = cap_name.split('.')[0]
    var_name = cap_name.split('.')[1]
    return dev_name in template_dict and var_name in template_dict[dev_name]
