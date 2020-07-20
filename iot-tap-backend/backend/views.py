### django modules
from django.http import HttpResponse, JsonResponse, HttpResponseRedirect
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
from django.template import loader
from . import models as m
from django.db.models import Q
from django.core import serializers
from django.urls import reverse
from django.views.decorators.csrf import csrf_exempt, ensure_csrf_cookie
from django.conf import settings

### python modules
import operator as op
import datetime, random, json, re, datetime

### project moduels
from . import models as m
from . import capmap
from backend.util import *
from backend.rulecount import generate_cap_time_list_from_tap
import backend.st_util as st_util
from autotap.util import initialize_trace_for_location, get_trace_for_location
from autotap.variable import generate_all_device_templates, generate_boolean_map
from autotap.translator import translate_rule_into_autotap_tap, pv_clause_to_autotap_statement
from autotapta.model.Trace import enhanceTraceWithTiming
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

def fe_get_user(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    u = get_or_make_user(kwargs['code'],kwargs['mode'])
    json_resp = {'userid' : u.id}
    return JsonResponse(json_resp)


def fe_all_rules_helper(loc_id):
    # helper function without checking identity
    json_resp = {'rules' : []}

    location = m.Location.objects.get(id=loc_id)
    if location.st_installed_app_id == "" or location.st_installed_app_id is None:
        return JsonResponse(json_resp, status = 404)
    
    rule_set = m.Rule.objects.filter(st_installed_app_id=location.st_installed_app_id).order_by('id')
    
    for rule in rule_set:
        if rule.type == 'es':
            ifclause = []
            t = rule.esrule.Etrigger
            ifclause.append({'channel' : {'icon' : t.chan.icon if t.chan else ''},
                             'text' : t.text})
            for t in sorted(rule.esrule.Striggers.all(),key=lambda x: x.pos):
                ifclause.append({'channel' : {'icon' : t.chan.icon if t.chan else ''},
                                 'text' : t.text})
            a = rule.esrule.action
            thenclause = [{'channel' : {'icon' : a.chan.icon if not (a.chan == None) else ''},
                           'text' : a.text}]

            json_resp['rules'].append({'id' : rule.id,
                                       'ifClause' : ifclause,
                                       'thenClause' : thenclause,
                                       'temporality' : 'event-state'})
            json_resp['loc_id'] = loc_id

    return json_resp


# FRONTEND VIEW
#@csrf_exempt
def fe_all_rules(request, loc_id):
    '''
    Get all the rules that belong to a location\n
    Input:
        request:    Django's request object
        loc_id:     the id of the location
    Output:
        (JsonResponse) {"rules": [...]}
    '''
    
    
    err_json, status = check_access_to_location(request, loc_id)
    if is_error(status):
        return JsonResponse(err_json, status=status)
    
    return JsonResponse(fe_all_rules_helper(loc_id))


#@csrf_exempt
def fe_get_full_rule(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    json_resp = {}

    ### error handling
    err_json, status = check_access_to_location(request, kwargs['loc_id'])
    if is_error(status):
        return JsonResponse(err_json, status=status)
    ##################

    rule = m.Rule.objects.get(id=kwargs['ruleid'])

    if rule.type == 'es':
        rule = rule.esrule
        ifclause = []
        t = rule.Etrigger
        ifclause.append(trigger_to_clause(t,True))
        for t in sorted(rule.Striggers.all(),key=lambda x: x.pos):
            ifclause.append(trigger_to_clause(t,False))

        a = rule.action
        thenclause = action_to_clause(a)

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
#@csrf_exempt
def fe_all_chans(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    if not request.user.is_authenticated:
        return JsonResponse({}, status=401)

    json_resp = valid_chans(request.user,kwargs['is_trigger'])
    return JsonResponse(json_resp)

# FRONTEND VIEW
# return id:name dict of all devices with a given channel
#@csrf_exempt
def fe_devs_with_chan(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    if not request.user.is_authenticated:
        return JsonResponse({}, status=401)
    devs = m.Device.objects.filter(Q(users__in=[request.user])).distinct().order_by('name')
    chan = m.Channel.objects.get(id=kwargs['channelid'])
    devs = filter(lambda x : dev_has_valid_cap(x,chan,kwargs['is_trigger']),devs)
    json_resp = {'devs' : []}
    for dev in devs:
        json_resp['devs'].append({'id' : dev.id,'name' : dev.name})
    return JsonResponse(json_resp)

# return id: name dict of all devices within a given location
def fe_devs_with_loc(request):
    kwargs = json.loads(request.body.decode('utf-8'))

    err_json, status = check_access_to_location(request, kwargs['loc_id'])
    if is_error(status):
        return JsonResponse(err_json, status=status)

    devs = m.Device.objects.filter(Q(users__in=[request.user])).distinct().order_by('name')
    devs = filter(lambda x : dev_has_valid_cap_no_channel(x, kwargs['is_trigger']), devs)
    json_resp = {'devs' : []}
    for dev in devs:
        label = dev.label if dev.label and dev.label != "" else dev.name
        json_resp['devs'].append({'id' : dev.id,'name' : label})
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
#@csrf_exempt
def fe_get_valid_caps(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    caps = m.Capability.objects.filter(channels__id=kwargs['channelid'],device__id=kwargs['deviceid']).order_by('name')

    json_resp = {'caps' : []}
    for id,name,label in filtermap_caps(caps,kwargs['is_trigger'],kwargs['is_event']):
        json_resp['caps'].append({'id' : id, 'name' : name, 'label' : label})
    return JsonResponse(json_resp)

# return capabilities without considering channel
def fe_get_valid_caps_with_loc(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    caps = m.Capability.objects.filter(device__id=kwargs['deviceid']).order_by('name')

    json_resp = {'caps' : []}
    for id,name,label in filtermap_caps(caps,kwargs['is_trigger'],kwargs['is_event']):
        json_resp['caps'].append({'id' : id, 'name' : name, 'label' : label})
    return JsonResponse(json_resp)

# return id:(type,val constraints) dict of parameters for a given cap
#@csrf_exempt
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

def fe_create_esrule_helper(kwargs, user, forcecreate=False):
    # Error checking
    loc_id = kwargs['loc_id']
    try:
        location = m.Location.objects.get(pk=loc_id)
    except m.Location.DoesNotExist:
        return JsonResponse({}, status=404)

    ruleargs = kwargs['rule']
    ifclause = ruleargs['ifClause']
    
    event = ifclause[0]
    action_c = ruleargs['thenClause'].pop()

    e_trig = clause_to_trigger(event)
    a_state = clause_to_action(action_c)

    if kwargs['mode'] == "create" or forcecreate==True:
        installed_appid = location.st_installed_app_id
        rule = m.ESRule(st_owner=user,
                        st_installed_app_id=installed_appid,
                        type='es',
                        task = None,
                        Etrigger=e_trig,
                        action=a_state)
        rule.save()
    else: #edit existing rule
        try:
            rule = m.ESRule.objects.get(id=kwargs['rule_id'])
        except m.ESRule.DoesNotExist:
            return fe_create_esrule_helper(kwargs, user, forcecreate=True)

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

    # call to celery task. notify an update.
    tasks.update_db_cache.delay()

    return JsonResponse({}, status=201)


# create (OR EDIT) Event State Rule
#@csrf_exempt
def fe_create_esrule(request, forcecreate=False):
    kwargs = json.loads(request.body.decode('utf-8'))

    loc_id = kwargs['loc_id']
    try:
        location = m.Location.objects.get(pk=loc_id)
    except m.Location.DoesNotExist:
        return JsonResponse({}, status=404)

    if not request.user.is_authenticated:
        return JsonResponse({}, status=401)

    if not has_access_to_location(request.user, location.pk):
        return JsonResponse({}, status=403)
    
    user = request.user
    resp = fe_create_esrule_helper(kwargs, user, forcecreate=forcecreate)

    record_response(fe_all_rules_helper(loc_id), 'edit_rule', location)
    return resp


def fe_create_esrules(request):
    kwargs = json.loads(request.body.decode('utf-8'))

    # Error checking
    loc_id = kwargs['loc_id']
    try:
        location = m.Location.objects.get(pk=loc_id)
    except m.Location.DoesNotExist:
        return JsonResponse({}, status=404)

    if not request.user.is_authenticated:
        return JsonResponse({}, status=401)

    if not has_access_to_location(request.user, location.pk):
        return JsonResponse({}, status=403)
    
    user = request.user
    ruleargs = kwargs['rules']
    resp_list = []
    for rulearg in ruleargs:
        rule_id = rulearg['id'] if 'id' in rulearg else 0
        mode = 'edit' if rule_id else 'create'
        args = {'rule': rulearg, 'mode': mode, 'loc_id': loc_id, 'rule_id': rule_id}
        resp = fe_create_esrule_helper(args, user)
        resp_list.append(resp)
    
    for resp in resp_list:
        if resp.status_code != 201:
            return resp
    
    record_response(fe_all_rules_helper(loc_id), 'edit_rule', location)
    return JsonResponse({}, status=201)


def fe_change_esrules(request):
    kwargs = json.loads(request.body.decode('utf-8'))

    dev_c = kwargs['device']
    command_c = kwargs['command']

    target_dev = m.Device.objects.get(id=dev_c['id'])
    location = target_dev.location
    loc_id = location.id
    target_action = pv_clause_to_autotap_statement(dev_c, command_c['capability'], 
                                                command_c['parameter'], command_c['value'])

    rule_set = list(m.Rule.objects.filter(st_installed_app_id=location.st_installed_app_id).order_by('id'))
    orig_tap_list = [translate_rule_into_autotap_tap(rule, use_tick_header=False) for rule in rule_set]
    target_action = pv_clause_to_autotap_statement(dev_c, command_c['capability'], 
                                                command_c['parameter'], command_c['value'])
    orig_tap_id_list = [rule.id for tap, rule in zip(orig_tap_list, rule_set) if tap.action == target_action]

    user = request.user
    ruleargs = kwargs['rules']
    # resp_list = []
    # for rulearg in ruleargs:
    #     rule_id = rulearg['id'] if 'id' in rulearg else 0
    #     mode = 'edit' if rule_id else 'create'
    #     args = {'rule': rulearg, 'mode': mode, 'loc_id': loc_id, 'rule_id': rule_id}
    #     resp = fe_create_esrule_helper(args, user)
    #     resp_list.append(resp)
    resp_list = []

    modified_rule_id_set = {rule["id"] for rule in ruleargs if rule["id"]}
    for rule in rule_set:
        if rule.id in orig_tap_id_list:
            if rule.id not in modified_rule_id_set:
                # should delete this
                if not has_access_to_location(request.user, location.pk):
                    return JsonResponse({'rules' : []}, status=403)

                if rule.type == 'es':
                    rule.esrule.Etrigger.delete()
                    for st in rule.esrule.Striggers.all():
                        st.delete()
                    rule.esrule.action.delete()
                rule.delete()

                # call to celery task. notify an update.
                tasks.update_db_cache.delay()
            else:
                # should modify this
                target_arg = None
                for rulearg in ruleargs:
                    if rulearg["id"] == rule.id:
                        target_arg = rulearg
                        break
                
                if target_arg is not None:
                    rule_id = rulearg['id'] if 'id' in rulearg else 0
                    mode = 'edit' if rule_id else 'create'
                    args = {'rule': rulearg, 'mode': mode, 'loc_id': loc_id, 'rule_id': rule_id}
                    resp = fe_create_esrule_helper(args, user)
                    resp_list.append(resp)
        else:
            # not the same action, skip
            pass
    
    record_response(fe_all_rules_helper(loc_id), 'edit_rule', location)
    for resp in resp_list:
        if resp.status_code != 201:
            return resp
    return JsonResponse({}, status=201)


#@csrf_exempt
def fe_delete_rule(request):
    kwargs = json.loads(request.body.decode('utf-8'))

    try:
        loc = m.Location.objects.get(id=kwargs['locid'])
    except m.Location.DoesNotExist:
        return JsonResponse({'rules' : []}, status=404)

    try:
        rule = m.Rule.objects.get(id=kwargs['ruleid'])
    except m.Rule.DoesNotExist:
        return fe_all_rules(request, kwargs['ruleid'])

    if not has_access_to_location(request.user, loc.pk):
        return JsonResponse({'rules' : []}, status=403)

    if rule.type == 'es':
        rule.esrule.Etrigger.delete()
        for st in rule.esrule.Striggers.all():
            st.delete()
        rule.esrule.action.delete()
    rule.delete()

    # call to celery task. notify an update.
    tasks.update_db_cache.delay()

    record_response(fe_all_rules_helper(loc.id), 'edit_rule', loc)
    return fe_all_rules(request, kwargs['locid'])

## not functional
# def fe_create_ssrule(request,**kwargs):
#     priority = kwargs['priority']
#     action = m.State.objects.get(id=kwargs['actionid'])
#     rule = m.SSRule(action=action,priority=priority)
#     rule.save()

#     for val in kwargs['triggerids']:
#         rule.triggers.add(m.State.objects.get(id=val))

#     return JsonResponse({'ssruleid' : rule.id})

def fe_create_rule(request,**kwargs):
    if kwargs['temp'] == 'es':
        return fe_create_esrule(request,kwargs)
    else:
        return fe_create_ssrule(request,kwargs)



###############################################################################
## [SPC] SAFETY PROPERTY CREATION
###############################################################################

#@csrf_exempt
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

#@csrf_exempt
def fe_get_full_sp(request):
    kwargs = json.loads(request.body.decode('utf-8'))
    sp = m.SafetyProp.objects.get(id=kwargs['spid'])
    if sp.type == 1:
        return fe_get_full_sp1(request)
    elif sp.type == 2:
        return fe_get_full_sp2(request)
    elif sp.type == 3:
        return fe_get_full_sp3(request)

#@csrf_exempt
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

#@csrf_exempt
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

#@csrf_exempt
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

#@csrf_exempt
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

#@csrf_exempt
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

#@csrf_exempt
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

#@csrf_exempt
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
#        label          : device label
#        uid            : user's id
#        dev_type       : device type -> 'st' or 'f' or 'v'
#        capabilities   : list of capabilities
#           -> id       : capability id 
#@csrf_exempt
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
                        label=kwargs['label'],
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
#@csrf_exempt
def dm_manage(request):
    '''
    @IMPORTANT: This function should only be used by IoTCore.

    Input: New events sent from SmartThings:
        - {
            "st_installed_app_id": the installed SmartThings app id,
            "capid": capability id of SmartThings,
            "deviceid": device id of this project,
            "values": {
                <param_name>: <param_value>
            }
        }
    Output:
        - [{  
            "capability": <commandname>,  
            "devid": <device proj id>,  
            "values": { <st_param_id>: <parval_value>, ...}  
        }, ...]
    '''
    # @TODO: add signature verification
    # The incoming request contains JSON data
    kwargs = json.loads(request.body.decode('utf-8'))

    updates = st_process_update(kwargs)
    actions = updates.get("actions", [])

    # for action in actions:
    #     try:
    #         dev = m.Device.objects.get(id = action.get("devid", -1))
    #     except m.Device.DoesNotExist:
    #         err_detail = "Cannot find the device for devid={}".format(action.get("devid", -1))
    #         return st_util.return_error_msg("dm_manage", err_detail, status = 404)
    #     user = dev.users.all()[0]
    #     resp = st_util.execute_commands(user, action)

    return JsonResponse(actions, safe=False)

# Input: JSON
#        locid          : location id
#@csrf_exempt
def dm_get_devices(request):
    '''
    Get user's devices that are installed in a specific location. Create one if not exists.
    Input:
        - locid: location id in this project
    Output:
        - 200: {
            "devs": [
                {"id": "", "name": "", "icon": "", "mainState": True, "mainStateLabel": "On", "subscribed": True},
                ...
            ]
        }
        - others: {"msg": err_msg}
    '''
    if request.user.is_authenticated:
        kwargs = json.loads(request.body.decode('utf-8'))
        devs = request.user.device_set.filter(location__id = kwargs["locid"])
        try:
            loc = m.Location.objects.get(id=kwargs["locid"])
        except m.Location.DoesNotExist:
            st_util.get_locations_from_st(request.user)
            loc = m.Location.objects.get(id=kwargs["locid"])
        if not settings.DEBUG:
            devs = st_util.get_devices_from_st(request.user, loc.st_loc_id)
        else:
            devs = m.Device.objects.filter(location=loc)

        output = {"devs": []}
        
        celery_force_update(request) # Bo Wang: add force update
        
        template_dict = generate_all_device_templates(loc, use_label=True)
        boolean_map = generate_boolean_map()
        trace = get_trace_for_location(loc)
        rule_set = m.Rule.objects.filter(st_installed_app_id=loc.st_installed_app_id).order_by('id')
        orig_tap_list = [translate_rule_into_autotap_tap(rule, use_tick_header=False) for rule in rule_set]
        cap_time_list = []
        for tap in orig_tap_list:
            cap_time_list += generate_cap_time_list_from_tap(tap)
        cap_time_list = list(set(cap_time_list))
        trace = enhanceTraceWithTiming(trace, cap_time_list, '*')

        for dev in devs:
            # check to see if the device has the power on/off capability
            has_switch_state = dev.caps.filter(name="Power On/Off").exists()
            new_entry = {
                "id": dev.id,
                "name": dev.name,
                "label": dev.label,
                "icon": dev.icon,
                "subscribed": dev.is_subscribed
            }
            commands = list()
            plain_revert = 'plain_revert' in kwargs and kwargs['plain_revert']
            command_tup_list = get_dev_commands(dev, trace=trace, template_dict=template_dict, boolean_map=boolean_map, 
                                                orig_tap_list=orig_tap_list, plain_revert=plain_revert)
            for cap, param, val, count, covered, reverted in command_tup_list:
                command = {
                    "capability": {"id": cap.id, "name": cap.name, "label": cap.commandlabel}, 
                    "parameter": {"id": param.id, "name": param.name, "type": param.type, "values": get_param_vals(param)}, 
                    "value": val, "count": count, "covered": covered, 'reverted': reverted
                }
                commands.append(command)
            new_entry["commands"] = commands
            if has_switch_state:
                try:
                    curr_state = m.StateLog.objects.get(dev=dev, cap__name="Power On/Off", status=m.StateLog.CURRENT)
                    new_entry["mainState"] = curr_state.value.lower() == "on"
                    new_entry["mainStateLabel"] = curr_state.value
                except m.StateLog.DoesNotExist:
                    new_entry["mainState"] = None
                    new_entry["mainStateLabel"] = None
                except m.StateLog.MultipleObjectsReturned:
                    all_related_states = m.StateLog.objects.filter(
                        dev=dev, 
                        cap__name="Power On/Off", 
                        status=m.StateLog.CURRENT
                    ).order_by("-timestamp")

                    # mark all older states as HAPPENED
                    for state in all_related_states[1:]:
                        state.status = m.StateLog.HAPPENED
                    m.StateLog.objects.bulk_update(all_related_states[1:], ['status'])

                    # use the most recent state as the current state
                    curr_state = all_related_states[0]
                    new_entry["mainState"] = curr_state.value.lower() == "on"
                    new_entry["mainStateLabel"] = curr_state.value
            else:
                new_entry["mainState"] = None
                new_entry["mainStateLabel"] = None
            output["devs"].append(new_entry)
        return JsonResponse(output, status=200)
    else:
        return JsonResponse({"msg": "Please log in first!"}, status=401)

def dm_add_subscription(request):
    '''
    Add subscription for a specific device
    Input:
        - {
            "devid": "xxxxx"
        }
    Output:
        200: {}
        others: {"msg": "xxxxxx"}
    '''
    if request.user.is_authenticated:
        kwargs = json.loads(request.body.decode('utf-8'))
        subscrib_resp = st_util.subscribe_device(request.user, kwargs.get("devid", ""))
        if subscrib_resp["status_code"] == 200:
            return JsonResponse({}, status = 200)
        else:
            return JsonResponse({"msg": subscrib_resp["msg"]}, status = subscrib_resp["status_code"])
    else:
        return JsonResponse({"msg": "Please log in first!"}, status=401)

def dm_execute_command(request):
    '''
    Execute commands on a device
    Input:
        {
            'locid': xxx,
            'devid': xxxx,
            'capability': 'xxxx',
            'command': 'xxxx',
            'value': {'st_param_id': 'parval_value'}
        }
    '''
    kwargs = json.loads(request.body.decode('utf-8'))

    # Error checking
    loc_id = kwargs.pop('locid')
    try:
        location = m.Location.objects.get(pk=loc_id)
    except m.Location.DoesNotExist:
        return JsonResponse({}, status=404)
    if not request.user.is_authenticated:
        return JsonResponse({}, status=401)
    if not has_access_to_location(request.user, location.pk):
        return JsonResponse({}, status=403)
    
    # if the user has passed the permission checking
    return st_util.execute_commands_on_core_st(request.user, location, [kwargs])
    


###############################################################################
## [UM] USER MANAGEMENT
###############################################################################

#@csrf_exempt
def um_register(request):
    try:
        username = request.POST['username']
        password = request.POST['password']
        # if len(User.objects.filter(username=username)) > 0:
        #     return JsonResponse({"msg": "Username already exists!"}, status=409)
        # user = User.objects.create_user(username=username, password=password)
        # user.save()
        resp, status = st_util.create_user_account(username=username, password=password)
        if status == 200:
            user = authenticate(username=username, password=password)
            login(request, user, backend='iot-tap-backend.auth_backend.IoTCoreAuthBackend')
            return JsonResponse({"userid": user.id}, status=200)
        else:
            return JsonResponse({"msg": "Login failed!", "status": status, "iotcore": resp}, status=status)
        return JsonResponse({"userid": user.id}, status=200)
    except Exception as e:
        return JsonResponse({"msg": repr(e)}, status=500)

#@csrf_exempt
def um_login(request):
    try:
        username = request.POST['username']
        password = request.POST['password']
        user = authenticate(username=username, password=password)
        
        if user:
            login(request, user, backend='iot-tap-backend.auth_backend.IoTCoreAuthBackend')
            return JsonResponse({"userid": user.id, "superuser": user.is_superuser}, status=200)
        else:
            return JsonResponse({"msg": "Authentication fail for " + username}, status=403)
    except Exception as e:
        return JsonResponse({"msg": repr(e)}, status = 500)

#@csrf_exempt
def um_logout(request):
    try:
        # @TODO: Should we remove access token and refresh token as well?
        logout(request)
        return JsonResponse({}, status=200)
    except Exception as e:
        return JsonResponse({"msg": repr(e)}, status = 500)

#@csrf_exempt
def um_get_name(request):
    try:
        if request.user.is_authenticated:
            resp = {
                "userid": request.user.id, 
                "username": request.user.username,
                "superuser": request.user.is_superuser
            }
            return JsonResponse(resp, status=200)
        else:
            return JsonResponse({"msg": "Please login."}, status=401)
    except Exception as e:
        return JsonResponse({"msg": repr(e)}, status = 500)

#@csrf_exempt
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

#@csrf_exempt
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
                if request.user.is_superuser:
                    locs = m.Location.objects.all()
                else:
                    locs = st_util.get_locations_from_st(request.user)
                resp = {"locations": [{"id": loc.id, "name": loc.name} for loc in locs]}
                return JsonResponse(resp, status=200)
            else:
                return JsonResponse({"msg": "Please login."}, status=401)
    except Exception as e:
        return JsonResponse({"msg": repr(e)}, status = 500)

#@csrf_exempt
def stm_get_installed_apps(request):
    try:
        if request.user.is_authenticated:
            resp = st_util.get_installed_apps()
            return JsonResponse({"st_installed_apps": resp}, status=200)
        else:
            return JsonResponse({"msg": "Please login."}, status=401)
    except Exception as e:
        return JsonResponse({"msg": repr(e)}, status = 500)

#@csrf_exempt
# def stm_oauth2_token(request):
#     '''
#     The callback function of oauth2 requests from IoTCore
#     Currently not in use!
#     '''
#     try:
#         code = request.GET.get('code', 'Not Found')
#         state = request.GET.get("state", "Not Found")
#         redirect_uri = request.build_absolute_uri(reverse("oauth_callback"))
#         resp = st_util.get_access_token(code, redirect_uri)
#         return JsonResponse({"code": code, "state": state, "resp": resp})
#     except Exception as e:
#         return JsonResponse({"msg": repr(e)}, status = 500)


#@csrf_exempt
def stm_register_app(request):
    try:
        if not request.user.is_authenticated:
            return JsonResponse({"msg": "Please login."}, status=401)
        m.ErrorLog.objects.create(err="stm_register_app: {}".format("begin"))
        data = json.loads(request.body.decode('utf-8'))
        m.ErrorLog.objects.create(err="stm_register_app: data={}".format(data))
        resp = st_util.stapp_exists(request.user, data["client_id"], data["client_secret"])
        m.ErrorLog.objects.create(err="stm_register_app: resp={}".format(resp))
        if resp.status_code == 200:
            # if the stapp has already been created
            stapp_data = json.loads(resp.content.decode('utf-8'))
            m.ErrorLog.objects.create(err="stm_register_app: stapp_data={}".format(stapp_data))
            request.user.userprofile.stapp_id = stapp_data["stapp_id"]
            request.user.userprofile.save()
            return JsonResponse({})
        
        # if the stapp hasn't been created yet
        from django.conf import settings
        data["id"] = "{}-{}".format(settings.PROJECT_NAME, request.user.username)
        data["permissions"] = settings.GLOBAL_SETTINGS["DEFAULT_STAPP_PERMISSIONS"]
        data["prod_endpoint"] = settings.GLOBAL_SETTINGS.get("DEFAULT_PROD_ENDPOINT", "")
        data["debug_endpoint"] = settings.GLOBAL_SETTINGS.get("DEFAULT_DEBUG_ENDPOINT", "")
        data["docker_endpoint"] = settings.GLOBAL_SETTINGS.get("DEFAULT_DOCKER_ENDPOINT", "")
        data["pages"] = [
            {
                "id": "{}_page_1".format(data["id"]).replace('-', '_'),
                "nextPageId": None,
                "previousPageId": None,
                "complete": True,
                "name": "Debriefing",
                "sections": [
                    {
                        "name": "Debriefing-Page",
                        "settings": [
                            {
                                "id": "debrief",
                                "name": "Debriefing",
                                "description": "Debriefing of Data Collection",
                                "type": "PARAGRAPH",
                                "defaultValue": settings.GLOBAL_SETTINGS["DEFAULT_STAPP_DEBRIEFING"]
                            }
                        ]
                        
                    }
                ]
            }
        ]
        access_token = st_util.get_access_token(request.user)
        m.ErrorLog.objects.create(err="stm_register_app: access_token={}".format(access_token))
        m.ErrorLog.objects.create(err="stm_register_app: (create app) data={}".format(data))
        resp = st_util.create_app(access_token, data)
        m.ErrorLog.objects.create(err="stm_register_app: (create app)resp={}".format(resp))
        if resp.status_code == 200 or resp.status_code == 201:
            request.user.userprofile.stapp_id = data["id"]
            request.user.userprofile.save()
        return resp
            
    except Exception as e:
        return JsonResponse({"msg": repr(e)}, status = 500)


'''
for debugging or force update celery's cache.
'''
def celery_force_update(request):
    print("# iot-tap-backend: CELERY UPDATE signal send.")
    tasks.update_db_cache.delay()
    return JsonResponse({"msg": "force update sent."}, status = 200)
    
