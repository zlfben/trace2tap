# model-related
from django.db.models import Q
from django.utils import timezone
from django.conf import settings
from . import models as m

# functionality
import operator as op
import datetime, random, re, traceback
from autotapta.analyze.Cluster import clusterRangeVars
from autotapta.input.Template import translateCapability
from autotapta.analyze.Analyze import extractEpisodes, extractTriggerCases, extractRevertCases
from autotapta.analyze.Rank import checkIfEpisodeCovered
from autotap.util import update_trace_in_cache
from autotap.variable import update_separation_count

# st-related
from . import capmap
from . import st_util

import json
import webcolors
from celery_workers import tasks

######################################
######################################
## INDEX                            ##
## FES :: FRONTEND / SELECTORS      ##
## STV :: ST-END VIEWS              ##
## RC  :: RULE CREATION             ##
## SPC :: SAFETY PROPERTY CREATION  ##
## SLM :: STATELOG MANAGEMENT       ##
## DM  :: DEVICE MANAGEMENT         ##
######################################
######################################

################################################################################
## [FES] FRONTEND / SELECTORS
################################################################################

def get_or_make_user(code,mode):
    try:
        user = m.User_ICSE19.objects.get(code=code)
    except m.User_ICSE19.DoesNotExist:
        user = m.User_ICSE19(code=code,mode=mode)
        user.save()
    return user

### @TO_DELETE: Potentially dead code
# return id:name dict of all devices
# def all_devs(user):
#     json_resp = {}
#     for dev in m.Device.objects.filter(users__contains=user):
#         json_resp[dev.id] = dev.name
#     return json_resp

### @TO_DELETE: Potentially dead code
# def user_devs(user):
#     if isinstance(user, m.User):
#         mydevs = m.Device.objects.filter(users__contains=user)
#     else:
#         mydevs = m.Device.objects.filter(owner=user)
#     pubdevs = m.Device.objects.filter(public=True)
#     return mydevs.union(pubdevs)

# return id:name dict of all channels
def valid_chans(user,is_trigger):
    json_resp = {'chans' : []}
    # for integration of user and user_icse19
    if isinstance(user, m.User):
        chans = m.Channel.objects.filter(Q(device__users__in=[user])).distinct().order_by('name')
        devs = m.Device.objects.filter(Q(users__in=[user]))
    else:
        chans = m.Channel.objects.filter(Q(capability__device__public=True)).distinct().order_by('name')
        devs = m.Device.objects.filter(Q(public=True))
    chans = filter(lambda x : chan_has_valid_cap(x,devs,is_trigger),chans)
    for chan in chans:
        json_resp['chans'].append({'id' : chan.id, 'name' : chan.name, 'icon' : chan.icon})
    return json_resp

def dev_has_valid_cap(dev,channel,is_trigger):
    poss_caps = dev.caps.all().intersection(m.Capability.objects.filter(channels=channel))
    if is_trigger:
        return any(map(lambda x : x.readable,poss_caps))
    else:
        return any(map(lambda x : x.writeable,poss_caps))

def dev_has_valid_cap_no_channel(dev, is_trigger):
    poss_caps = dev.caps.all()
    if is_trigger:
        return any(map(lambda x : x.readable,poss_caps))
    else:
        return any(map(lambda x : x.writeable,poss_caps))

def chan_has_valid_cap(chan,devs,is_trigger):
    dev_caps = m.Capability.objects.none()
    for dev in devs:
        dev_caps = dev_caps.union(dev.caps.all())
    poss_caps = m.Capability.objects.filter(channels=chan).intersection(dev_caps)
    if is_trigger:
        return any(map(lambda x : x.readable,poss_caps))
    else:
        return any(map(lambda x : x.writeable,poss_caps))

def rwfilter_caps(caps,is_trigger):
    if is_trigger:
        return filter((lambda x : x.readable),caps)
    else:
        return filter((lambda x : x.writeable),caps)

def map_labels(caps,is_trigger,is_event):
    if is_trigger:
        if is_event:
            return list(map((lambda x : (x.id,x.name,x.eventlabel)),caps))
        else:
            return list(map((lambda x : (x.id,x.name,x.statelabel)),caps))
    else:
        return list(map((lambda x : (x.id,x.name,x.commandlabel)),caps))

def filtermap_caps(caps,is_trigger,is_event):
    return map_labels(rwfilter_caps(caps,is_trigger),is_trigger,is_event)



###############################################################################
## [STV] ST-END VIEWS
###############################################################################

def is_valid_value(param,val):
    # not case sensitive
    val = val.lower()

    if param.type == 'set':
        try:
            m.SetParamOpt.objects.get(param_id=param.id,value=val)
            return True
        except m.SetParamOpt.DoesNotExist:
            return False
    elif param.type == 'range':
        try:
            floval = float(val)
        except ValueError:
            return False
        return (param.rangeparam.min <= floval <= param.rangeparam.max)
    elif param.type == 'bin':
        # not case sensitive
        return (param.binparam.tval.lower() == val or param.binparam.fval.lower() == val)
    elif param.type == 'input':
        if param.inputparam.inputtype == 'int':
            try:
                intval = int(val)
            except ValueError:
                return False
            else:
                return True
        else:
            return True
    else:
        #this shouldn't happen
        return False

def test_cond(cond,value):
    # for solving the case sensitive problem,
    # probably there's a better way to enforce this
    processed_value = value
    processed_cond_value = cond.val
    if cond.par.type == 'range':
        processed_value = float(processed_value)
        processed_cond_value = float(processed_cond_value)

    # timer support begin   -- by Bo Wang
    if cond.par.type == 'time':
        processed_value = processed_value.replace(':', '')
        processed_cond_value = processed_cond_value.replace(':', '')
    # timer support end


    if isinstance(value, str) and isinstance(cond.val, str):
        processed_value = value.lower()
        processed_cond_value = cond.val.lower()

    if cond.comp == '=':
        return op.eq(processed_value, processed_cond_value)
    elif cond.comp == '!=':
        return op.neq(processed_value, processed_cond_value)
    elif cond.comp == '<':
        return op.lt(processed_value, processed_cond_value)
    elif cond.comp == 'lte':
        return op.lte(processed_value, processed_cond_value)
    elif cond.comp == '>':
        return op.gt(processed_value, processed_cond_value)
    elif cond.comp == 'gte':
        return op.gte(processed_value, processed_cond_value)
    else:
        return None


