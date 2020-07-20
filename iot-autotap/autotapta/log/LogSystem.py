import datetime
import uuid
import copy


class Event(object):
    def __init__(self, device_id, cap_name, attribute_name, value):
        self.device_id = device_id
        self.cap_name = cap_name
        self.attribute_name = attribute_name
        self.value = value


class LogEntry(object):
    # log_data (for 'event' type): 'device_id', 'cap_name', 'attribute_name', 'value': value, 'is_ext'
    # log_data (for 'initial' type): {}
    # log_data (for 'del_tap' type): 'tap_id': id of tap
    # log_data (for 'add_tap' type): 'trigger', 'condition': [list of conditions], 'action'
    def __init__(self, log_type, log_data, post_value_list, post_tap_dict, current_time):
        self.log_type = log_type
        self.log_time = current_time
        self.log_data = log_data

        self.post_value_list = post_value_list
        self.post_tap_dict = post_tap_dict


class LogSystem(object):
    # TODO: how to interpret timing rules?
    def __init__(self, cap_list, tap_dict, init_value_dict, start_time):
        # in each type, the cap name will be formatted as 'device_id.[cap_name]_[attribute_name]'
        # TODO: should we store the type of variables?
        # use device id instead of plain device name
        self.cap_list = cap_list  # each entry: (device_id, cap_name, attribute_name)
        # self.tap_dict = {uuid.uuid4(): tap for tap in tap_list}
        self.tap_dict = tap_dict
        current_value_list = [init_value_dict[cap] for cap in cap_list]

        self.log_list = list()
        initial_log = LogEntry(log_type='initial', log_data={},
                               post_value_list=copy.deepcopy(current_value_list),
                               post_tap_dict=copy.deepcopy(self.tap_dict),
                               current_time=start_time)
        self.current_value_list = current_value_list
        self.log_list.append(initial_log)

    # should treat external events as something else
    # should also log TAP changes (the history should be maintained)
    def addEvent(self, event: Event, current_time, is_ext=True):
        self.current_value_list[
            self.cap_list.index((event.device_id, event.cap_name, event.attribute_name))
        ] = event.value

        log_data = {'device_id': event.device_id, 'cap_name': event.cap_name,
                    'attribute_name': event.attribute_name, 'value': event.value,
                    'is_ext': is_ext}
        log_entry = LogEntry(log_type='event', log_data=log_data,
                             post_value_list=copy.deepcopy(self.current_value_list),
                             post_tap_dict=copy.deepcopy(self.tap_dict),
                             current_time=current_time)
        self.log_list.append(log_entry)

    def deleteTAP(self, tap_id, current_time):
        del self.tap_dict[tap_id]

        log_data = {'tap_id': tap_id}
        log_entry = LogEntry(log_type='del_tap', log_data=log_data,
                             post_value_list=copy.deepcopy(self.current_value_list),
                             post_tap_dict=copy.deepcopy(self.tap_dict),
                             current_time=current_time)
        self.log_list.append(log_entry)

    def addTAP(self, tap_id, tap, current_time):
        self.tap_dict[tap_id] = tap

        log_data = {'trigger': tap.trigger, 'condition': tap.condition, 'action': tap.action}
        log_entry = LogEntry(log_type='add_tap', log_data=log_data,
                             post_value_list=copy.deepcopy(self.current_value_list),
                             post_tap_dict=copy.deepcopy(self.tap_dict),
                             current_time=current_time)
        self.log_list.append(log_entry)

    def getTAPList(self, current_time=None):
        # if current_time not defined, use latest TAP list
        if current_time:
            tap_dict = {}  # empty if current_time < initial_time
            for log in self.log_list:
                if log.log_time <= current_time:
                    tap_dict = log.post_tap_dict
                else:
                    break
            return tap_dict
        else:
            return self.tap_dict

    def getLog(self, start_time, end_time):
        # get all events within (start_time, end_time)
        return [log for log in self.log_list if start_time <= log.log_time <= end_time]
