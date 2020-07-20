from django.http import HttpResponse, JsonResponse
from . import models as m
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
from django.db.models import Q
import datetime, random
import operator as op
from django.views.decorators.csrf import csrf_exempt, ensure_csrf_cookie
import json
import re
from . import capmap
from backend.util import *
import backend.st_util as st_util

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

def fe_get_user(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    u = get_or_make_user(kwargs['code'],kwargs['mode'])
    json_resp = {'userid' : u.id}
    return JsonResponse(json_resp)

# FRONTEND VIEW
@csrf_exempt
def fe_all_rules(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    json_resp = {'rules' : []}
    
    try:
        user = m.User_ICSE19.objects.get(id=kwargs['userid'])
    except KeyError:
        user = get_or_make_user(kwargs['code'],'rules')
        json_resp['userid'] = user.id

    task = kwargs['taskid']

    for rule in m.Rule.objects.filter(owner=user,task=task).order_by('id'):
        if rule.type == 'es':
            ifclause = []
            t = rule.esrule.Etrigger
            ifclause.append({'channel' : {'icon' : t.chan.icon},
                             'text' : t.text})
            for t in sorted(rule.esrule.Striggers.all(),key=lambda x: x.pos):
                ifclause.append({'channel' : {'icon' : t.chan.icon},
                                 'text' : t.text})
            a = rule.esrule.action
            thenclause = [{'channel' : {'icon' : a.chan.icon if not (a.chan == None) else ''},
                           'text' : a.text}]

            json_resp['rules'].append({'id' : rule.id,
                                       'ifClause' : ifclause,
                                       'thenClause' : thenclause,
                                       'temporality' : 'event-state'})

    return JsonResponse(json_resp)

@csrf_exempt
def fe_get_full_rule(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    json_resp = {}
    rule = m.Rule.objects.get(id=kwargs['ruleid'])

    if rule.type == 'es':
        rule = rule.esrule
        ifclause = []
        t = rule.Etrigger
        ifclause.append(trigger_to_clause(t,True))
        for t in sorted(rule.Striggers.all(),key=lambda x: x.pos):
            ifclause.append(trigger_to_clause(t,False))

        a = rule.action
        thenclause = state_to_clause(a)

        json_resp['rule'] = {'id' : rule.id,
                             'ifClause' : ifclause,
                             'thenClause' : [thenclause],
                             'temporality' : 'event-state'}

    return JsonResponse(json_resp)

### @TO_DELETE: Potentially dead code
# combined call of all_devs and all_chans
# NOT IN USE
# def fe_all_devs_and_chans(request):
#     kwargs = request.POST
#     user = m.User_ICSE19.objects.get(id=kwargs['userid'])
#     json_resp = {}
#     json_resp['devs'] = all_devs(user)
#     json_resp['chans'] = all_chans(user)
#     return JsonResponse(json_resp)

# FRONTEND VIEW
# let frontend get csrf cookie
@ensure_csrf_cookie
def fe_get_cookie(request):
    return JsonResponse({})

# FRONTEND VIEW
# gets all of a user's channels
@csrf_exempt
def fe_all_chans(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    user = m.User_ICSE19.objects.get(id=kwargs['userid'])
    json_resp = valid_chans(user,kwargs['is_trigger'])
    return JsonResponse(json_resp)

# FRONTEND VIEW
# return id:name dict of all devices with a given channel
@csrf_exempt
def fe_devs_with_chan(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    devs = m.Device.objects.filter(Q(users__id__contains=kwargs['userid']) | Q(public=True),
                                   chans__id=kwargs['channelid']).distinct().order_by('name')
    chan = m.Channel.objects.get(id=kwargs['channelid'])
    devs = filter(lambda x : dev_has_valid_cap(x,chan,kwargs['is_trigger']),devs)
    json_resp = {'devs' : []}
    for dev in devs:
        json_resp['devs'].append({'id' : dev.id,'name' : dev.name})
    return JsonResponse(json_resp)

# return id:name dict of all channels with a given device
# NOT IN USE
def fe_chans_with_dev(request,**kwargs):
    chans = m.Channel.objects.filter(capability__device__id=kwargs['deviceid'])
    json_resp = {}
    for chan in chans:
        json_resp[chan.id] = chan.name

    return JsonResponse(json_resp)

### @TO_DELETE: Potentially dead code
# return id:name dict of all capabilities for a given dev/chan pair
# NOT IN USE
# def fe_get_all_caps(request,**kwargs):
#     caps = m.Capability.objects.filter(channels__id=kwargs['channelid'],device__id=kwargs['deviceid'])
#     json_resp = {}
#     for cap in caps:
#         json_resp[cap.id] = cap.name
#     return JsonResponse({'caps' : json_resp})

# FRONTEND VIEW
# return id:name dict of contextually valid capabilities for a given dev/chan pair
@csrf_exempt
def fe_get_valid_caps(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    caps = m.Capability.objects.filter(channels__id=kwargs['channelid'],device__id=kwargs['deviceid']).order_by('name')

    json_resp = {'caps' : []}
    for id,name,label in filtermap_caps(caps,kwargs['is_trigger'],kwargs['is_event']):
        json_resp['caps'].append({'id' : id, 'name' : name, 'label' : label})
    return JsonResponse(json_resp)

# return id:(type,val constraints) dict of parameters for a given cap
@csrf_exempt
def fe_get_params(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    cap = m.Capability.objects.get(id=kwargs['capid'])
    json_resp = {'params' : []}
    for param in m.Parameter.objects.filter(cap_id=kwargs['capid']).order_by('id'):
        if param.type == 'set':
            json_resp['params'].append({'id' : param.id,
                                        'name' : param.name,
                                        'type' : "set",
                                        'values' : [opt.value for opt in m.SetParamOpt.objects.filter(param_id=param.id)]})
        elif param.type == 'range':
            json_resp['params'].append({'id' : param.id,
                                        'name' : param.name,
                                        'type' : 'range',
                                        'values' : [param.rangeparam.min,param.rangeparam.max,param.rangeparam.interval]})
        elif param.type == 'bin':
            json_resp['params'].append({'id' : param.id,
                                        'name' : param.name,
                                        'type' : 'bin',
                                        'values' : [param.binparam.tval,param.binparam.fval]})
        elif param.type == 'input':
            json_resp['params'].append({'id' : param.id,
                                        'name' : param.name,
                                        'type' : 'input',
                                        'values' : [param.inputparam.inputtype]})
        elif param.type == 'time':
            json_resp['params'].append({'id' : param.id,
                                        'name' : param.name,
                                        'type' : 'time',
                                        'values' : [param.timeparam.mode]})
        elif param.type == 'duration':
            json_resp['params'].append({'id' : param.id,
                                        'name' : param.name,
                                        'type' : 'duration',
                                        'values' : [param.durationparam.maxhours,param.durationparam.maxmins,param.durationparam.maxsecs]})
        elif param.type == 'color':
            json_resp['params'].append({'id' : param.id,
                                        'name' : param.name,
                                        'type' : 'color',
                                        'values' : [param.colorparam.mode]})
        elif param.type == 'meta':
            json_resp['params'].append({'id' : param.id,
                                        'name' : param.name,
                                        'type' : 'meta',
                                        'values' : [param.metaparam.is_event]})
    return JsonResponse(json_resp)



###############################################################################
## [RC] RULE CREATION
###############################################################################

# create (OR EDIT) Event State Rule
@csrf_exempt
def fe_create_esrule(request,forcecreate=False):
    kwargs = json.loads(request.body.decode('utf-8'))
    ruleargs = kwargs['rule']
    ifclause = ruleargs['ifClause']
    
    event = ifclause[0]

    e_trig = clause_to_trigger(event)

    action = ruleargs['thenClause'].pop()
    a_state = m.State(cap=m.Capability.objects.get(id=action['capability']['id']),
                      dev=m.Device.objects.get(id=action['device']['id']),
                      chan=m.Channel.objects.get(id=action['channel']['id']),
                      action=True,
                      text=action['text'])
    a_state.save()

    # add ActionParVal
    a_clause = state_to_clause(a_state)
    for i in range(len(a_clause['parameters'])):
        m.ActionParVal.objects.get_or_create(
            state = a_state,
            par = m.Parameter.objects.get(id=a_clause['parameters'][i]['id']),
            val = a_clause['parameterVals'][i]['value'].lower()
        )

    if kwargs['mode'] == "create" or forcecreate==True:
        rule = m.ESRule(owner=m.User_ICSE19.objects.get(id=kwargs['userid']),
                        type='es',
                        task = kwargs['taskid'],
                        Etrigger=e_trig,
                        action=a_state)
        rule.save()
    else: #edit existing rule
        try:
            rule = m.ESRule.objects.get(id=kwargs['ruleid'])
        except m.ESRule.DoesNotExist:
            return fe_create_esrule(request,forcecreate=True)

        rule.Etrigger=e_trig
        rule.action=a_state
        rule.save()
        for st in rule.Striggers.all():
            rule.Striggers.remove(st)

    try:
        for state in ifclause[1:]:
            s_trig = clause_to_trigger(state)
            rule.Striggers.add(s_trig)
    except IndexError:
        pass

    return fe_all_rules(request)

@csrf_exempt
def fe_delete_rule(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    try:
        rule = m.Rule.objects.get(id=kwargs['ruleid'])
    except m.Rule.DoesNotExist:
        return fe_all_rules(request)

    if rule.owner.id == kwargs['userid']:
        if rule.type == 'es':
            rule.esrule.Etrigger.delete()
            for st in rule.esrule.Striggers.all():
                st.delete()
            rule.esrule.action.delete()
        rule.delete()

    return fe_all_rules(request)

## not functional
def fe_create_ssrule(request,**kwargs):
    priority = kwargs['priority']
    action = m.State.objects.get(id=kwargs['actionid'])
    rule = m.SSRule(action=action,priority=priority)
    rule.save()

    for val in kwargs['triggerids']:
        rule.triggers.add(m.State.objects.get(id=val))

    return JsonResponse({'ssruleid' : rule.id})

def fe_create_rule(request,**kwargs):
    if kwargs['temp'] == 'es':
        return fe_create_esrule(request,kwargs)
    else:
        return fe_create_ssrule(request,kwargs)



###############################################################################
## [SPC] SAFETY PROPERTY CREATION
###############################################################################

@csrf_exempt
def fe_all_sps(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    json_resp = {'sps' : []}

    try:
        user = m.User_ICSE19.objects.get(id=kwargs['userid'])
    except KeyError:
        user = get_or_make_user(kwargs['code'],'sp')
        json_resp['userid'] = user.id

    sps = m.SafetyProp.objects.filter(owner=user,task=kwargs['taskid']).order_by('id')
    for sp in sps:
        if sp.type == 1:
            sp1 = sp.sp1
            triggers = sp1.triggers.all().order_by('pos')
            thisstate = triggers[0]
            try:
                thatstate = list(map(display_trigger,triggers[1:]))
            except IndexError:
                thatstate = []

            json_resp['sps'].append({'id' : sp.id,
                                     'thisState' : [display_trigger(thisstate)],
                                     'thatState' : thatstate,
                                     'compatibility' : sp1.always})
        elif sp.type == 2:
            sp2 = sp.sp2
            
            json2 = {'id' : sp.id,
                     'stateClause' : [display_trigger(sp2.state)],
                     'compatibility' : sp2.always}
            if sp2.comp:
                json2['comparator'] = sp2.comp
            if sp2.time != None:
                json2['time'] = int_to_time(sp2.time)
            
            clauses = sp2.conds.all().order_by('pos')
            if clauses != []:
                json2['alsoClauses'] = list(map(display_trigger,clauses))

            json_resp['sps'].append(json2)
        elif sp.type == 3:
            sp3 = sp.sp3
            json3 = {'id' : sp.id,
                     'triggerClause' : [display_trigger(sp3.event)],
                     'compatibility' : sp3.always}
            
            if sp3.comp:
                json3['comparator'] = sp3.comp
            if sp3.occurrences != None:
                json3['times'] = sp3.occurrences
            
            clauses = sp3.conds.all().order_by('pos')
            if clauses != []:
                json3['otherClauses'] = list(map(display_trigger,clauses))

            if sp3.time != None:
                if sp3.timecomp != None:
                    json3['afterTime'] = int_to_time(sp3.time)
                    json3['timeComparator'] = sp3.timecomp
                else:
                    json3['withinTime'] = int_to_time(sp3.time)

            json_resp['sps'].append(json3)

    return JsonResponse(json_resp)

@csrf_exempt
def fe_get_full_sp(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    sp = m.SafetyProp.objects.get(id=kwargs['spid'])
    if sp.type == 1:
        return fe_get_full_sp1(request)
    elif sp.type == 2:
        return fe_get_full_sp2(request)
    elif sp.type == 3:
        return fe_get_full_sp3(request)

@csrf_exempt
def fe_get_full_sp1(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    sp = m.SP1.objects.get(safetyprop_ptr_id=kwargs['spid'])
    ts = sp.triggers.all()
    thisstate = trigger_to_clause(ts[0],False)
    thatstate = []
    for t in ts[1:]:
        thatstate.append(trigger_to_clause(t,False))
    
    json_resp = {}
    json_resp['sp'] = {'thisState' : [thisstate],
                       'thatState' : thatstate,
                       'compatibility' : sp.always}

    return JsonResponse(json_resp)

@csrf_exempt
def fe_get_full_sp2(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    sp = m.SP2.objects.get(safetyprop_ptr_id=kwargs['spid'])

    state = trigger_to_clause(sp.state,False)
    json_resp = {'sp' : {'stateClause' : [state],
                         'compatibility' : sp.always}}
    if sp.comp != None:
        json_resp['sp']['comparator'] = sp.comp

    if sp.time != None:
        json_resp['sp']['time'] = int_to_time(sp.time)

    conds = sp.conds.all()
    if conds != []:
        json_resp['sp']['alsoClauses'] = []
        for c in conds:
            json_resp['sp']['alsoClauses'].append(trigger_to_clause(c,False))

    return JsonResponse(json_resp)

@csrf_exempt
def fe_get_full_sp3(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    sp = m.SP3.objects.get(safetyprop_ptr_id=kwargs['spid'])

    event = trigger_to_clause(sp.event,True)
    json_resp = {'sp' : {'triggerClause' : [event],
                         'compatibility' : sp.always}}

    if sp.occurrences != None and sp.comp != None:
        json_resp['sp']['comparator'] = sp.comp
        json_resp['sp']['times'] = sp.occurrences

    if sp.time != None:
        if sp.comp != None:
            json_resp['sp']['withinTime'] = int_to_time(sp.time)
        elif sp.timecomp != None:
            json_resp['sp']['afterTime'] = int_to_time(sp.time)
            json_resp['sp']['timeComparator'] = sp.timecomp

    conds = sp.conds.all()
    if conds != []:
        json_resp['sp']['otherClauses'] = []
        for c in conds:
            json_resp['sp']['otherClauses'].append(trigger_to_clause(c,False))

    return JsonResponse(json_resp)

@csrf_exempt
def fe_delete_sp(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    sp = m.SafetyProp.objects.get(id=kwargs['spid'])

    if sp.type == 1:
        sp = sp.sp1
        for t in sp.triggers.all():
            t.delete()
    elif sp.type == 2:
        sp = sp.sp2
        sp.state.delete()
        for c in sp.conds.all():
            c.delete()
    elif sp.type == 3:
        sp = sp.sp3
        sp.event.delete()
        for c in sp.conds.all():
            c.delete()

    sp.delete()

    return fe_all_sps(request)

@csrf_exempt
def fe_create_sp1(request,forcecreate=False):
    kwargs = json.loads(request.body.decode('utf-8'))
    spargs = kwargs['sp']

    if kwargs['mode'] == 'create' or forcecreate == True:
        sp = m.SP1(owner=m.User_ICSE19.objects.get(id=kwargs['userid']),
                   task=kwargs['taskid'],
                   type=1,
                   always=spargs['compatibility'])
        sp.save()
    else: #edit sp
        try:
            sp = m.SafetyProp.objects.get(id=kwargs['spid'])
        except m.SafetyProp.DoesNotExist: # catch non-existent SP error
            return fe_create_sp1(request,forcecreate=True)

        sp = sp.sp1

        sp.always = spargs['compatibility']
        sp.save()
        for trig in sp.triggers.all():
            sp.triggers.remove(trig)

    for clause in ([spargs['thisState'][0]] + spargs['thatState']):
        t = clause_to_trigger(clause)
        sp.triggers.add(t)

    sp.save()
    return JsonResponse({})

@csrf_exempt
def fe_create_sp2(request,forcecreate=False):
    kwargs = json.loads(request.body.decode('utf-8'))
    spargs = kwargs['sp']

    clause = spargs['stateClause'][0]
    t = clause_to_trigger(clause)

    if kwargs['mode'] == 'create' or forcecreate==True:
        sp = m.SP2(owner=m.User_ICSE19.objects.get(id=kwargs['userid']),
                          task=kwargs['taskid'],
                          type=2,
                          always=spargs['compatibility'],
                          state = t)
        sp.save()
    else:
        try:
            sp = m.SafetyProp.objects.get(id=kwargs['spid'])
        except m.SafetyProp.DoesNotExist:
            return fe_create_sp2(request,forcecreate=True)

        sp = sp.sp2

        sp.always = spargs['compatibility']
        sp.state = t
        sp.save()

        # null out remaining fields
        for cond in sp.conds.all():
            sp.conds.remove(cond)
        sp.comp = None
        sp.time = None
        sp.save()

    try:
        comp = spargs['comparator']
        time = spargs['time']
        time = time_to_int(time)
        if time > 0:
            sp.comp = comp
            sp.time = time
            sp.save()
        else:
            pass
    except KeyError:
        pass

    try:
        clauses = spargs['alsoClauses']
        for clause in clauses:
            t = clause_to_trigger(clause)
            sp.conds.add(t)
    except KeyError:
        pass

    sp.save()
    
    return JsonResponse({})

@csrf_exempt
def fe_create_sp3(request,forcecreate=False):
    kwargs = json.loads(request.body.decode('utf-8'))
    spargs = kwargs['sp']

    event = spargs['triggerClause'][0]
    t = clause_to_trigger(event)

    if kwargs['mode'] == 'create' or forcecreate==True:
        sp = m.SP3(owner=m.User_ICSE19.objects.get(id=kwargs['userid']),
                   task=kwargs['taskid'],
                   type=3,
                   always=spargs['compatibility'],
                   event = t)
        sp.save()
    else:
        try:
            sp = m.SafetyProp.objects.get(id=kwargs['spid'])
        except m.SafetyProp.DoesNotExist:
            return fe_create_sp3(request,forcecreate=True)

        sp = sp.sp3

        sp.always = spargs['compatibility']
        sp.event = t
        sp.save()

        # null out other fields
        for cond in sp.conds.all():
            sp.conds.remove(cond)
        sp.comp = None
        sp.occurrences = None
        sp.time = None
        sp.timecomp = None
        sp.save()

    try:
        comp = spargs['comparator']
        times = spargs['times']
        if times > 0:
            sp.comp = comp
            sp.occurrences = times
            try:
                within = spargs['withinTime']
                sp.time = time_to_int(within)
            except KeyError:
                pass
        else:
            pass
    except KeyError:
        pass

    try:
        clauses = spargs['otherClauses']
        for clause in clauses:
            t = clause_to_trigger(clause)
            sp.conds.add(t)
    except KeyError:
        pass

    try:
        time = spargs['afterTime']
        timecomp = spargs['timeComparator']
        sp.time=time_to_int(time)
        sp.timecomp=timecomp
    except KeyError:
        pass

    sp.save()
    return JsonResponse({})



###############################################################################
## [SLM] STATE & LOG MANAGEMENT
###############################################################################

# get current state of all caps of a device
def fe_current_device_status(request,**kwargs):
    dev = m.Device.objects.get(id=kwargs['deviceid'])
    json = {}
    for cap in dev.caps.all():
        state = current_state(dev,cap)
        if state != None:
            json[cap.id] = []
            for pv in m.ParVal.objects.filter(state=state):
                json[cap.id].append((pv.par.id,pv.val))
        else:
            json[cap.id] = "N/A"

    return JsonResponse(json)

# get state of all caps of a device [timedelta] minutes ago
def fe_historical_device_status(request,**kwargs):
    dev = m.Device.objects.get(id=kwargs['deviceid'])
    targettime = datetime.datetime.now(datetime.timezone.utc) - datetime.timedelta(minutes=kwargs['timedelta'])

    json = {
        "device_name" : dev.name
        }

    for cap in dev.caps.all():
        capstate = historical_state(dev,cap,targettime)
        json[cap.id] = capstate

    return JsonResponse(json)

# get record of all logged changes to a device
def fe_device_history(request,**kwargs):
    dev = m.Device.objects.get(id=kwargs['deviceid'])
    qset = m.StateLog.objects.filter(state__dev_id=dev.id)
    json = {"history" : []}
    for entry in sorted(qset,key=lambda entry : entry.timestamp,reverse=True):
        json["history"].append((entry.timestamp.ctime(),entry.param.id,entry.value))

    return JsonResponse(json)



###############################################################################
## [DM] DEVICE MANAGEMENT
###############################################################################

# Input: JSON
#        name           : device name
#        uid            : user's id
#        dev_type       : device type -> 'st' or 'f' or 'v'
#        capabilities   : list of capabilities
#           -> id       : capability id 
@csrf_exempt
def dm_create_device(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    try:
        user = User.objects.get(id=kwargs['uid'])
    except User.DoesNotExist:
        return JsonResponse({'errors': [{'err_msg': 'Please log in first!'}]})
    # in case that the device has already been created
    devs = user.objects.filter(devices__name=kwargs['name'], 
                               devices__public=False, 
                               devices__dev_type=kwargs['dev_tyep'])
    created = False
    if len(devs) == 0:
        dev = m.Device.objects.create(
                        name=kwargs['name'],
                        public=False,
                        dev_type=kwargs['dev_type'])
        dev.users.add(user)
        created = True
    else:
        dev = devs[0] # assume there should only be one device

    error_list = []
    for cap in kwargs['capabilities']:
        try:
            realcaps = capmap.lookup(cap['id'],kwargs['dev_type']) #HARDCODE
            if not realcaps is None:
                for rc in realcaps:
                    if created or not rc in dev.caps.all():
                        dev.caps.add(rc)
                        for chan in rc.channels.all(): #NEEDS IMPROVEMENT
                            dev.chans.add(chan)
        except Exception as e:
            error_list.append({"err_msg": repr(e)})

    if len(error_list) == 0:
        return JsonResponse({"devid": dev.id})
    else:
        return JsonResponse({"devid": dev.id, "errors": error_list}, status = 500)

# Input: JSON
#        capid          : capability id
#        deviceid       : device id
#        values         : dict of parameters values
#           -> [param_name]: [value]
@csrf_exempt
def dm_manage(request):
    # The incoming request contains JSON data
    kwargs = json.loads(request.body.decode('utf-8'))

    actions = st_process_update(kwargs)

    # @TODO: need to handle actions well
    try:
        ruleids = actions['ruleids']
        for rid in ruleids:
            a = actions[rid]
            grp = a.dev.dev_type
            send = prep_command(a,grp)
            if send:
                send_command(send,grp)
    except KeyError:
        pass

    return JsonResponse(actions)

@csrf_exempt
def dm_get_devices(request):
    # @TODO: add user separation here
    devs = m.Device.objects.filter(dev_type='st')



###############################################################################
## [UM] USER MANAGEMENT
###############################################################################

@csrf_exempt
def um_register(request):
    try:
        username = request.POST['username']
        password = request.POST['password']
        if len(User.objects.filter(username=username)) > 0:
            return JsonResponse({"msg": "Username already exists!"}, status=409)
        user = User.objects.create_user(username=username, password=password)
        user.save()
        login(request, user)
        # iotcore_resp = st_util.create_core_account(username)
        # return JsonResponse({"userid": user.id, "secret": iotcore_resp["secret"]}, status=200)
        return JsonResponse({"userid": user.id}, status=200)
    except Exception as e:
        return JsonResponse({"msg": repr(e)}, status=500)

@csrf_exempt
def um_login(request):
    try:
        username = request.POST['username']
        password = request.POST['password']
        user = authenticate(username=username, password=password)
        if user is not None:
            login(request, user)
            return JsonResponse({"userid": user.id}, status=200)
        else:
            return JsonResponse({"msg": "Authentication fail for" + username}, status=403)
    except Exception as e:
        return JsonResponse({"msg": repr(e)}, status = 500)

@csrf_exempt
def um_logout(request):
    try:
        logout(request)
        return JsonResponse({}, status=200)
    except Exception as e:
        return JsonResponse({"msg": repr(e)}, status = 500)

@csrf_exempt
def um_get_name(request):
    try:
        if request.user.is_authenticated:
            resp = {
                "userid": request.user.id, 
                "username": request.user.username
            }
            return JsonResponse(resp, status=200)
        else:
            return JsonResponse({"msg": "Please login."}, status=403)
    except Exception as e:
        return JsonResponse({"msg": repr(e)}, status = 500)

@csrf_exempt
def um_check_username(request):
    try:
        username = request.POST['username']
        if len(User.objects.filter(username=username)) > 0:
            return JsonResponse({"uniqueUsername": False}, status=200)
        else:
            return JsonResponse({"uniqueUsername": True}, status=200)
    except Exception as e:
        return JsonResponse({"msg": repr(e)}, status = 500)

###############################################################################
## [STM] SMARTTHINGS MANAGEMENT
###############################################################################

@csrf_exempt
def lm_get_locs(request):
    try:
        if settings.DEBUG:
            user = request.user
            all_locs = m.Location.objects.all()
            locs = []
            for loc in all_locs:
                if user in loc.users.all():
                    locs.append(loc)
            resp = {"locations": [{"id": loc.id, "name": loc.name} for loc in locs]}
            return JsonResponse(resp, status=200)
        else:
            if request.user.is_authenticated:
                locs = request.user.location_set.all()
                resp = {"locations": [{"id": loc.id, "name": loc.name} for loc in locs]}
                return JsonResponse(resp, status=200)
            else:
                return JsonResponse({"msg": "Please login."}, status=403)
    except Exception as e:
        return JsonResponse({"msg": repr(e)}, status = 500)

@csrf_exempt
def stm_get_installed_apps(request):
    try:
        if request.user.is_authenticated:
            resp = st_util.get_installed_apps()
            return JsonResponse({"st_installed_apps": resp}, status=200)
        else:
            return JsonResponse({"msg": "Please login."}, status=403)
    except Exception as e:
        return JsonResponse({"msg": repr(e)}, status = 500)