def test_cond_dict(cond_par, cond_val, value):
    # for solving the case sensitive problem,
    # probably there's a better way to enforce this
    processed_value = value
    processed_cond_value = cond_val['value']
    if cond_par['type'] == 'range':
        processed_value = float(processed_value)
        processed_cond_value = float(processed_cond_value)

    # timer support begin   -- by Bo Wang
    if cond_par['type'] == 'time':
        processed_value = processed_value.replace(':', '')
        processed_cond_value = processed_cond_value.replace(':', '')
    # timer support end


    if isinstance(value, str) and isinstance(cond_val['value'], str):
        processed_value = value.lower()
        processed_cond_value = cond_val['value'].lower()

    if cond_val['comparator'] == '=':
        return op.eq(processed_value, processed_cond_value)
    elif cond_val['comparator'] == '!=':
        return op.neq(processed_value, processed_cond_value)
    elif cond_val['comparator'] == '<':
        return op.lt(processed_value, processed_cond_value)
    elif cond_val['comparator'] == 'lte':
        return op.lte(processed_value, processed_cond_value)
    elif cond_val['comparator'] == '>':
        return op.gt(processed_value, processed_cond_value)
    elif cond_val['comparator'] == 'gte':
        return op.gte(processed_value, processed_cond_value)
    else:
        return None


### @TO_DELETE: Potentially dead code
# determine if all Conditions of a Trigger are currently satisfied
# def check_trigger(trigger):
#     state = m.State.objects.get(cap=trigger_cap,dev=trigger_dev)
#     for cond in m.Condition.objects.filter(trigger=trigger):
#         try:
#             pv = m.ParVal.objects.get(state=state,par=cond_par)
#             if not test_cond(cond,pv.val):
#                 return False
#         except m.ParVal.DoesNotExist:
#             return False

#     return True

def update_state(cap,dev,param,val):
    '''
    Update/create PV corresponding to state of a given cap/dev pair. \n
    The state here stands for the current state of the device. \n
    Input:
        cap:    the related capability
        dev:    the related device
        param:  the parameter that should be updated
        val:    the new value of the parameter
    Output:
        pv:     the updated/created ParVal object
    '''
    # when is_action is False, the state is the state of a device's capability
    state = get_or_make_state(cap, dev, val, is_action=False)
    # ParVal specifies that for one specific state, what param/value it currently has
    try:
        pv = m.ParVal.objects.get(state=state,par=param)
        if param.type == 'color':
            hue, saturation = pv.val.split(',')
            target_hue, target_saturation = val.split(',')
            hue = hue if target_hue == '*' else target_hue
            saturation = saturation if target_saturation == '*' else target_saturation
            val = '%s,%s' % (hue, saturation)
        pv.val = val
        pv.save()
    except m.ParVal.DoesNotExist:
        pv = m.ParVal.objects.create(state=state,par=param,val=val)

    return pv

# @TODO: Get rid of `is_current` or don't use `State` as current state of the device
def update_log(cap, dev, parvals):
    '''
    Log the new event in StateLog and inactivate the old state.\n
    Input:
        cap     : the capability to be logged
        dev     : the device to be logged
        parvals : a list of ParVal objects
    Output:
        None
    '''
    # mark old log inactive (if one exists), and create new log
    for parval in parvals:
        is_superifttt = False
        # if there is a state that is triggered by superifttt but not confirmed yet
        # if it's a to-occur state, it has to be within 2 minutes
        old_entries = m.StateLog.objects.filter(
            timestamp__gte=get_now() - datetime.timedelta(seconds=120),
            status=m.StateLog.TO_OCCUR,
            cap=cap,
            dev=dev,
            loc=dev.location,
            param=parval.par,
            value=parval.val,
            is_superifttt=True
        ).all()
        if len(old_entries) > 0:
            # if there are TO_OCCUR StateLog, then delete them all and set is_superifttt to True
            old_entries.delete()
            is_superifttt = True

        # search for the current value of the param, change all of them to HAPPENED
        entries = m.StateLog.objects.filter(
            status = m.StateLog.CURRENT,
            cap = cap,
            dev = dev,
            loc = dev.location,
            param = parval.par
        ).all()
        # set all the found entries (although there should either be only one or none) to HAPPENED
        for entry in entries:
            entry.status = m.StateLog.HAPPENED
            entry.save()

        # if the old state is inactivated or cannot find a matching statelog,
        # then create a new entry
        state_log = m.StateLog.objects.create(
            status=m.StateLog.CURRENT,
            cap=cap,
            dev=dev,
            loc=dev.location,
            param=parval.par,
            value=parval.val,
            is_superifttt=is_superifttt
        )

        update_separation_count(state_log)
        update_trace_in_cache(state_log)
        schedule_history_triggered(state_log)
    return


def stval_to_val(param: m.Parameter, st_val):
    if param.type in ('bin', 'set'):
        try:
            return m.ParValMapping.objects.get(param=param, st_val=st_val).val
        except m.ParValMapping.DoesNotExist:
            err_msg = "cannot find error mapping for %s of parameter %s" % (st_val, param.name)
            m.ErrorLog.objects.create(err=err_msg)
            raise Exception(err_msg)
    elif param.type in ('range', 'color'):
        return st_val
    else:
        err_msg = "param type %s not supported yet" % param.type
        m.ErrorLog.objects.create(err=err_msg)
        raise Exception(err_msg)


