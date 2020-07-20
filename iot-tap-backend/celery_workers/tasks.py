from __future__ import absolute_import, unicode_literals
import sys
from celery.decorators import task, periodic_task
from backend import models as m
from backend import util as backend_util
from django.conf import settings
import json
# import redis    # share variable between workers should use redis. Currently limit worker count to 1.

import backend.st_util as st_util


import datetime
# import pytz
import requests

# =========== consts
TIME_OFFSET_BEIJING = +8 
TIME_OFFSET_CHICAGO = -5 # chicago = utc + (-5)
TIME_OFFSET_UTC = 0

TIME_OFFSET_BASE = TIME_OFFSET_CHICAGO
TIME_OFFSET_PYTHON = TIME_OFFSET_UTC



# celery worker initialize
# =========== variables
time_table = [
    (12, 5), # (hour, minute)
    (13, 0),
    (10, 40),
    (10, 41),
    (10, 42),
]
# location_id_list = [] # format: [<id1>, <id2>, ...] id in database, not smartthings id.
app_id_map = dict()  # Format: {<app_id>: <location_id> 
last_time = datetime.datetime.utcnow()
print("# [TIMER & HISTORY] ----- tasks.py is imported. time:" + str(last_time))

#########################################
#  tasks for timer
#########################################


def trans_timezone(tm: tuple, from_timezone:int, to_timezone:int):
    '''
    translate time zone
    '''
    hour = (tm[0] + to_timezone - from_timezone) % 24
    second = tm[1]
    return (hour, second)



def compare_clock_time(t1:tuple, t2:tuple):
    ti1 = int('%03d%03d'%(t1[0], t1[1]))
    ti2 = int('%03d%03d'%(t2[0], t2[1]))
    if ti1 < ti2:
        return -1
    elif ti1 == ti2:
        return 0
    else:
        return 1

assert compare_clock_time((10,2),(10,3)) == -1
assert compare_clock_time((10,43),(10,43)) == 0
assert compare_clock_time((15,5),(1,55)) == 1


def datetime_to_clocktime(t1:datetime.datetime):
    return (t1.hour, t1.minute)


# time range don't include start point
def clock_time_in_range(tcheck:tuple, tfrom:tuple, tto:tuple):
    comp0 = compare_clock_time(tfrom, tto)
    assert comp0 != 0
    comp1 = compare_clock_time(tfrom, tcheck)
    comp2 = compare_clock_time(tcheck, tto)
    if comp0 < 0: # tfrom < tto
        if comp1 < 0 and comp2 <= 0:
            return True
        else:
            return False
    else:           # inverted range
        if comp1 < 0: # tfrom < tto
            assert comp2 > 0
            return True
        elif comp1 > 0:  # tfrom > tcheck
            if comp2 <= 0: # tcheck < tto
                return True
            else:
                return False


assert clock_time_in_range((10,0), (12,0), (14,0)) == False
assert clock_time_in_range((10,0), (8,0), (14,0)) == True
assert clock_time_in_range((10,0), (8,0), (10,0)) == True
assert clock_time_in_range((8,0), (8,0), (10,0)) == False


from backend import capmap
# for location_id, for st_installed_app_id
def triggering_time(tt:tuple):
    '''
    API url definition: https://github.com/UChicagoSUPERgroup/iot-core/blob/4b9bcd179862a8068a349960b5adf61cc5cfd7ef/smartthings/urls.py#L18
    API handler: https://github.com/UChicagoSUPERgroup/iot-core/blob/production/smartthings/util.py#L134
    If any rules triggered, send actions to iot-core.
    '''
    print("# [TIMER] triggering_time called.")
    clock_caps = capmap.lookup('Clock', 'vd') 
    assert len(clock_caps) == 1 # only one cap should be found.
    clock_cap = clock_caps[0]

    
    new_values =  {"time": "%02d:%02d" % (tt[0], tt[1])}
    # print("# [TIMER] new_values:" + str(new_values))

    # process triggering for each location
    # each location should have 1 Clock Device.
    app_processed_count = 0
    for location in m.Location.objects.all():
        location_id = location.id
        # get device according to location
        # print("# [TIMER] try to get timer device for location.id " + str(location_id))
        timer_device_set = m.LocationVirtualDevices.objects.filter(location=location)
        assert timer_device_set.count() == 1 # There should be only one Timer.
        timer_device = timer_device_set[0].clock_dev

        for app_id in app_id_map: # for loop find the apps in this location.
            if app_id_map[app_id] == location_id:
                app_processed_count += 1

                json_actions = backend_util.vd_process_update(
                    {
                        "st_installed_app_id": app_id,
                        "capid": clock_cap.name,
                        "deviceid": timer_device.id,
                        "values": new_values
                    })
                
                print("# [TIMER] triggering_time json_actions prepared.", json_actions)
                if json_actions['actions']:
                    st_util.execute_commands_on_core_vd(location, json_actions)
                # url = settings.IOTCORE_URL + 'st/installed-apps/%s/command/' % app_id
                # requests.post(url, data=json_actions)
                # print("# [TIMER] triggering_time json_actions sent to" + url)

    assert app_processed_count == len(app_id_map) # all apps should be processed.



