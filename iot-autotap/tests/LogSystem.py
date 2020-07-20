import datetime
from autotapta.input.IoTCore import inputLogWithoutTAP


ls = inputLogWithoutTAP('data/traces-blase-2019-04-25.json')

start_time = datetime.datetime(2019, 4, 24)
end_time = datetime.datetime(2019, 4, 25)
selected_log = ls.getLog(start_time=start_time, end_time=end_time)
print(selected_log)
print(ls)