def val_to_stval(param: m.Parameter, val):
    if param.type in ('bin', 'set'):
        try:
            return m.ParValMapping.objects.get(param=param, val=val).st_val
        except m.ParValMapping.DoesNotExist:
            err_msg = "cannot find error mapping for %s of parameter %s" % (val, param.name)
            m.ErrorLog.objects.create(err=err_msg)
            raise Exception(err_msg)
    elif param.type in ('range', 'color'):
        return val
    else:
        err_msg = "param type %s not supported yet" % param.type
        m.ErrorLog.objects.create(err=err_msg)
        raise Exception(err_msg)


def check_s_triggers(s_trigger_list):
    for s_trig in s_trigger_list:
        # state = m.State.objects.get(cap=s_trig.cap, dev=s_trig.dev)
        # conditions = m.Condition.objects.filter(trigger=s_trig)
        # for cond in conditions:
        #     try:
        #         val = m.ParVal.objects.get(par=cond.par, state=state).val
        #         if not test_cond(cond, val):
        #             return False
        #     except m.ParVal.DoesNotExist:
        #         err_msg = "unable to get current state of %s" % str(state)
        #         m.ErrorLog.objects.create(err=err_msg)
        #         raise Exception(err_msg)
        check_trig_func = check_history_s_trig if check_trigger_is_history(s_trig) else check_regular_s_trig
        if not check_trig_func(s_trig):
            return False
    
    return True


def check_trigger_is_history(trig):
    cap = trig.cap
    # TODO: currently use hard-coding. later we should 
    # add another field to indicate history trigger
    if cap.name == 'Time Since State':
        return True
    else:
        return False


def check_regular_s_trig(s_trig):
    state = m.State.objects.get(cap=s_trig.cap, dev=s_trig.dev)
    conditions = m.Condition.objects.filter(trigger=s_trig)
    for cond in conditions:
        try:
            val = m.ParVal.objects.get(par=cond.par, state=state).val
            if not test_cond(cond, val):
                return False
        except m.ParVal.DoesNotExist:
            err_msg = "unable to get current state of %s" % str(state)
            m.ErrorLog.objects.create(err=err_msg)
            raise Exception(err_msg)
    return True


def check_history_s_trig(s_trig):
    conditions = list(m.Condition.objects.filter(trigger=s_trig))  # should have a time condition and a trigger condition
    if len(conditions) != 2:
        err_msg = "Time since state should have 2 conditions!"
        raise Exception(err_msg)
    
    time_in_secs = None
    comparator = None
    trigger_clause = None
    for cond in conditions:
        if cond.par.type == "duration":
            time_clause = json.loads(cond.val.replace('\'', '\"'))
            time_in_secs = time_to_int(time_clause)
            comparator = cond.comp
        elif cond.par.type == "meta":
            trigger_clause = json.loads(cond.val.replace('\'', '\"'))
    
    trigger_parameters = trigger_clause['parameters']
    trigger_parameterVals = trigger_clause['parameterVals']
    trigger_cap_id = trigger_clause['capability']['id']
    trigger_dev_id = trigger_clause['device']['id']

    if len(trigger_parameters) != 1 or len(trigger_parameterVals) != 1:
        err_msg = "Trigger in history channel should only have one parameter"
        m.ErrorLog.objects.create(err=err_msg)
        raise Exception(err_msg)
    
    trigger_parameter = trigger_parameters[0]
    trigger_parameterVal = trigger_parameterVals[0]

    current_time_utc = datetime.datetime.utcnow()
    start_time = current_time_utc - datetime.timedelta(seconds=time_in_secs)

    # check current status
    state = m.State.objects.get(cap__id=trigger_cap_id, dev__id=trigger_dev_id)
    current_parval = m.ParVal.objects.get(par__id=trigger_parameter['id'], state=state)

    if not test_cond_dict(trigger_parameter, trigger_parameterVal, current_parval.val):
        return False
    
    # check history
    # if comp == '>', state should always be true from start_time to current_time_utc
    # if comp == '<', state should once be false from start_time to current_time_utc, but finally is true
    post_state_logs = m.StateLog.objects.filter(dev__id=trigger_clause['device']['id'], 
                                                cap__id=trigger_clause['capability']['id'], 
                                                timestamp__gte=start_time, 
                                                status__in=(m.StateLog.CURRENT, m.StateLog.HAPPENED))
    
    if_state_switch = False
    for state_log in post_state_logs:
        sl_param = state_log.param
        sl_value = state_log.value    
        for cond_par, cond_val in zip(trigger_parameters, trigger_parameterVals):
            if test_cond_dict(cond_par, cond_val, sl_value):
                # such thing will neglect the condition when comp == '>'
                if_state_switch = True
                break
    
    if if_state_switch == (comparator == '<'):
        return True
    else:
        return False


def check_if_rule_triggered(cap, dev, pvs, esrule):
    pvs_dict = dict(pvs)

    # check if Etrigger is met
    if cap != esrule.Etrigger.cap or dev != esrule.Etrigger.dev:
        return False
    conditions = m.Condition.objects.filter(trigger=esrule.Etrigger)
    for cond in conditions:
        val = pvs_dict[cond.par]
        if not test_cond(cond, val):
            return False
    
    # check if Striggers are met
    return check_s_triggers(esrule.Striggers.all())


