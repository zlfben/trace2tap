import json
import matplotlib.pyplot as plt
import datetime
from autotapta.input.IoTCore import inputTrace

with open('data/traces-blase-2019-07-17.json', 'r') as fp:
    data = json.load(fp)
data = [entry for entry in data if entry['capability'] != 'healthCheck']
dev_set = {entry['device_name'] for entry in data}
for entry in data:
    entry['datetime'] = datetime.datetime.strptime(entry['time'], '%Y-%m-%d %H:%M:%S')
dev_list = list({(entry['device_name'], entry['capability']) for entry in data})
dev_index_list = range(len(dev_list))
x_list = list()
y_list = list()
for dev, dev_index in zip(dev_list, dev_index_list):
    device, capability = dev
    x = [entry['datetime'] for entry in data if entry['device_name'] == device and entry['capability'] == capability]
    y = [dev_index] * len(x)
    x_list.append(x)
    y_list.append(y)

plt.figure()
for x, y in zip(x_list, y_list):
    plt.plot(x, y, 'x')
plt.yticks(dev_index_list, [str(dev) for dev in dev_list])
plt.show()

trace = inputTrace('data/traces-blase-2019-07-17.json')
field_hold_dict = dict()
field_list = trace.system.getFieldNameList()
field_on_list = list()
for action_tup, pre_condition in zip(trace.actions, trace.pre_condition):
    time, action = action_tup
    trace.system.restoreFromStateVector(pre_condition)
    trace.system.applyActionBypassChannelModel(action)
    post_condition = trace.system.saveToStateVector()
    for field_name, value in zip(field_list, post_condition):
        if type(value) == bool:
            if value and field_name not in field_hold_dict:
                field_hold_dict[field_name] = time
            elif not value and field_name in field_hold_dict:
                field_on_list.append((field_name, field_hold_dict[field_name], time))
                del field_hold_dict[field_name]

bool_field_list = list({fn for fn, _, _ in field_on_list})
plt.figure()
for field_name, start_time, end_time in field_on_list:
    x = [start_time, end_time]
    y = [bool_field_list.index(field_name)] * 2
    plt.plot(x, y, linewidth=20)
plt.yticks(range(len(bool_field_list)), bool_field_list)
plt.show()
