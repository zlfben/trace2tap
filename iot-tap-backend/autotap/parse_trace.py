import re
from datetime import datetime

caps_to_ignore = ["healthCheck", "temperatureMeasurement", "threeAxis",
                  "accelerationSensor", "colorTemperature", "switchLevel",
                  "Acceleration Sensor",
                  "Brightness", "Light Color", "Color Temperature", "Tamper Alert"]

def parse_clean_device(trace):
    """
    return a device_dict if trace useful, otherwise None
    """
    cap = re.sub(r'\n', '', trace['capability'])
    dev_name = re.sub(r'\n', '', trace['device_name']).title()
    current_value = re.sub(r'\n', '', trace["current_value"]).lower()
    # if cap in caps_to_ignore:
    #     return None
    # if 'Smartphone' in dev_name or 'Button' in dev_name \
    # or 'Weather' in dev_name:
    #     return None
    # if 'colorControl' in cap and not 'colorControl' in attribute:
    #     return None
    # # Ignore smart outlets, which tend to be turned on once and then remain on for many days
    # if cap == 'Power On/Off' and 'Outlet' in dev_name:
    #     return None

    # if cap == 'Current Temperature' and 'Aeotec' not in dev_name:
    #     return None

    # # Standardize device names for Aeotec data
    # # Please note that for now, I have made the assumption that only Aeotec devices
    # # report indoor temp/humidity/illuminance. This may change in future
    # if "Aeotec" in dev_name:
    #     if "Humidity" in cap and "Aeotec" in dev_name:
    #         dev_name = "Indoor Humidity"
    #     elif "Temp" in cap:
    #         dev_name = "Indoor Temp"
    #     elif "Il" in cap:
    #         dev_name = "Illuminance"
    #     else:
    #         dev_name = "Aeotec Sensor: Motion"
            
    # # No need to track when motion stops as a seperate event
    # if "no motion" in current_value:
    #     return None    

    # # Standardize names for on/off switches
    # if "Power" in cap:
    #     cap = "switch"
    #     if current_value == '0.0' or current_value == '0' or \
    #     current_value == 0 or current_value == "off":
    #         return None
    #     else:
    #         current_value = "on"
    
    return {'device_name': dev_name, 'capability': cap, 
                    'current_value': current_value}

def parse_trace(trace_list, rule_time_list, dev_cap_list, rule_dev_cap_list, target_dev_cap):
    """
    return {
    'device_list': ['blah', ...]
    'time_list': [{'time': '07-30 05:18, 'current_values': ['closed', ..]}, ]
    }
    """
    date_time_dict = {}
    device_cap_dict = {}
    for trace in trace_list:
        date = datetime.strptime(trace['time'], '%Y-%m-%d %H:%M:%S')
        date_str = date.strftime('%m-%d %H:%M')
        parsed_device = parse_clean_device(trace)
        if parsed_device is not None: # useful trace
            dev_cap = (trace['device_name'], trace['capability'])
            device_name = parsed_device['device_name']
            if not device_name in device_cap_dict:
                device_cap_dict[device_name] = parsed_device['capability']
            if not date_str in date_time_dict:
                date_time_dict[date_str] = {}
            if not dev_cap in date_time_dict[date_str]:
                date_time_dict[date_str][dev_cap] = []
            date_time_dict[date_str][dev_cap].append(parsed_device['current_value'])
    
    rule_date_time_dict = dict()
    for rule_times, rule_index in zip(rule_time_list, range(len(rule_time_list))):
        for rt in rule_times:
            date_str = rt.strftime('%m-%d %H:%M')
            if not date_str in rule_date_time_dict:
                rule_date_time_dict[date_str] = {rule_index: [] for rule_index in range(len(rule_time_list))}
            rule_date_time_dict[date_str][rule_index].append('triggered')
    
    device_list = [dev for dev, _ in dev_cap_list]
    cap_list = [cap for _, cap in dev_cap_list]
    
    rule_sensor_list = []
    for d_c_list in rule_dev_cap_list:
        sensor_d_c_list = []
        for d_c in d_c_list:
            try:
                d_c_index = dev_cap_list.index(d_c)
                sensor_d_c_list.append(d_c_index)
            except ValueError:
                pass
        rule_sensor_list.append(sensor_d_c_list)

    try:
        target_action_id = dev_cap_list.index(target_dev_cap)
    except ValueError:
        target_action_id = None

    ret_dict = {'device_list': device_list, 'cap_list': cap_list, 'rule_sensor_list': rule_sensor_list, 
                'time_list': [], 'target_action_id': target_action_id}
    for date_str in sorted(list(set(list(date_time_dict.keys()) + list(rule_date_time_dict.keys())))):
        res_list = []
        for device, cap in zip(device_list, cap_list):
            if date_str not in date_time_dict or (device, cap) not in date_time_dict[date_str]:
                res_list.append([]) # empty string
            else:
                res_list.append(date_time_dict[date_str][(device, cap)])
        rt_list = []
        for rule_id in range(len(rule_time_list)):
            if date_str not in rule_date_time_dict or rule_id not in rule_date_time_dict[date_str]:
                rt_list.append([])
            else:
                rt_list.append(rule_date_time_dict[date_str][rule_id])
        
        ret_dict['time_list'].append({'time': date_str,'current_values': res_list, 'rule_triggers': rt_list})

    return ret_dict


def parse_trace_new(time_dict_list):
    ret_list = []
    for time_dict in time_dict_list:
        log = []
        for date_str in sorted(list(set(list(time_dict.keys())))):
            log.append({'time': date_str, 'current_values': time_dict[date_str]})
        ret_list.append({'time_list': log})
    
    return ret_list