def schedule_history_triggered(log_obj: m.StateLog):
    '''
    should be called by update_log, to check if history trigger activated.
    '''
    history_cap = capmap.lookup('Time Since State', 'vd')
    assert len(history_cap) == 1
    history_cap = history_cap[0]
    dev_obj = log_obj.dev
    loc_obj = dev_obj.location
    st_installed_app_id = loc_obj.st_installed_app_id
    history_esrules = m.ESRule.objects.filter(Etrigger__cap=history_cap, st_installed_app_id=st_installed_app_id)
    # log_obj .cap  .dev  .param   .value   .valuetype

    schedule_time_list = list()
    for history_rule in history_esrules:
        conds = m.Condition.objects.filter(trigger=history_rule.Etrigger)
        assert len(conds) == 2 # Etrigger should have only one cond.
        history_trigger_pvs = dict()
        
        for cond in conds:
            history_trigger_pvs[cond.par.name] = cond.val

        # trigger_pvs should be this now:
        # {"trigger": "...<trigger in json>...", "time": <duration value> }
        event_trigger_obj = json.loads(history_trigger_pvs['trigger'].replace('\'', '\"'))  # ugly fix of json format
        event_trigger_parameters = event_trigger_obj['parameters']
        event_trigger_parameterVals = event_trigger_obj['parameterVals']
        event_trigger_cap_id = event_trigger_obj['capability']['id']
        event_trigger_dev_id = event_trigger_obj['device']['id']
        if log_obj.cap.id != event_trigger_cap_id:
            continue # this rule is not what we want
        if log_obj.dev.id != event_trigger_dev_id:
            continue

        current_rule_match = True
        # param = log_obj.param
        value = log_obj.value
        for cond_par, cond_val in zip(event_trigger_parameters, event_trigger_parameterVals):
            if not test_cond_dict(cond_par, cond_val, value):
                current_rule_match = False
                break
        
        if current_rule_match:
            time_clause = json.loads(history_trigger_pvs['time'].replace('\'', '\"'))
            count_down_time = time_to_int(time_clause) # translate this into seconds
            if count_down_time not in schedule_time_list:
                schedule_time_list.append(count_down_time)

    # schedule time events
    for count_down_time in schedule_time_list:
        print("# [HISTORY] schedule_history_triggered schedule:" + str((log_obj.id, count_down_time)))
        tasks.triggering_history_event.apply_async((log_obj.id, count_down_time), countdown=count_down_time)


def st_process_update(kwargs):
    '''
    Update states and find out what action should be triggered.\n
    Input:
        - kwargs: a dict of the new event occurred
        {
            "st_installed_app_id": the id of the installed SmartThings app instance,
            "capid": capability id in this project,
            "deviceid": device id in this project,
            "values": { <st_param_id>: <parval_value>, ... }
        }
    Output:
        - json_resp: a dict of actions that should be triggered
        {
            "actions": [{
                    "capability": "<commandname>",
                    "devid": "<device proj id>",
                    "values": { "<st_param_id>": "<parval_value>", ...}
                }, ...],
            "errors": [{"msg": "<error_details>"}, ...]
        }
    Note: Only devices that are not fake will be returned
    '''
    json_resp = {"actions": [], "errors": []}

    cap = capmap.lookup(kwargs['capid'],'st') 
    if len(cap) > 0:
        cap = cap[0] # currently let's assume there's only one capability...
    else:
        m.ErrorLog.objects.create(err="st_process_update > capmap: Cannot find the corresponding capability: " + kwargs['capid'])
        return json_resp
    try:
        dev = m.Device.objects.get(id=kwargs['deviceid'])
        pvdict = kwargs['values'] #{st_param_id : value}
        if kwargs['capid'] == 'colorControl':
            hue = pvdict['hue'] if 'hue' in pvdict else '*'
            saturation = pvdict['saturation'] if 'saturation' in pvdict else '*'
            color_val = '%s,%s' % (hue, saturation)
            pvdict = {'color': color_val}
        pvs = [(m.Parameter.objects.get(sysname=pv_id), stval_to_val(m.Parameter.objects.get(sysname=pv_id), pvdict[pv_id])) for pv_id in pvdict]
    except m.Device.DoesNotExist:
        err_detail = "Cannot find the device: {}.".format(kwargs['deviceid'])
        json_resp["errors"].append(get_error_msg("st_process_update", err_detail, status=404))
        return json_resp
    except m.Parameter.DoesNotExist:
        err_detail = "Cannot find a parameter that's corresponding to '{}'.".format(pv_id)
        json_resp["errors"].append(get_error_msg("st_process_update", err_detail, status=500))
        return json_resp

    for param, val in pvs:
        # update the related par-val pair (trigger)
        pv = update_state(cap,dev,param,val)
        # assume that superifttt will only be installed once per home
        update_log(cap, dev, [pv])

    # ------------------------------------------------------------------------
    # --------- below: consider using check_actions_and_get_json -------------
    st_installed_app_id = kwargs['st_installed_app_id']
    json_resp = check_actions_and_get_json(st_installed_app_id, cap, dev, pvs)
    return json_resp
    # -------- before: consider using check_actions_and_get_json -------------
    # ------------------------------------------------------------------------


# def get_state_parval(cap, dev, param) (in branch production-dev-timer. useless now.)