# ================ periodic task ================
@task
def check_current_timer():
    '''
    check current timer, call the triggering time
    '''
    # print("# [TIMER] check_current_timer called...")
    global last_time        # TODO: to support last_time under concurrency.
    first_time = last_time
    # first_time = datetime.datetime.utcnow() - datetime.timedelta(minutes=1)
    second_time = datetime.datetime.utcnow() # get UTC time.
    t1 = datetime_to_clocktime(first_time)
    t2 = datetime_to_clocktime(second_time)

    comp = compare_clock_time(t1, t2) 
    any_time_hit = False
    hit_time_list = list()
    if comp == 0:
        pass
        # print("# [TIMER] WARNING from check_current_timer: this task is called to frequently.", file=sys.stderr)
    if comp != 0: 
        for time_entry in time_table:
            if clock_time_in_range(time_entry, t1, t2):
                any_time_hit = True # set true have no problem.
                hit_time_list.append(time_entry)
    if any_time_hit:
        assert len(hit_time_list) > 0
        for hit_time in hit_time_list:
            # print("# [TIMER] check_current_timer: trigging " + str(hit_time))
            triggering_time(hit_time)

    # update last time.
    last_time = second_time
        


# ================ async task ================

@task
def update_db_cache():
    '''
    notified by backend, 
    means rules is modified, re-read database is needed.
    task: read the databse,  update time_table.
    '''
    # print("# [TIMER] update_timetable called...")
    
    global app_id_map
    global time_table

    app_id_map = dict()
    time_table = list()

    esrules = m.ESRule.objects.all()
    for esrule in esrules:
        # print("# [TIMER] esrule: %s" % (esrule))
        cond_set = m.Condition.objects.filter(trigger=esrule.Etrigger)
        for cond in cond_set:
            # print("     # [TIMER] cond: %s" % (cond))
            if cond.par.type != 'time':
                continue
            else:
                assert (cond.comp == '=') # time Etrigger must use '='
                # TOCHECK
                time_val = [int(x) for x in cond.val.split(':')]
                assert len(time_val) == 2
                # print("# [TIMER] find time_val :" + str(time_val))
                time_table.append(time_val)

        app_id_map[esrule.st_installed_app_id] = None
        location_set = m.Location.objects.filter(
            st_installed_app_id=esrule.st_installed_app_id)
        assert location_set.count() == 1
        app_id_map[esrule.st_installed_app_id] = location_set[0].id

    # print("# [TIMER] update_db_cache done. ")
    # print("     # [TIMER] time_table: " + str(time_table))
    # print("     # [TIMER] app_id_map: " + str(app_id_map))



# init db_cache
try:
    update_db_cache()
except:
    pass
    # print("# [TIMER & HISTORY] If this is backend, fine. If this is celery_worker, it seems update cache is failed.")

# print("#  ----- [TIMER & HISTORY] init done.")





#########################################
#  tasks for historical
#########################################

# ======================================================================
# Solution 1. This is just responsible for time delay.

@task
def triggering_history_event(log_id:int, delay_seconds:int):
    '''
    this function should be called by backend when a Etrigger of a History Rule is triggered.
    PARAM1: target_Etrigger has the meaning of (After <source_Etrigger> <delay_time>)
    PARAM2: delay_time in seconds
    FORMAT: triggering_history_event.apply_async((<par1>, <par2>), countdown=<seconds_count>)

    Question: If two rules' Etriggers are both "After Light On 5 minutes", wuill they use the same Etrigger ?
    '''
    # print("# [HISTORY] triggering_history_event called. delayed: %s" % delay_seconds)
    state_log = m.StateLog.objects.get(id=log_id)
    json_resp = backend_util.vd_process_update_history(state_log, delay_seconds)
    # print('[HISTORY]: ' + str(json_resp))