def vd_process_update(kwargs):
    '''
    Update states of virtual devices and find out what action should be triggered.\n
    Input:
        - kwargs: a dict of the new event occurred
        {
            "st_installed_app_id": the id of the installed SmartThings app instance,
            "capid": capability id in this project,
            "deviceid": device id in this project,
            "values": { <st_param_id>: <parval_value>, ... }
        }
    Output:
        - json_resp: a dict of actions that should be triggered
        {
            "actions": [{
                    "capability": "<commandname>",
                    "devid": "<device proj id>",
                    "values": { "<st_param_id>": "<parval_value>", ...}
                }, ...],
            "errors": [{"msg": "<error_details>"}, ...]
        }
    '''
    json_resp = {"actions": [], "errors": []}

    cap = capmap.lookup(kwargs['capid'],'vd') 
    if len(cap) > 0:
        cap = cap[0] # currently let's assume there's only one capability...
    else:
        m.ErrorLog.objects.create(err="vd_process_update > capmap: Cannot find the corresponding capability." + kwargs['capid'])
        return json_resp
    try:
        dev = m.Device.objects.get(id=kwargs['deviceid'])
        pvdict = kwargs['values'] #{st_param_id : value}
        pvs = [(m.Parameter.objects.get(name=pv_id, cap=cap), pvdict[pv_id]) for pv_id in pvdict]
    except m.Device.DoesNotExist:
        err_detail = "Cannot find the device: {}.".format(kwargs['deviceid'])
        json_resp["errors"].append(get_error_msg("vd_process_update", err_detail, status=404))
        return json_resp
    except m.Parameter.DoesNotExist:
        err_detail = "Cannot find a parameter that's corresponding to '{}'.".format(pv_id)
        json_resp["errors"].append(get_error_msg("vd_process_update", err_detail, status=500))
        return json_resp

    for param, val in pvs:
        # update the related par-val pair (trigger)
        pv = update_state(cap,dev,param,val)
        # assume that superifttt will only be installed once per home
        update_log(cap, dev, [pv])

    # ------------------------------------------------------------------------
    # --------- below: consider using check_actions_and_get_json -------------
    st_installed_app_id = kwargs['st_installed_app_id']
    json_resp = check_actions_and_get_json(st_installed_app_id, cap, dev, pvs)

    if json_resp['actions']:
        st_util.execute_commands_on_core_vd(dev.location, json_resp)
    return json_resp
    # -------- before: consider using check_actions_and_get_json -------------
    # ------------------------------------------------------------------------


def vd_process_update_history(log: m.StateLog, delay_seconds: int):
    # for history events, just check if any rules are triggered. no need to update the state log/state
    device = log.dev
    location = device.location

    json_resp = check_history_actions_and_get_json(log, delay_seconds)
    
    if json_resp['actions']:
        st_util.execute_commands_on_core_vd(location, json_resp)
    return json_resp


def apply_esrule_action(esrule: m.ESRule):
    # trigger the action
    action = esrule.action # an action
    # exclude devices that are not real
    if action.dev.dev_type == m.Device.FAKEDEV:
        return None

    action_dict = {
        'capability' : capmap.reverse_lookup(action.cap, 'st').name,
        'devid' : action.dev.id,
        'values': {}
    }
    st_cap = capmap.reverse_lookup(action.cap, "st")

    action_pvs = {}
    # find the corresponding Par-Val pair for this action
    action_conditions = m.ActionCondition.objects.filter(action=action)
    for ac in action_conditions:
        action_pvs[ac.par.sysname] = val_to_stval(ac.par, ac.val)
        # create a new TO_OCCUR log and mark it as issued by superifttt
        m.StateLog.objects.create(
            status = m.StateLog.TO_OCCUR,
            cap = action.cap,
            dev = action.dev,
            param = ac.par,
            value = ac.val,
            is_superifttt = True
        )
    
    action_dict = st_util.st_action_handler[st_cap.command_type](action_pvs)
    action_dict = {**action_dict, **{"capability": st_cap.name, "devid": action.dev.id}}
    return action_dict


def check_actions_and_get_json(st_installed_app_id, cap, dev, pvs, old_pvs=None):
    '''
    add **olf_pvs**. in case that some Etrigger need last time information.
    '''
    json_resp = {"actions": [], "errors": []}
    rule_queryset = m.ESRule.objects.filter(st_installed_app_id=st_installed_app_id)
    for esrule in rule_queryset:
        if check_if_rule_triggered(cap, dev, pvs, esrule):
            # trigger the action
            action_dict = apply_esrule_action(esrule)
            if action_dict:
                json_resp['actions'].append(action_dict)
        
    return json_resp


def check_history_actions_and_get_json(state_log: m.StateLog, delay_seconds: int):
    # when events corresponding to history channel happens, check whether any rules triggered
    history_cap = capmap.lookup('Time Since State', 'vd')[0]  # should be only one history cap
    device = state_log.dev
    location = device.location
    st_installed_app_id = location.st_installed_app_id

    json_resp = {"actions": [], "errors": []}

    history_esrules = m.ESRule.objects.filter(Etrigger__cap=history_cap, st_installed_app_id=st_installed_app_id)
    for history_rule in history_esrules:
        conds = m.Condition.objects.filter(trigger=history_rule.Etrigger)
        assert len(conds) == 2 # Etrigger should have only one cond.
        history_trigger_pvs = dict()
        
        for cond in conds:
            history_trigger_pvs[cond.par.name] = cond.val

        event_trigger_obj = json.loads(history_trigger_pvs['trigger'].replace('\'', '\"'))  # ugly fix of json format
        event_trigger_time = json.loads(history_trigger_pvs['time'].replace('\'', '\"'))
        event_trigger_time = time_to_int(event_trigger_time)
        event_trigger_parameters = event_trigger_obj['parameters']
        event_trigger_parameterVals = event_trigger_obj['parameterVals']
        event_trigger_cap_id = event_trigger_obj['capability']['id']
        event_trigger_dev_id = event_trigger_obj['device']['id']

        if state_log.cap.id != event_trigger_cap_id:
            continue # this rule is not what we want
        if state_log.dev.id != event_trigger_dev_id:
            continue
        if event_trigger_time != delay_seconds:
            continue
        
        rule_triggered = True
        # First check if event trigger is triggered
        post_state_logs = m.StateLog.objects.filter(dev=device, cap__id=state_log.cap.id, 
                                                    timestamp__gte=state_log.timestamp, 
                                                    status__in=(m.StateLog.CURRENT, m.StateLog.HAPPENED))
        for post_sl in post_state_logs:
            post_sl_param = post_sl.param
            post_sl_value = post_sl.value    
            for cond_par, cond_val in zip(event_trigger_parameters, event_trigger_parameterVals):
                if not test_cond_dict(cond_par, cond_val, post_sl_value):
                    rule_triggered = False
                    break
            
            if not rule_triggered:
                break
        
        # Next check if state triggers are triggered
        if rule_triggered:
             rule_triggered = check_s_triggers(history_rule.Striggers.all())
        
        if rule_triggered:
            # trigger the rule
            action_dict = apply_esrule_action(history_rule)
            if action_dict:
                json_resp['actions'].append(action_dict)
    
    return json_resp


###############################################################################
## [RC] RULE CREATION
###############################################################################

def get_or_make_state(cap, dev, value, is_action=False):
    '''
    Get the state of a cap/dev pair, or create one if none exists
    '''
    state, created = m.State.objects.get_or_create(cap=cap,dev=dev,action=is_action)
    state.text = "{}".format(value)
    state.save()
    return state

# @TO_DELETE: Potentially dead code
# def update_pv(state,par_id,val):
#     try:
#         pv = m.ParVal.objects.get(state=state,par_id=par_id)
#         pv.val = val
#         pv.save()
#     except m.ParVal.DoesNotExist:
#         pv = m.ParVal(state=state,par_id=par_id,val=val)
#         pv.save()



###############################################################################
## [SPC] SAFETY PROPERTY CREATION
###############################################################################

def time_to_int(time):
    return time['seconds'] + time['minutes']*60 + time['hours']*3600

def int_to_time(secs):
    time = {}
    time['hours'] = secs // 3600
    time['minutes'] = (secs // 60) % 60
    time['seconds'] = secs % 60
    return time

def clause_to_trigger(clause):
    if 'channel' in clause and 'id' in clause['channel']:
        t = m.Trigger(chan=m.Channel.objects.get(id=clause['channel']['id']),
                    dev=m.Device.objects.get(id=clause['device']['id']),
                    cap=m.Capability.objects.get(id=clause['capability']['id']),
                    pos=clause['id'],
                    text=clause['text'])
    else:
        t = m.Trigger(dev=m.Device.objects.get(id=clause['device']['id']),
                    cap=m.Capability.objects.get(id=clause['capability']['id']),
                    pos=clause['id'],
                    text=clause['text'])
    t.save()

    try:
        pars = clause['parameters']
        vals = clause['parameterVals']
        for par,val in zip(pars,vals):
            cond = m.Condition(par=m.Parameter.objects.get(id=par['id']),
                               val=val['value'],
                               comp=val['comparator'],
                               trigger=t)
            cond.save()
    except KeyError:
        pass

    return t


def clause_to_action(clause):
    if 'channel' in clause and 'id' in clause['channel']:
        a = m.Action(chan=m.Channel.objects.get(id=clause['channel']['id']),
                     dev=m.Device.objects.get(id=clause['device']['id']),
                     cap=m.Capability.objects.get(id=clause['capability']['id']),
                     text=clause['text'])
    else:
        a = m.Action(dev=m.Device.objects.get(id=clause['device']['id']),
                     cap=m.Capability.objects.get(id=clause['capability']['id']),
                     text=clause['text'])
    a.save()

    try:
        pars = clause['parameters']
        vals = clause['parameterVals']
        for par,val in zip(pars,vals):
            cond = m.ActionCondition(par=m.Parameter.objects.get(id=par['id']),
                                     val=val['value'],
                                     action=a)
            cond.save()
    except KeyError:
        pass

    return a


def trigger_to_clause(trigger,is_event):
    chan = {'id' : trigger.chan.id, 'name' : trigger.chan.name, 'icon' : trigger.chan.icon} if trigger.chan else {}
    c = {'channel' : chan,
         'device' : {'id' : trigger.dev.id,
                     'name' : trigger.dev.name,
                     'label': trigger.dev.label},
         'capability' : {'id' : trigger.cap.id,
                         'name' : trigger.cap.name,
                         'label' : (trigger.cap.eventlabel if is_event else trigger.cap.statelabel)},
         'text' : trigger.text,
         'id' : trigger.pos}
    conds = m.Condition.objects.filter(trigger=trigger).order_by('id')
    if conds != []:
        c['parameters'] = []
        c['parameterVals'] = []

        for cond in conds:
            if cond.par.type == 'bin':
                values = [cond.par.binparam.tval, cond.par.binparam.fval]
            else:
                values = []
            val = json.loads(cond.val.replace('\'', '\"')) if cond.par.type in ('meta', 'duration') else cond.val
            c['parameters'].append({'id' : cond.par.id,
                                    'name' : cond.par.name,
                                    'type' : cond.par.type,
                                    'values': values})
            c['parameterVals'].append({'comparator' : cond.comp,
                                       'value' : val})
    return c


def action_to_clause(action):
    chan = {'id' : action.chan.id, 'name' : action.chan.name, 'icon' : action.chan.icon} if action.chan else {}
    c = {'channel' : chan,
         'device' : {'id' : action.dev.id,
                     'name' : action.dev.name,
                     'label': action.dev.label},
         'capability' : {'id' : action.cap.id,
                         'name' : action.cap.name,
                         'label' : action.cap.commandlabel},
         'text' : action.text}
    action_conds = m.ActionCondition.objects.filter(action=action).order_by('id')
    if action_conds != []:
        c['parameters'] = []
        c['parameterVals'] = []

        for cond in action_conds:
            if cond.par.type == 'bin':
                values = [cond.par.binparam.tval, cond.par.binparam.fval]
            else:
                values = []
            val = json.loads(cond.val.replace('\'', '\"')) if cond.par.type in ('meta', 'duration') else cond.val
            c['parameters'].append({'id' : cond.par.id,
                                    'name' : cond.par.name,
                                    'type' : cond.par.type,
                                    'values': values})
            c['parameterVals'].append({'comparator' : '=',
                                       'value' : val})
    return c


def state_to_clause(state):
    chan = {'id' : state.chan.id, 'name' : state.chan.name, 'icon' : state.chan.icon} if state.chan else {}
    c = {'channel' : chan,
         'device' : {'id' : state.dev.id,
                     'name' : state.dev.name,
                     'label': state.dev.label},
         'capability' : {'id' : state.cap.id,
                         'name' : state.cap.name,
                         'label' : state.cap.commandlabel},
         'text' : state.text}

    # pvs = m.ParVal.objects.filter(state=state).order_by('id')
    # if pvs != []:
    #     c['parameters'] = []
    #     c['parameterVals'] = []
    #
    #     for pv in pvs:
    #         c['parameters'].append({'id' : pv.par.id,
    #                                 'name' : pv.par.name,
    #                                 'type' : pv.par.type})
    #         c['parameterVals'].append({'comparator' : '=',
    #                                    'value' : pv.val})
    # escapeFunc = lambda x:re.sub(r'([\.\\\+\*\?\[\^\]\$\(\)\{\}\!\<\>\|\:\-])', r'\\\1', x)
    cap = m.Capability.objects.get(id=state.cap.id)
    par_list = m.Parameter.objects.filter(cap_id=cap.id)
    par_dict = dict()
    for par in par_list:
        values = []
        par_c = dict()
        par_c['id'] = par.id
        par_c['type'] = par.type
        par_c['name'] = par.name
        if par.type == 'bin':
            bin_par = m.BinParam.objects.get(id=par.id)
            par_c['value_list'] = [bin_par.fval, bin_par.tval]
            values = [bin_par.tval, bin_par.fval]
            t_template = r'\{%s/T\|(?P<value>[\w &\-]+)\}' % par.name
            f_template = r'\{%s/F\|(?P<value>[\w &\-]+)\}' % par.name
            t_val = re.search(t_template, cap.commandlabel)
            f_val = re.search(f_template, cap.commandlabel)
            if t_val and f_val:
                par_c['value_list_in_statement'] = [f_val.group('value'), t_val.group('value')]
            else:
                par_c['value_list_in_statement'] = par_c['value_list'] = [bin_par.fval, bin_par.tval]
        elif par.type == 'range':
            par_c['value_list'] = []
        elif par.type == 'set':
            par_c['value_list'] = [opt.value for opt in m.SetParamOpt.objects.filter(param_id=par.id)]
        elif par.type == 'color':
            par_c['value_list'] = [webcolors.CSS3_NAMES_TO_HEX.keys()]
        else:
            raise Exception('var type %s not supported' % par.type)
        par_c['values'] = values

        par_dict[par.name] = par_c

    if state.dev.label is not None and state.dev.label:
        template_text = re.sub(r'\{DEVICE\}', state.dev.label, cap.commandlabel)
    else:
        template_text = re.sub(r'\{DEVICE\}', state.dev.name, cap.commandlabel)
    template_text = re.sub(r'\{(\w+)/(T|F)\|[\w &\-]+\}\{\1/(T|F)\|[\w &\-]+\}', r'(?P<\1>[\w &\-]+)', template_text)
    template_text = re.sub(r'\{(\w+)\}', r'(?P<\1>[\w &\-]+)', template_text)
    re_mat = re.match(template_text, state.text)

    for par, par_c in par_dict.items():
        par_dict[par_c['name']]['value'] = re_mat.group(par_c['name'])

    c['parameters'] = [{'type': par_c['type'], 'name': par_c['name'], 'id': par_c['id'], 'values': par_c['values']}
                       for par, par_c in sorted(par_dict.items())]
    c['parameterVals'] = list()
    for par, par_c in sorted(par_dict.items()):
        if par_c['type'] == 'bin':
            value = par_c['value_list'][par_c['value_list_in_statement'].index(par_c['value'])]
        else:
            value = par_c['value']
        c['parameterVals'].append({'comparator': '=', 'value': value})

    return c

def display_trigger(trigger):
    return {'channel' : {'icon' : trigger.chan.icon}, 'text' : trigger.text}



###############################################################################
## [SLM] STATE & LOG MANAGEMENT
###############################################################################

# @TO_DELETE: Potentially dead code
# create and save new StateLog entry in database
# def log_state(newstate):
#     pvs = m.ParVal.objects.filter(state=newstate)
#     for pv in pvs:
#         try:
#             oldlog = m.StateLog.objects.get(
#                     is_current=True,
#                     cap=newstate.cap,
#                     dev=newstate.dev,
#                     param=pv.par
#                     )
#             # if no update, continue
#             if oldlog.val == pv.val:
#                 continue

#             oldlog.is_current=False
#             oldlog.save()
#         except m.StateLog.DoesNotExist:
#             pass

#         newlog = m.StateLog(
#                 is_current=True,
#                 cap=newstate.cap,
#                 dev=newstate.dev,
#                 param=pv.par,
#                 val=pv.val
#                 )
#         newlog.save()

# get current state of dev/cap pair
def current_state(dev,cap):
    try:
        curstate = m.State.objects.get(cap=cap,dev=dev,action=False)
        return curstate
    except m.State.DoesNotExist:
        return None

# get value of state of dev/cap pair at a given time
def historical_state(dev,cap,targettime):
    state = m.State.objects.get(dev=dev,cap=cap,action=False)
    out = []
    for pv in m.ParVal.objects.filter(state=state):
        try:
            logs = m.StateLog.objects.filter(
                    status__in=[m.StateLog.HAPPENED, m.StateLog.CURRENT],
                    cap=state.cap,
                    dev=state.dev,
                    param=pv.par,
                    timestamp__lte=targettime
                )
            if logs:
                lastlog = max(logs,key=lambda log : log.timestamp)
                out.append((lastlog.param,lastlog.value))
            else:
                out.append((pv.par.id,"N/A"))
        except m.StateLog.DoesNotExist:
            out.append((pv.par.id,"N/A"))

    return out

# get record of all logged changes to a dev/cap pair
def device_cap_history(dev,cap):
    qset = m.StateLog.objects.filter(status=m.StateLog.HAPPENED,dev=dev,cap=cap)
    states = []
    for entry in sorted(qset,key=lambda entry : entry.timestamp,reverse=True):
        states.append((entry.timestamp.ctime(),entry.param.id,entry.value))
    return states


###############################################################################
## [DM] DEVICE MANAGEMENT
###############################################################################

def prep_command(action, group):
    '''
    Preparing the commands that will be sent to IoTCore

    Input:

    Output:
    '''
    if group == 'st':
        cap = action.cap
        pvs = m.ActionParVal.objects.filter(state=action)
        pars = [pv.par for pv in pvs]
        enumcommands = filter(lambda x: pv.par.is_command,pvs) #this shouldn't return >1
        if enumcommands:
            commname = enumcommands[0].par.sysname
            commvals = []
        else:
            commname = None #cap.commandname
            commvals = [{'name' : pv.par.name, 'value' : pv.val} for pv in pvs]
        return {'command'   : {'name' : commname,
                               'vals' : commvals}}
    else:
        return None

def send_command(command, group):
    if group == 'st':
        signed_command = {'signature' : 'superifttt',
                          'command' : command['command']}


def get_param_vals(param):
    if param.type == 'bin':
        param_val_list =  [param.binparam.tval, param.binparam.fval]
    elif param.type == 'set':
        options = m.SetParamOpt.objects.filter(param=param)
        param_val_list = [opt.value for opt in options]
    else:
        # TODO: should try to handle range/color
        # maybe we could use kmeans to cluster the values based on the past events?
        param_val_list = []
    return param_val_list


def get_param_vals_range(dev, cap, param):
    range_seps = m.RangeCounter.objects.filter(dev=dev, cap=cap, param=param, count__gt=0)
    return [rs.representative for rs in range_seps]


def get_param_vals_color(dev, cap, param):
    color_counts = m.ColorCounter.objects.filter(dev=dev, cap=cap, param=param, count__gt=0)
    return [cc.name for cc in color_counts]


def get_dev_commands(dev, trace, template_dict, boolean_map, orig_tap_list, plain_revert=False):
    """
    return a list of tuple (cap, param, value, count)
    """
    result = list()
    for cap in dev.caps.all():
        if cap.name == 'Color Temperature':
            continue
        if cap.writeable:
            # this capability has commands
            # should iterate through all possible commands
            params = list(m.Parameter.objects.filter(cap=cap))
            if len(params) == 1:
                param = params[0]
                if param.type in ('set', 'bin'):
                    param_val_list = get_param_vals(param)
                elif param.type == 'range':
                    param_val_list = get_param_vals_range(dev, cap, param)
                elif param.type == 'color':
                    param_val_list = get_param_vals_color(dev, cap, param)
                else:
                    param_val_list = []
                for val in param_val_list:
                    entry = {
                        'device_name': dev.name if dev.dev_type == 'v' else dev.label,
                        'capability': cap.name,
                        'attribute': param.name,
                        'current_value': val
                    }
                    dev_name, cap_name, value = translateCapability(entry, template_dict=template_dict, boolean_map=boolean_map)
                    if type(value) == int or type(value) == float:
                        value = str(value)
                    elif type(value) == bool:
                        value = 'true' if value else 'false'
                    else:
                        value = value
                    target_action = dev_name + '.' + cap_name + '=' + str(value)
                    tap_list = [tap for tap in orig_tap_list if tap.action == target_action]
                    episode_list = extractEpisodes(trace, target_action, post_time_span=datetime.timedelta(minutes=2))
                    if not plain_revert:
                        _, revert_list = extractTriggerCases(trace, target_action, tap_list=tap_list)
                    else:
                        revert_time_list = extractRevertCases(trace, target_action)
                    count = len(episode_list)
                    covered = 0
                    for episode in episode_list:
                        if checkIfEpisodeCovered(episode, tap_list, target_action):
                            covered += 1
                    reverted = sum(revert_list) if not plain_revert else len(revert_time_list)
                    result.append((cap, param, val, count, covered, reverted))
            else:
                pass
            
    return result


#######################
# Permission Checking #
#######################

def is_error(status_code):
    return status_code >=400

def has_access_to_location(user, loc_id):
    if user.is_superuser:
        return True
    else:
        return m.Location.objects.filter(pk=loc_id, users=user).exists()

def check_access_to_location(request, loc_id: int):
    '''
    Given a request (which contains the user) and a location id, check:
        1. if the user is logged in
        2. if the location exists
        3. if the user has access to the location
    Input:
        request: Django's request object
        loc_id:  the id of the location、
    Output:
        err_json: (dict) {"err": "xxxxx"}, defaults to {}, which means no error detected
        status:   (int) the status number, defaults to 200, which means no error detected
    '''
    err_msg = {}
    status = 200
    if not request.user.is_authenticated:
        err_msg["err"] = "Please log in!"
        status = 401
    if not m.Location.objects.filter(pk=loc_id).exists():
        err_msg["err"] = "The requested location doesn't exist."
        status = 404
    if not has_access_to_location(request.user, loc_id):
        err_msg["err"] = "You don't have access to this location."
        status = 403
    
    return err_msg, status


############
# Recorder #
############
def record_request(req_dict, typ, location):
    req_str = json.dumps(req_dict)
    return m.Record.objects.create(request=req_str, response="", typ=typ, location=location)


def record_response(res_dict, typ, location):
    res_str = json.dumps(res_dict)
    m.Record.objects.create(request="", response=res_str, typ=typ, location=location)


def get_location_from_user(user):
    locations = m.Location.objects.all()
    for loc in locations:
        if user in list(loc.users.all()):
            return loc
    return None


##########
# Helper #
##########

def get_error_msg(func_name, err, status=500):
    err_msg = "{}: {}\n{}".format(func_name, err, traceback.format_exc())
    m.ErrorLog.objects.create(err=err_msg)
    return {"msg": "{}".format(err)}

def get_now():
    return timezone.now() if settings.USE_TZ else datetime.datetime.now()