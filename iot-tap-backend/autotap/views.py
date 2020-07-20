from django.shortcuts import render

# Create your views here.
from django.http import HttpResponse, JsonResponse
from django.template import loader
from django.core.cache import cache, caches
from django.utils.crypto import get_random_string
import backend.models as m
import os, sys
from autotapmc.analyze.Fix import generateCompactFix, generateNamedFix
from autotapmc.model.Tap import Tap
from autotapta.input.IoTCore import inputTraceFromList, updateTraceFromList
from autotapta.analyze.Analyze import synthesizeRuleBasedOnMultipleEvents, extractEpisodes, \
    synthesizeRuleBasedOnEpisodes, calcTimingCorrelation, listTimingCandidates, \
    synthesizeTimingRuleBasedOnEpisodes, listRelatedCandidates, synthesizeTimingRuleBasedOnEpisodesSplit, \
    synthesizeRuleGeneral, extractTriggerCases, debugRuleGeneral, filterFlipping, extractRevertCases
from autotapta.model.Trace import enhanceTraceWithTiming, getSubTraceBasedOnCaps
from autotapta.analyze.Rank import calcScore, calcMetaInfo, getTriggerTimeInTrace, calcScoreEnhanced, \
    checkIfEpisodeCovered, extractOrigNewTriggerTimes, calcScoreDebug
from autotapta.analyze.Range import reAssignRangeVariableInTrace
from autotapta.analyze.Cluster import clusterBitVec
from django.conf import settings
from django.utils.timezone import make_aware
from django.views.decorators.csrf import csrf_exempt
from autotap.translator import tap_to_frontend_view, translate_sp_to_autotap_ltl, \
    translate_rule_into_autotap_tap, generate_all_device_templates, backend_to_frontend_view, \
    generate_boolean_map, autotapta_formula_to_clause, check_action_external, pv_clause_to_autotap_statement, \
    tap_to_frontend_view_ta, split_autotap_formula, dev_name_to_autotap, cap_name_to_autotap, var_name_to_autotap, \
    translate_clause_into_autotap_tap
from autotap.testdata import property_user_task_list, rule_user_task_list, task_ltl_dict, \
    correct_property_user_task_list, mutated_rule_user_task_list, multiple_property_user_task_list
from autotap.util import get_trace_for_location, get_sensor_dev_cap, get_action_dev_cap, \
    get_sensor_dev_cap_django, get_action_dev_cap_django, merge_times, find_time_clips, \
    translate_time_clip, generate_clip, translate_time_clip_debug, modify_patch_to_taps, delete_patch_to_taps
from autotap.variable import generate_reverse_template
from backend.rulecount import generate_cap_time_list_from_tap
from backend.util import record_request, record_response, get_dev_commands, get_param_vals, get_location_from_user

import itertools
import json
import datetime
from numpy import array
from pytz import timezone
from copy import deepcopy

# trace visualization
from autotap.parse_trace import parse_trace, parse_trace_new

def get_or_make_user(code,mode):
    try:
        user = m.User.objects.get(code=code, mode=mode)
    except m.User.DoesNotExist:
        user = m.User(code=code, mode=mode)
        user.save()

    return user


def get_user_id(user_id):
    n_code = False
    n_id = False
    try:
        user_id = m.User.objects.get(code=user_id).id
        return user_id
    except m.User.DoesNotExist:
        n_code = True
    try:
        user_id = m.User.objects.get(id=user_id).id
        return user_id
    except (m.User.DoesNotExist, ValueError):
        n_id = True

    if n_code and n_id:
        raise Exception("User %s does not exist." % str(user_id))


def generate_text_for_single_user(code, task_id, ltl):
    try:
        user_id_rule = m.User.objects.get(code=code, mode="rules")
        rule_list = m.Rule.objects.filter(owner=user_id_rule, task=int(task_id))
    except m.User.DoesNotExist:
        rule_list = list()

    rule_text = ""
    tap_list = list()
    for rule in rule_list:
        tap = translate_rule_into_autotap_tap(rule)
        # print(tap.__dict__)
        tap_list.append(tap)
        rule_text = rule_text + '[] IF %s WHILE %s, THEN %s<br>' % (tap.trigger, str(tap.condition), tap.action)

    template_dict = generate_all_device_templates()
    new_rule_patch = generateCompactFix(ltl, tap_list,
                                        init_value_dict={}, template_dict=template_dict)
    new_rule_patch_text_list = ['[] IF %s WHILE %s, THEN %s' %
                                (patch.trigger, ' & '.join(patch.condition), str(patch.action))
                                for patch in new_rule_patch]
    new_rule_patch_text = '<br>'.join(new_rule_patch_text_list)
    rule_id_list = [rule.id for rule in rule_list]

    action_num_list = [len(patch.action)>0 for patch in new_rule_patch]
    if all(action_num_list):
        success_flag = True
    else:
        success_flag = False

    http_content = "==========user=%s, task=%s==========<br>" \
                   "The property being checked is %s<br> " \
                   "Rule IDs: %s <br> %s <br> Fixing Patch: <br>%s <br>" \
                   "Visit <a href=\"localhost:4200/%s/%s\">localhost:4200/%s/%s</a> " \
                   "to see the user-written properties/rules<br>" \
                   "====================================<br>" % \
                   (
                       code,
                       str(task_id),
                       ltl,
                       str(rule_id_list),
                       rule_text,
                       new_rule_patch_text,
                       code,
                       task_id,
                       code,
                       task_id
                   )

    if not success_flag:
        http_content = "<font color=\"red\">failed</font>" + http_content
    return http_content


def expand_autotap_result_into_patches_named(patch_list, label_list, is_compact=False):
    if not is_compact:
        action_list = [tap.action for tap in patch_list]
        result_list = list()
        for selected_action in itertools.product(*action_list):
            patch = {k: tap_to_frontend_view(Tap(action=[s_a], condition=tap.condition, trigger=tap.trigger))
                     for k, s_a, tap in zip(label_list, selected_action, patch_list)}
            result_list.append(patch)
    else:
        result_list = {k: tap_to_frontend_view(tap) for k, tap in zip(label_list, patch_list)}
    return result_list


def expand_autotap_result_into_patches_unnamed(patch_list, is_compact=False):
    if not is_compact:
        action_list = [tap.action for tap in patch_list]
        result_list = list()
        for selected_action in itertools.product(*action_list):
            patch = [tap_to_frontend_view(Tap(action=[s_a], condition=tap.condition, trigger=tap.trigger))
                     for s_a, tap in zip(selected_action, patch_list)]
            result_list.append(patch)
    else:
        result_list = [tap_to_frontend_view(tap) for tap in patch_list]

    return result_list


def parse_fix_request(request):
    if request.method == 'GET':
        kwargs = request.GET
    elif request.method == 'POST':
        kwargs = json.loads(request.body.decode('utf-8'))
    else:
        raise Exception('The request is neither a POST or a GET.')

    try:
        user_rules = m.User.objects.get(id=kwargs['userid'], mode="rules")
        user_id_rules = user_rules.id
    except KeyError:
        user_id_rules = get_or_make_user(kwargs['code'], 'rules')

    try:
        user_sp = m.User.objects.get(id=kwargs['userid'], mode="sp")
        user_id_sp = user_sp.id
    except KeyError:
        user_id_sp = get_or_make_user(kwargs['code'], 'sp')

    task_id = kwargs['taskid']
    try:
        is_compact = int(kwargs['compact'])
    except KeyError:
        is_compact = 0

    try:
        is_named = int(kwargs['named'])
    except KeyError:
        is_named = 1

    return {'user_id_rules': user_id_rules, 'user_id_sp': user_id_sp,
            'task_id': task_id, 'is_compact': is_compact, 'is_named': is_named}


@csrf_exempt
def test(request):
    if request.method == 'GET':
        template = loader.get_template('autotap.html')
        return HttpResponse(template.render())

    elif request.method == 'POST':
        user_id = request.POST.get('user', '')
        task_id = request.POST.get('task', '')
        ltl = '!(%s)' % request.POST.get('ltl', '1')

        if user_id:
            http_content = generate_text_for_single_user(user_id, task_id, ltl)
        else:
            rule_list = m.Rule.objects.filter(task=task_id)
            owner_id_list = list(set([rule.owner_id for rule in rule_list]))
            http_content = ''
            num_instance = 0
            num_succeed = 0
            for user_id in owner_id_list:
                num_instance = num_instance + 1
                print('checking user=%s, task=%s' % (user_id, task_id))
                try:
                    single_http_content = generate_text_for_single_user(user_id, task_id, ltl)
                    num_succeed = num_succeed + 1
                except Exception as exc:
                    code = m.User.objects.get(id=user_id).code
                    single_http_content = '==========user=%s, task=%s==========<br>' \
                                          'failed<br>' \
                                          'please visit super.cs.uchicago.edu/superifttt/%s/%s/rules<br>%s<br>' \
                                          '====================================<br>' % \
                                          (user_id, task_id, code, task_id, exc)
                # print(single_http_content)
                http_content = http_content + single_http_content
            http_content = http_content + 'total: %d, succeeded: %d, failed: %d' % \
                           (num_instance, num_succeed, num_instance - num_succeed)

        return HttpResponse(http_content)


@csrf_exempt
def synthesize(request):
    if request.method == 'GET':
        template = loader.get_template('synthesize.html')
        user_task_list = ['%s %s' % (code, str(task)) for code, task, score in property_user_task_list]
        return HttpResponse(template.render(context={'user_task_list': user_task_list}))

    elif request.method == 'POST':
        action = request.POST.get('action')
        http_content = ''
        if action == "Submit":
            user_code, task_id = request.POST.get('user_task').split(' ')
            task_id = int(task_id)
            user_id_sp = m.User.objects.get(code=user_code, mode="sp").id
            sp_list = m.SafetyProp.objects.filter(owner=user_id_sp, task=task_id)
            ltl_list = ['(%s)' % translate_sp_to_autotap_ltl(sp) for sp in sp_list]
            ltl = '!(%s)' % ' & '.join(ltl_list)
            http_content = generate_text_for_single_user(user_code, task_id, ltl)
        elif action == 'Test All' or action == 'Reproduce':
            user_task_list = [(code, task) for code, task, score in correct_property_user_task_list]
            for code, task_id in user_task_list:
                user_id_property = m.User.objects.get(code=code, mode="sp").id
                sp_list = m.SafetyProp.objects.filter(owner=user_id_property, task=task_id)
                print('synthesizing rules with user-written properties code=%s, task_id=%s...' %
                      (code, task_id))
                try:
                    ltl_list = ['(%s)' % translate_sp_to_autotap_ltl(sp) for sp in sp_list]
                    ltl = '!(%s)' % ' & '.join(ltl_list)
                    http_content = http_content + generate_text_for_single_user(code, task_id, ltl)
                except Exception as exc:
                    http_content = http_content + '==========user=%s, task=%s==========<br>' \
                                          'failed<br>' \
                                          'please visit localhost:4200/%s/%s<br>%s<br>' \
                                          '====================================<br>' % \
                                          (code, task_id, code, task_id, exc)

        return HttpResponse(http_content)


@csrf_exempt
def multisp(request):
    if request.method == 'GET':
        template = loader.get_template('multisp.html')
        user_task_list = ['%s %s' % (code, str(task)) for code, task in multiple_property_user_task_list]
        return HttpResponse(template.render(context={'user_task_list': user_task_list}))

    elif request.method == 'POST':
        action = request.POST.get('action')
        http_content = ''
        if action == "Submit":
            user_code, task_id = request.POST.get('user_task').split(' ')
            task_id = int(task_id)
            user_id_sp = m.User.objects.get(code=user_code, mode="sp").id
            sp_list = m.SafetyProp.objects.filter(owner=user_id_sp, task=task_id)
            ltl_list = ['(%s)' % translate_sp_to_autotap_ltl(sp) for sp in sp_list]
            ltl = '!(%s)' % ' & '.join(ltl_list)
            http_content = generate_text_for_single_user(user_code, task_id, ltl)
        elif action == 'Test All' or action == 'Reproduce':
            user_task_list = [(code, task) for code, task in multiple_property_user_task_list]
            for code, task_id in user_task_list:
                user_id_property = m.User.objects.get(code=code, mode="sp").id
                sp_list = m.SafetyProp.objects.filter(owner=user_id_property, task=task_id)
                print('synthesizing rules from multiple properties code=%s, task_id=%s...' %
                      (code, task_id))
                try:
                    ltl_list = ['(%s)' % translate_sp_to_autotap_ltl(sp) for sp in sp_list]
                    ltl = '!(%s)' % ' & '.join(ltl_list)
                    http_content = http_content + generate_text_for_single_user(code, task_id, ltl)
                except Exception as exc:
                    http_content = http_content + '==========user=%s, task=%s==========<br>' \
                                          'failed<br>' \
                                          'please visit localhost:4200/%s/%s<br>%s<br>' \
                                          '====================================<br>' % \
                                          (code, task_id, code, task_id, exc)

        return HttpResponse(http_content)


@csrf_exempt
def debug(request):
    if request.method == 'GET':
        template = loader.get_template('debug.html')
        user_task_list = ['%s %s' % (code, str(task)) for code, task in mutated_rule_user_task_list]
        return HttpResponse(template.render(context={'user_task_list': user_task_list}))

    elif request.method == 'POST':
        action = request.POST.get('action')
        http_content = ''
        if action == "Submit":
            user_code, task_id = request.POST.get('user_task').split(' ')
            task_id = int(task_id)
            user_id = m.User.objects.get(code=user_code).id
            ltl = task_ltl_dict[task_id]
            http_content = generate_text_for_single_user(user_id, task_id, ltl)
        elif action == 'Test All' or action == 'Reproduce':
            user_task_list = [(code, task) for code, task in mutated_rule_user_task_list]
            for code, task_id in user_task_list:
                user_id_property = m.User.objects.get(code=code, mode="sp").id
                sp_list = m.SafetyProp.objects.filter(owner=user_id_property, task=task_id)
                print('debug rules with code=%s, task_id=%s...' %
                      (code, task_id))
                try:
                    ltl_list = ['(%s)' % translate_sp_to_autotap_ltl(sp) for sp in sp_list]
                    ltl = '!(%s)' % ' & '.join(ltl_list)
                    http_content = http_content + generate_text_for_single_user(code, task_id, ltl)
                except Exception as exc:
                    http_content = http_content + '==========user=%s, task=%s==========<br>' \
                                                  'failed<br>' \
                                                  'please visit localhost:4200/%s/%s<br>%s<br>' \
                                                  '====================================<br>' % \
                                   (code, task_id, code, task_id, exc)

        return HttpResponse(http_content)


@csrf_exempt
def reproduce(request):
    template = loader.get_template('reproduce.html')
    return HttpResponse(template.render())


@csrf_exempt
def fix(request):
    json_resp = dict()
    try:
        req_dict = parse_fix_request(request)
        user_id_rules = req_dict['user_id_rules']
        user_id_sp = req_dict['user_id_sp']
        task_id = req_dict['task_id']
        is_named = req_dict['is_named']
        is_compact = req_dict['is_compact']

        rule_list = m.Rule.objects.filter(task=task_id, owner=user_id_rules)
        sp_list = m.SafetyProp.objects.filter(task=task_id, owner=user_id_sp)

        ltl_list = [translate_sp_to_autotap_ltl(sp) for sp in sp_list]
        if ltl_list:
            ltl = '!(%s)' % ' & '.join(ltl_list)
        else:
            ltl = '!(1)'

        template_dict = generate_all_device_templates()
        if is_named:
            tap_dict = {str(k): translate_rule_into_autotap_tap(v) for k, v in zip(range(len(rule_list)), rule_list)}
            tap_patch, tap_label = generateNamedFix(ltl, tap_dict, {}, template_dict)
            result_list = expand_autotap_result_into_patches_named(tap_patch, tap_label, is_compact)
            orig_rule_dict = {str(k): backend_to_frontend_view(v) for k, v in zip(range(len(rule_list)), rule_list)}

            json_resp['original'] = orig_rule_dict
            json_resp['patches'] = result_list
        else:
            tap_list = [translate_rule_into_autotap_tap(v) for v in rule_list]
            tap_patch = generateCompactFix(ltl, tap_list, {}, template_dict)
            result_list = expand_autotap_result_into_patches_unnamed(tap_patch, is_compact)
            orig_rule_list = [backend_to_frontend_view(v) for v in rule_list]

            json_resp['original'] = orig_rule_list
            json_resp['patches'] = result_list
        json_resp['succeed'] = True

    except Exception as exc:
        json_resp['patches'] = []
        json_resp['succeed'] = False
        json_resp['fail_exc'] = str(exc)
    return JsonResponse(json_resp)


@csrf_exempt
def trace(request):
    if request.method == 'GET':
        template = loader.get_template('trace.html')
        location_list = m.Location.objects.all()
        location_name_list = [loc.name for loc in location_list]
        return HttpResponse(template.render(context={'location_name_list': location_name_list}))

    elif request.method == 'POST':
        action = request.POST.get('action')
        http_content = ''

        location_name = request.POST.get('location')
        location = m.Location.objects.get(name=location_name)
        template_dict = generate_all_device_templates(location, use_label=True)

        # return JsonResponse(template_dict)
        boolean_map = generate_boolean_map()
        # http_content = http_content + str(template_dict) + '<br>'
        # http_content = http_content + str(boolean_map)

        device_list = m.Device.objects.filter(location=location)
        state_logs = m.StateLog.objects.filter(dev__in=device_list,
                                               status__in=(m.StateLog.HAPPENED, m.StateLog.CURRENT))
        log_list = []
        for state_log in state_logs.order_by('timestamp'):
            if state_log.dev.dev_type == 'v':
                device_name = state_log.dev.name
            else:
                device_name = state_log.dev.label
            event_dict = {
                'time': state_log.timestamp.strftime('%Y-%m-%d %H:%M:%S'),
                'device_id': str(state_log.dev.id),
                'device_name': device_name,
                'capability': state_log.cap.name,
                'attribute': state_log.param.name,
                'current_value': str(state_log.value),
                'is_changed': "true"
            }
            log_list.append(event_dict)

        # result = {'trace': log_list, 'template_dict': template_dict, 'boolean_map': boolean_map}
        # return JsonResponse(result)

        trace = inputTraceFromList(log_list, trunc_none=True, template_dict=template_dict, boolean_map=boolean_map)

        if action == 'Choose Location':
            action_list = list(set([action for _, action in trace.actions
                                    if not check_action_external(action, template_dict)]))
            template = loader.get_template('trace_actuator.html')
            return HttpResponse(template.render(context={'action_list': action_list, 'location': location_name}))

        elif action == 'Choose Action':
            target_action = request.POST.get('action_chosen')
            http_content = http_content + \
                           '<h1>Learning action "%s" in location "%s"</h1>' % (target_action, location_name)
            cap_trigger = listTimingCandidates(trace, target_action, 3, template_dict=template_dict)
            cap_condition = listRelatedCandidates(trace, target_action, 3, template_dict=template_dict)

            cap_time_list = [(cap, time) for cap, time, _ in cap_trigger if time > 1]
            cap_trigger_list = [cap for cap, _, _ in cap_trigger]
            cap_condition_list = [cap for cap, _ in cap_condition]

            cap_list = [cap for cap, _, _ in cap_trigger]
            cap_list = cap_list + [cap for cap, _ in cap_condition]
            cap_list = list(set(cap_list))
            target_cap = target_action.split('=')[0]
            if target_cap not in cap_list:
                cap_list.append(target_cap)

            trace = inputTraceFromList(log_list, trunc_none=True, target_cap_list=cap_list,
                                       template_dict=template_dict, boolean_map=boolean_map)

            new_trace = enhanceTraceWithTiming(trace, cap_time_list)
            #
            # field_name_list = trace.system.getFieldNameList()
            episode_list = extractEpisodes(new_trace, target_action, 
                                           pre_time_span=datetime.timedelta(seconds=settings.PRE_TIME), 
                                           post_time_span=datetime.timedelta(seconds=settings.POST_TIME))
            tap_list = synthesizeTimingRuleBasedOnEpisodesSplit(episode_list, target_action, learning_rate=0.6,
                                                                variable_list=cap_list, trig_var_list=cap_trigger_list,
                                                                cond_var_list=cap_condition_list,
                                                                timing_cap_list=cap_time_list,
                                                                template_dict=template_dict)
            # tap_list = synthesizeTimingRuleBasedOnEpisodes(episode_list, target_action, learning_rate=0.6,
            #                                                template_dict=template_dict, timing_cap_list=cap_time_list)

            score_tap_list = [(calcScore(new_trace, target_action, tap), tap) for tap in tap_list]
            score_tap_list = sorted(score_tap_list, key=lambda x: x[0], reverse=True)

            if len(score_tap_list) > 30:
                score_tap_list = score_tap_list[:30]

            trigger_tap_dict = dict()
            for score, tap in score_tap_list:
                trigger = tap.trigger
                if trigger not in trigger_tap_dict:
                    trigger_tap_dict[trigger] = [(score, tap)]
                else:
                    trigger_tap_dict[trigger].append((score, tap))

            for key in trigger_tap_dict:

                http_content = http_content + '<h2>Trigger: %s, max score=%f</h2>' % (autotapta_formula_to_clause(key, 1, location, True)['text'], trigger_tap_dict[key][0][0][0])
                for ii in range(4):
                    # with ii conditions
                    http_content = http_content + '<h3>Rules with %d conditions</h3>' % ii

                    for score, tap in trigger_tap_dict[key]:
                        if len(tap.condition) == ii:
                            tap_trigger_str = autotapta_formula_to_clause(tap.trigger, 1, location, True)['text']
                            tap_action_str = autotapta_formula_to_clause(tap.action, 2, location, True)['text']
                            tap_conditions = [autotapta_formula_to_clause(cond, 0, location, True)['text']
                                              for cond in tap.condition]
                            tap_condition_str = ' AND '.join(tap_conditions)
                            tap_str = 'IF %s WHILE %s, THEN %s' % (tap_trigger_str, tap_condition_str, tap_action_str) \
                                if tap_conditions \
                                else 'IF %s, THEN %s' % (tap_trigger_str, tap_action_str)
                            http_content = http_content + str(score) + ' ' + tap_str + '<br>'

            # for score, tap in score_tap_list:
            #     tap_trigger_str = autotapta_formula_to_clause(tap.trigger, 1, location, True)['text']
            #     tap_action_str = autotapta_formula_to_clause(tap.action, 2, location, True)['text']
            #     tap_conditions = [autotapta_formula_to_clause(cond, 0, location, True)['text']
            #                       for cond in tap.condition]
            #     tap_condition_str = ' AND '.join(tap_conditions)
            #     tap_str = 'IF %s WHILE %s, THEN %s' % (tap_trigger_str, tap_condition_str, tap_action_str) \
            #         if tap_conditions \
            #         else 'IF %s, THEN %s' % (tap_trigger_str, tap_action_str)
            #     http_content = http_content + str(score) + ' ' + tap_str + '<br>'

        elif action == 'Choose Action':
            pass

        return HttpResponse(http_content)


def cluster_rules(mask_score_tap_list, location):
    if not mask_score_tap_list:
        return [], []  # no cluster if tap list is empty
    # Cluster the rules based on their mask
    mask_list = [mask for mask, _, _, _, _, _ in mask_score_tap_list]
    mask_list = array(mask_list)
    n_cluster, label_list = clusterBitVec(mask_list)

    mask_score_tap_cluster = [[] for _ in range(n_cluster)]
    orig_cluster = [[] for _ in range(n_cluster)]
    for m_s_t_t_f_r, label in zip(mask_score_tap_list, label_list):
        mask, score, tap, TP, FP, R = m_s_t_t_f_r
        f_clause = tap_to_frontend_view_ta(tap, location)
        mask_score_tap_cluster[label].append({'mask': mask, 'score': score, 
                                              'rule': f_clause, 'TP': TP, 'FP': FP, 'R': R})
        orig_cluster[label].append((score, tap))
    
    for cluster, index in zip(mask_score_tap_cluster, range(len(mask_score_tap_cluster))):
        cluster = sorted(cluster, key=lambda x: x['score'], reverse=True)
        mask_score_tap_cluster[index] = cluster
    
    for o_c, index in zip(orig_cluster, range(len(orig_cluster))):
        o_c = sorted(o_c, key=lambda x: x[0], reverse=True)
        orig_cluster[index] = o_c

    mask_score_tap_cluster = sorted(mask_score_tap_cluster, key=lambda x: x[0]['score'], reverse=True)
    orig_cluster = sorted(orig_cluster, key=lambda x: x[0][0], reverse=True)
    return mask_score_tap_cluster, orig_cluster


def suggest_rules_first_time(dev_c, command_c, second_time=False):
    target_dev = m.Device.objects.get(id=dev_c['id'])
    location = target_dev.location

    # Get current rules
    rule_set = m.Rule.objects.filter(st_installed_app_id=location.st_installed_app_id).order_by('id')
    orig_tap_list = [translate_rule_into_autotap_tap(rule, False) for rule in rule_set]

    # Translate trace, gather important information
    # print('stamp 1')
    trace = get_trace_for_location(location)
    # print('stamp 2')
    template_dict = generate_all_device_templates(location, use_label=True)

    # trace = reAssignRangeVariableInTrace(trace, template_dict=template_dict)
    # print('stamp 3')
    
    target_action = pv_clause_to_autotap_statement(dev_c, command_c['capability'], 
                                                command_c['parameter'], command_c['value'])
    orig_tap_list = [tap for tap in orig_tap_list if tap.action == target_action]

    # Select related variables
    cap_trigger = listTimingCandidates(trace, target_action, 6, template_dict=template_dict)
    cap_trigger = cap_trigger[:3] if not second_time else cap_trigger[3:]
    cap_condition = listRelatedCandidates(trace, target_action, 3, template_dict=template_dict)

    cap_time_list = [(cap, time) for cap, time, _ in cap_trigger if time > 1]
    cap_trigger_list = [cap for cap, _, _ in cap_trigger]
    cap_condition_list = [cap for cap, _ in cap_condition]

    cap_list = [cap for cap, _, _ in cap_trigger]
    cap_list = cap_list + [cap for cap, _ in cap_condition]
    cap_list = list(set(cap_list))
    target_cap = target_action.split('=')[0]
    if target_cap not in cap_list:
        cap_list.append(target_cap)

    # print('stamp 4')
    # All sensors that can influence the target action in taps should be added
    orig_tap_time_list = []
    for tap in orig_tap_list:
        if tap.action.startswith(target_cap):
            dev, cap, par, _, _ = split_autotap_formula(tap.trigger)
            orig_tap_time_list += generate_cap_time_list_from_tap(tap)
            cap = dev + '.' + cap + '_' + par
            # if time is not None and (cap, time) not in cap_time_list:
            #     cap_time_list.append((cap, time))
            if cap not in cap_list:
                cap_list.append(cap)
            # if cap not in cap_trigger_list:
            #     cap_trigger_list.append(cap)
            for cond in tap.condition:
                dev, cap, par, _, _ = split_autotap_formula(cond)
                cap = dev + '.' + cap + '_' + par
                if cap not in cap_list:
                    cap_list.append(cap)

    # Get traces only relating to selected variables
    # Should go from trace instead of log_list
    trace = getSubTraceBasedOnCaps(trace, cap_list)
    # filter out the revert actions
    trace = filterFlipping(trace, target_action)
    # enhance with timing
    new_trace = enhanceTraceWithTiming(trace, list(set(cap_time_list+orig_tap_time_list)), '*')

    # print('stamp 5')
    # Gather episodes, and learn
    # TODO: should take away the actions that is triggered by the system
    raw_episode_list = extractEpisodes(new_trace, target_action, 
                                       pre_time_span=datetime.timedelta(seconds=settings.PRE_TIME), 
                                       post_time_span=datetime.timedelta(seconds=settings.POST_TIME))
    episode_list = []
    # take away episodes that are already handled by the current taps

    for episode in raw_episode_list:
        # for tap in orig_tap_list:
        #     if getTriggerTimeInTrace(episode, tap, check_enable=False):
        #         # this trace is handled by existing rules
        #         break
        # else:
        #     # this trace is not handled yet
        #     episode_list.append(episode)
        if not checkIfEpisodeCovered(episode, orig_tap_list, target_action):
            episode_list.append(episode)

    # print('stamp 6')
    mask_tap_list = synthesizeRuleGeneral(episode_list, target_action, learning_rate=settings.LEARNING_RATE_SYN,
                                            variable_list=cap_list, trig_var_list=cap_trigger_list,
                                            cond_var_list=cap_condition_list,
                                            timing_cap_list=cap_time_list,
                                            template_dict=template_dict, tap_list=orig_tap_list)
    if not mask_tap_list and not second_time:
        return suggest_rules_first_time(dev_c, command_c, True)
    # print('stamp 7')

    # Calculate the score of rules (for ranking)
    mask_score_tap_list = []
    for mask, tap in mask_tap_list:
        score, TP, FP, R = calcScoreEnhanced(new_trace, target_action, tap, 
                                             pre_time_span=settings.PRE_TIME, 
                                             post_time_span=settings.POST_TIME)
        mask_score_tap_list.append((mask, score, tap, TP, FP, R))

    # print('stamp 8')
    # Cluster the rules based on their mask
    mask_score_tap_cluster, orig_tap_cluster = cluster_rules(mask_score_tap_list, location)
    json_resp = {'rules': mask_score_tap_cluster}
    json_resp['orig_rules'] = [backend_to_frontend_view(rule) for rule in rule_set 
                               if translate_rule_into_autotap_tap(rule).action == target_action]

    # print('stamp 9')
    # Update cache
    while True:
        cache_token = get_random_string(length=128)
        if cache.get(cache_token) is None:
            break
    cache_entry = {
        'episode_list': episode_list, 
        'orig_trace': trace, 
        'trace': new_trace, 
        'target_action': target_action, 
        'cap_list': cap_list, 
        'cap_trigger_list': cap_trigger_list,
        'cap_condition_list': cap_condition_list,
        'cap_time_list': cap_time_list,
        'template_dict': template_dict,
        'location': location,
        'orig_tap_list': orig_tap_list,
        'orig_rules_frontend': json_resp['orig_rules'],
        'current_rules': orig_tap_cluster,
        'mask_score_tap_cluster': mask_score_tap_cluster
    }
    cache.add(cache_token, cache_entry)
    json_resp['token'] = cache_token
    json_resp['n_episodes'] = len(episode_list)

    # print('stamp 10')

    return json_resp


def suggest_rules_follow_up(mask, token):
    json_resp = dict()
    cache_entry = cache.get(token)
    if cache_entry is None:
        json_resp['cache_found'] = False
        return json_resp
    else:
        json_resp['cache_found'] = True
    episode_list = cache_entry['episode_list']
    new_trace = cache_entry['trace']
    target_action = cache_entry['target_action']
    cap_list = cache_entry['cap_list']
    cap_trigger_list = cache_entry['cap_trigger_list']
    cap_condition_list = cache_entry['cap_condition_list']
    cap_time_list = cache_entry['cap_time_list']
    template_dict = cache_entry['template_dict']
    location = cache_entry['location']
    orig_tap_list = cache_entry['orig_tap_list']
    orig_rules_frontend = cache_entry['orig_rules_frontend']

    mask_tap_list = synthesizeRuleGeneral(episode_list, target_action, learning_rate=0.5,
                                          variable_list=cap_list, trig_var_list=cap_trigger_list,
                                          cond_var_list=cap_condition_list,
                                          timing_cap_list=cap_time_list,
                                          template_dict=template_dict, mask=mask, tap_list=orig_tap_list)

    # Calculate the score of rules (for ranking)
    mask_score_tap_list = []
    for rule_mask, tap in mask_tap_list:
        score, TP, FP, R = calcScoreEnhanced(new_trace, target_action, tap, 
                                             pre_time_span=settings.PRE_TIME, 
                                             post_time_span=settings.POST_TIME)
        mask_score_tap_list.append((rule_mask, score, tap, TP, FP, R))

    # Cluster the rules based on their mask
    mask_score_tap_cluster, orig_tap_cluster = cluster_rules(mask_score_tap_list, location)
    json_resp['rules'] = mask_score_tap_cluster
    json_resp['orig_rules'] = orig_rules_frontend

    cache_entry['current_rules'] = orig_tap_cluster
    cache_entry['mask_score_tap_cluster'] = mask_score_tap_cluster
    cache.set(token, cache_entry)

    return json_resp


def suggestadd(request):
    if request.user.is_authenticated:
        kwargs = json.loads(request.body.decode('utf-8'))
        location = get_location_from_user(request.user)
        try:
            if kwargs['first_time']:
                record_request(kwargs, 'syn_first', location)
                dev_c = kwargs['device']
                command_c = kwargs['command']
                json_resp = suggest_rules_first_time(dev_c, command_c)
                record_response(json_resp, 'syn_first', location)
            else:
                record_request(kwargs, 'syn_followup', location)
                mask = kwargs['mask']
                token = kwargs['token']
                json_resp = suggest_rules_follow_up(mask, token)
                record_response(json_resp, 'syn_followup', location)

            return JsonResponse(json_resp)
            
        except Exception as e:
            raise e
            return JsonResponse({"msg": repr(e)}, status=500)
    else:
        return JsonResponse({"msg": "Please log in first!"}, status=401)


def suggest_debug_first_time(dev_c, command_c):
    target_dev = m.Device.objects.get(id=dev_c['id'])
    location = target_dev.location

    # Get current rules
    rule_set = list(m.Rule.objects.filter(st_installed_app_id=location.st_installed_app_id).order_by('id'))
    orig_tap_list = [translate_rule_into_autotap_tap(rule, use_tick_header=False) for rule in rule_set]

    # Translate trace, gather important information
    trace = get_trace_for_location(location)
    template_dict = generate_all_device_templates(location, use_label=True)
    
    target_action = pv_clause_to_autotap_statement(dev_c, command_c['capability'], 
                                                command_c['parameter'], command_c['value'])

    target_dev_cap = (dev_c['label'] if dev_c['label'] else dev_c['name'], command_c['capability']['name'])
    
    orig_tap_id_list = [rule.id for tap, rule in zip(orig_tap_list, rule_set) if tap.action == target_action]
    orig_rule_dev_cap_list = [get_sensor_dev_cap_django(rule) 
                              for tap, rule in zip(orig_tap_list, rule_set) 
                              if tap.action == target_action]
    orig_tap_list = [tap for tap in orig_tap_list if tap.action == target_action]

    # Select related variables (all in the debugging case)
    cap_list = trace.system.getFieldNameList()
    cap_condition_list = []
    for cap in cap_list:
        dev, par = cap.split('.')
        if 'external' in template_dict[dev][par]:
            cap_condition_list.append(cap)

    # Get all timing information in the triggers
    cap_time_list = []
    target_cap = target_action.split('=')[0]
    for tap in orig_tap_list:
        if tap.action.startswith(target_cap):
            dev, cap, par, _, _ = split_autotap_formula(tap.trigger)
            tap_trigger = tap.trigger[5:-1] if tap.trigger.startswith('tick') else tap.trigger
            if '#' in tap_trigger:
                time = int(tap_trigger.split('#')[0])
            elif '*' in tap_trigger:
                time = int(tap_trigger.split('*')[0])
            else:
                time = None
            if time is not None:
                cap_time_list.append((dev + '.' + cap + '_' + par, time))

    # Get traces only relating to selected variables, enhance with timing
    # Should go from trace instead of log_list
    trace = getSubTraceBasedOnCaps(trace, cap_list)
    new_trace = enhanceTraceWithTiming(trace, cap_time_list, '*')

    # Gather episodes, and learn
    time_event_cond_list, revert_list = extractTriggerCases(new_trace, target_action, tap_list=orig_tap_list)

    delete_dev_cap_list = []
    modify_dev_cap_list = []

    if sum(revert_list):
        delete_patches, modify_patches, delete_rule_masks, modify_rule_masks = \
            debugRuleGeneral(new_trace, time_event_cond_list, revert_list, target_action, learning_rate=0.5,
                             variable_list=cap_list, cond_var_list=cap_condition_list,
                             template_dict=template_dict, tap_list=orig_tap_list)

        modify_patch_meta_list = []
        delete_patch_meta_list = []
        modify_rule_masks = []
        delete_rule_masks = []

        for m_p in modify_patches:
            new_tap_list = modify_patch_to_taps(orig_tap_list, m_p)
            score, TP, FP, mask = calcScoreDebug(new_trace.system, time_event_cond_list, revert_list, new_tap_list)
            modify_patch_meta_list.append((score, TP, FP))
            modify_rule_masks.append(mask)
        for d_p in delete_patches:
            new_tap_list = delete_patch_to_taps(orig_tap_list, d_p)
            score, TP, FP, mask = calcScoreDebug(new_trace.system, time_event_cond_list, revert_list, new_tap_list)
            delete_patch_meta_list.append((score, TP, FP))
            delete_rule_masks.append(mask)
        
        delete = [{'id': orig_tap_id_list[d['index']], 'score': meta[0], 'TP': meta[1], 'FP': meta[2]} 
                  for d, meta in zip(delete_patches, delete_patch_meta_list)]
        delete_dev_cap_list = [orig_rule_dev_cap_list[d['index']] for d in delete_patches]
        modify = []
        for d, meta in zip(modify_patches, modify_patch_meta_list):
            rule_id = orig_tap_id_list[d['index']]
            tap = deepcopy(orig_tap_list[d['index']])
            tap.condition.append(d['new_condition'])
            frontend_tap = tap_to_frontend_view_ta(tap, location)
            frontend_tap['id'] = rule_id
            modify_dev_cap_list.append(get_sensor_dev_cap(frontend_tap))
            modify.append({'id': rule_id, 'rule': frontend_tap, 'score': meta[0], 'TP': meta[1], 'FP': meta[2]})
        
        patches = [{**m, 'typ': 'modify'} for m in modify] + [{**d, 'typ': 'delete'} for d in delete]
        rule_masks = modify_rule_masks + delete_rule_masks
        rule_dev_cap_list = modify_dev_cap_list + delete_dev_cap_list
        comb = [(p, m, dc) for p, m, dc in zip(patches, rule_masks, rule_dev_cap_list)]
        comb = sorted(comb, key=lambda x:x[0]['score'], reverse=True)
        patches = [p for p, _, _ in comb]
        rule_masks = [m for _, m, _ in comb]
        rule_dev_cap_list = [dc for _, _, dc in comb]

    else:
        patches = []
        rule_masks = []

    # Update cache
    while True:
        cache_token = get_random_string(length=128)
        if cache.get(cache_token) is None:
            break
    cache_entry = {
        'trace': new_trace, 
        'target_action': target_action, 
        'cap_list': cap_list, 
        'cap_condition_list': cap_condition_list,
        'template_dict': template_dict,
        'location': location,
        'time_event_cond_list': time_event_cond_list,
        'rule_masks': rule_masks,
        'orig_tap_list': orig_tap_list,
        'rule_dev_cap_list': rule_dev_cap_list,
        'target_dev_cap': target_dev_cap,
        'revert_list': revert_list
    }
    cache.add(cache_token, cache_entry)

    json_resp = dict()
    json_resp['patches'] = patches
    json_resp['rule_masks'] = rule_masks
    json_resp['token'] = cache_token
    json_resp['orig_rules'] = [backend_to_frontend_view(rule) for rule in rule_set 
                               if translate_rule_into_autotap_tap(rule).action == target_action]
    return json_resp


def suggest_debug_follow_up(rules, token):
    json_resp = dict()
    cache_entry = cache.get(token)
    if cache_entry is None:
        json_resp['cache_found'] = False
        return json_resp
    else:
        json_resp['cache_found'] = True
    new_trace = cache_entry['trace']
    target_action = cache_entry['target_action']
    cap_list = cache_entry['cap_list']
    cap_condition_list = cache_entry['cap_condition_list']
    template_dict = cache_entry['template_dict']
    orig_tap_list = [translate_clause_into_autotap_tap(rule, False) for rule in rules]
    orig_rule_dev_cap_list = [get_sensor_dev_cap(rule) for rule in rules]
    orig_tap_id_list = [rule['id'] for rule in rules]
    location = cache_entry['location']
    
    # Gather episodes, and learn
    time_event_cond_list, revert_list = extractTriggerCases(new_trace, target_action, tap_list=orig_tap_list)

    delete_dev_cap_list = []
    modify_dev_cap_list = []

    if sum(revert_list):
        delete_patches, modify_patches, delete_rule_masks, modify_rule_masks = \
            debugRuleGeneral(new_trace, time_event_cond_list, revert_list, target_action, learning_rate=0.5,
                             variable_list=cap_list, cond_var_list=cap_condition_list,
                             template_dict=template_dict, tap_list=orig_tap_list)
        
        modify_patch_meta_list = []
        delete_patch_meta_list = []
        modify_rule_masks = []
        delete_rule_masks = []
        for m_p in modify_patches:
            new_tap_list = modify_patch_to_taps(orig_tap_list, m_p)
            score, TP, FP, mask = calcScoreDebug(new_trace.system, time_event_cond_list, revert_list, new_tap_list)
            modify_patch_meta_list.append((score, TP, FP))
            modify_rule_masks.append(mask)
        for d_p in delete_patches:
            new_tap_list = delete_patch_to_taps(orig_tap_list, d_p)
            score, TP, FP, mask = calcScoreDebug(new_trace.system, time_event_cond_list, revert_list, new_tap_list)
            delete_patch_meta_list.append((score, TP, FP))
            delete_rule_masks.append(mask)

        delete = [{'id': orig_tap_id_list[d['index']], 'score': meta[0], 'TP': meta[1], 'FP': meta[2]} 
                  for d, meta in zip(delete_patches, delete_patch_meta_list)]
        delete_dev_cap_list = [orig_rule_dev_cap_list[d['index']] for d in delete_patches]
        modify = []
        for d, meta in zip(modify_patches, modify_patch_meta_list):
            rule_id = orig_tap_id_list[d['index']]
            tap = deepcopy(orig_tap_list[d['index']])
            tap.condition.append(d['new_condition'])
            frontend_tap = tap_to_frontend_view_ta(tap, location)
            frontend_tap['id'] = rule_id
            modify_dev_cap_list.append(get_sensor_dev_cap(frontend_tap))
            modify.append({'id': rule_id, 'rule': frontend_tap, 'score': meta[0], 'TP': meta[1], 'FP': meta[2]})

        patches = [{**m, 'typ': 'modify'} for m in modify] + [{**d, 'typ': 'delete'} for d in delete]
        rule_masks = modify_rule_masks + delete_rule_masks
        rule_dev_cap_list = modify_dev_cap_list + delete_dev_cap_list
        comb = [(p, m, dc) for p, m, dc in zip(patches, rule_masks, rule_dev_cap_list)]
        comb = sorted(comb, key=lambda x:x[0]['score'], reverse=True)
        patches = [p for p, _, _ in comb]
        rule_masks = [m for _, m, _ in comb]
        rule_dev_cap_list = [dc for _, _, dc in comb]
    else:
        patches = []
        rule_masks = []
    
    # update cache
    cache_entry['time_event_cond_list'] = time_event_cond_list
    cache_entry['rule_masks'] = rule_masks
    cache_entry['rule_dev_cap_list'] = rule_dev_cap_list
    cache.set(token, cache_entry)

    json_resp['patches'] = patches
    json_resp['rule_masks'] = rule_masks
    json_resp['token'] = token
    return json_resp


def suggestdebug(request):
    if request.user.is_authenticated:
        kwargs = json.loads(request.body.decode('utf-8'))
        location = get_location_from_user(request.user)
        try:
            if kwargs['first_time']:
                record_request(kwargs, 'debug_first', location)
                dev_c = kwargs['device']
                command_c = kwargs['command']
                json_resp = suggest_debug_first_time(dev_c, command_c)
                record_response(json_resp, 'debug_first', location)
            else:
                record_request(kwargs, 'debug_followup', location)
                token = kwargs['token']
                rules = kwargs['rules']
                json_resp = suggest_debug_follow_up(rules, token)
                record_response(json_resp, 'debug_followup', location)

            return JsonResponse(json_resp)
            
        except Exception as e:
            raise e
            return JsonResponse({"msg": repr(e)}, status=500)
    else:
        return JsonResponse({"msg": "Please log in first!"}, status=401)


def _get_autotap_cap_from_state_log(state_log):
    dev_name = state_log.dev.name if state_log.dev.dev_type == 'v' else state_log.dev.label
    cap_name = state_log.cap.name
    param_name = state_log.param.name
    autotap_dev_name = dev_name_to_autotap(dev_name)
    autotap_cap_name = cap_name_to_autotap(cap_name)
    autotap_param_name = var_name_to_autotap(param_name)
    return autotap_dev_name + '.' + autotap_cap_name + '_' + autotap_param_name


def getepisode(request):
    if request.user.is_authenticated:
        kwargs = json.loads(request.body.decode('utf-8'))
        # mask = kwargs['mask']
        token = kwargs['token']
        cache_entry = cache.get(token)
        episode_list = cache_entry['episode_list']
        location = cache_entry['location']
        cap_list = cache_entry['cap_list']
        orig_tap_list = cache_entry['orig_tap_list']
        target_action = cache_entry['target_action']
        trace = cache_entry['orig_trace']

        # state_logs = m.StateLog.objects.filter(loc=location)
        # state_logs = state_logs.filter(status__in=(m.StateLog.HAPPENED, m.StateLog.CURRENT))
        tap_cluster = cache_entry['current_rules']
        tap_cluster = [[tap for _, tap in tap_c] for tap_c in tap_cluster]
        mask_score_tap_cluster = cache_entry['mask_score_tap_cluster']

        log_list = []

        # step 1: enhance with time (new rules and existing rules)
        cap_time_list = list()
        for tap in orig_tap_list:
            cap_time_list += generate_cap_time_list_from_tap(tap)
        for tap_c in tap_cluster:
            cap_time_list += generate_cap_time_list_from_tap(tap_c[0])
        cap_time_list = list(set(cap_time_list))
        trace = enhanceTraceWithTiming(trace, cap_time_list, '*')
        
        # step 2: first pass, go through each action in the trace, find time clips
        #   step 2.1: get times
        episode_list = extractEpisodes(trace, target_action, 
                                       pre_time_span=datetime.timedelta(seconds=settings.PRE_TIME), 
                                       post_time_span=datetime.timedelta(seconds=settings.POST_TIME))
        # Those episode lists are TPs and FNs
        episode_list = [episode for episode in episode_list 
                           if not checkIfEpisodeCovered(episode, orig_tap_list, target_action)]
        manual_time_list, automation_list, orig_trigger_list, new_trigger_cluster_list = \
            extractOrigNewTriggerTimes(trace, target_action, orig_tap_list, tap_cluster)
        #   step 2.2: merge automation_list and orig_trigger_list
        merged_orig_trigger_list = merge_times(automation_list, orig_trigger_list, 
                                        diff=datetime.timedelta(seconds=2))
        #   step 2.3: evaluate "manual_time_list, orig_trigger_list, 
        #             new_trigger_cluster_list", get time clips
        new_trigger_cluster_list_n = []
        for cluster in new_trigger_cluster_list:
            new_trigger_cluster_list_n += cluster
        time_list = new_trigger_cluster_list_n
        time_list = sorted(time_list)
        time_negative_list = []
        for time in time_list:
            if not any([episode.start_time <= time < episode.end_time 
                        for episode in episode_list]):
                time_negative_list.append(time)
        # Those time clips are TPs and FPs
        time_clips = find_time_clips(time_negative_list, span=datetime.timedelta(minutes=2))  # each entry: (start_time, end_time)
        episode_negative_list = []
        for start_time, end_time in time_clips:
            clip = generate_clip(trace, start_time, end_time)
            episode_negative_list.append(clip)
        episode_positive_list = episode_list

        # step 3: second pass, translate every time clip into the final format for vis
        #   step 3.1: probably need to build a map between autotap format to the clause format.
        #               we may also need value maps?
        rev_map = generate_reverse_template(loc=location)
        #   step 3.2: evaluate trace for each time clips, translate
        tap_clips_shown_positive = [[] for _ in tap_cluster]
        tap_clips_shown_negative = [[] for _ in tap_cluster]
        orig_trigger_list_t = [(time, -1) for time in orig_trigger_list]
        new_trigger_cluster_list_t = []
        for index in range(len(new_trigger_cluster_list)):
            new_trigger_cluster_list_t += [(time, index) for time in new_trigger_cluster_list[index]]
        new_trigger_cluster_list_t = sorted(new_trigger_cluster_list_t)
        time_list_t = sorted(orig_trigger_list_t + new_trigger_cluster_list_t)
        time_dict_positive_list = []
        for episode_index in range(len(episode_positive_list)):
            episode = episode_positive_list[episode_index]
            time_dict, shown_new_tap = translate_time_clip(episode, target_action, time_list_t, 
                                                           n_new_tap=len(tap_cluster), rev_map=rev_map)
            for tap_index in shown_new_tap:
                tap_clips_shown_positive[tap_index].append(episode_index)
            time_dict_positive_list.append(time_dict)
        time_dict_negative_list = []
        for episode_index in range(len(episode_negative_list)):
            episode = episode_negative_list[episode_index]
            time_dict, shown_new_tap = translate_time_clip(episode, target_action, time_list_t, 
                                                           n_new_tap=len(tap_cluster), rev_map=rev_map)
            for tap_index in shown_new_tap:
                tap_clips_shown_negative[tap_index].append(episode_index)
            time_dict_negative_list.append(time_dict)

        # step 4: mark sensor id shown up in rules, mark target action id
        name_translate = lambda dev: dev.name if dev.dev_type == 'v' else dev.label
        dev_list = [name_translate(rev_map[cap][0]) for cap in trace.system.getFieldNameList()]
        cap_list = [rev_map[cap][1].name for cap in trace.system.getFieldNameList()]
        dev_cap_list = [(dev, cap) for dev, cap in zip(dev_list, cap_list)]
        rule_sensor_list = []
        for clause_cluster in mask_score_tap_cluster:
            rule_clause = clause_cluster[0]['rule']
            d_c_list = get_sensor_dev_cap(rule_clause)
            rule_sensor_list.append([dev_cap_list.index(d_c) for d_c in d_c_list])
        target_id = trace.system.getFieldNameList().index(target_action.split('=')[0])
        
        json_resp = {'log_positive_list': parse_trace_new(time_dict_positive_list), 
                     'log_negative_list': parse_trace_new(time_dict_negative_list),
                     'tap_clips_shown_positive': tap_clips_shown_positive,
                     'tap_clips_shown_negative': tap_clips_shown_negative,
                     'dev_list': dev_list, 
                     'cap_list': cap_list, 'rule_sensor_list': rule_sensor_list,
                     'target_id': target_id} # parse log as HTML
        
        return JsonResponse(json_resp)
    else:
        return JsonResponse({"msg": "Please log in first!"}, status=401)


def getepisode_debug(request):
    if request.user.is_authenticated:
        kwargs = json.loads(request.body.decode('utf-8'))
        token = kwargs['token']
        cache_entry = cache.get(token)

        time_event_cond_list = cache_entry['time_event_cond_list']
        revert_list = cache_entry['revert_list']
        rule_masks = cache_entry['rule_masks']
        rule_dev_cap_list = cache_entry['rule_dev_cap_list']
        location = cache_entry['location']
        target_action = cache_entry['target_action']
        trace = cache_entry['trace']  # should be enhanced with timing
        rev_map = generate_reverse_template(loc=location)

        dev_cap_list = []
        trace_vis_list = []

        time_window = datetime.timedelta(seconds=settings.VIS_DEBUG)
        time_dict_list = []
        for time, event, _ in time_event_cond_list:
            episode = generate_clip(trace, time-time_window, time+time_window)
            event_id = episode.actions.index((time, event))
            action_id = -1
            for ii in range(event_id+1, len(episode.actions)):
                if not episode.is_ext_list[ii] and episode.actions[ii][1] == target_action:
                    action_id = ii
                    break
            time_dict = translate_time_clip_debug(episode, action_id, rev_map)
            time_dict_list.append(time_dict)

        trace_vis_list = parse_trace_new(time_dict_list)

        name_translate = lambda dev: dev.name if dev.dev_type == 'v' else dev.label
        device_list = [name_translate(rev_map[cap][0]) for cap in trace.system.getFieldNameList()]
        capability_list = [rev_map[cap][1].name for cap in trace.system.getFieldNameList()]
        dev_cap_list = [(dev, cap) for dev, cap in zip(device_list, capability_list)]
        target_dev_cap_id = trace.system.getFieldNameList().index(target_action.split('=')[0])

        rule_sensor_list = []
        for d_c_l in rule_dev_cap_list:
            sensor_list = []
            for dev, cap in d_c_l:
                index = dev_cap_list.index((dev, cap))
                if index != target_dev_cap_id:
                    sensor_list.append(index)
            rule_sensor_list.append(sensor_list)

        trace_vis_list_positive = []
        trace_vis_list_negative = []
        rule_mask_positive = [[] for _ in rule_masks]
        rule_mask_negative = [[] for _ in rule_masks]
        for index in range(len(trace_vis_list)):
            trace_vis = trace_vis_list[index]
            reverted = revert_list[index]
            if reverted:  # should be handled
                trace_vis_list_positive.append(trace_vis)
                for rule_id in range(len(rule_masks)):
                    rule_mask_positive[rule_id].append(rule_masks[rule_id][index])
            else:
                trace_vis_list_negative.append(trace_vis)
                for rule_id in range(len(rule_masks)):
                    rule_mask_negative[rule_id].append(rule_masks[rule_id][index])

        json_resp = {'log_list_positive': trace_vis_list_positive, 'log_list_negative': trace_vis_list_negative, 
                     'dev_list': device_list, 'cap_list': capability_list, 
                     'rule_sensor_list': rule_sensor_list, 'target_id': target_dev_cap_id, 
                     'rule_mask_positive': rule_mask_positive, 'rule_mask_negative': rule_mask_negative} # parse log as HTML
        return JsonResponse(json_resp)
    else:
        return JsonResponse({"msg": "Please log in first!"}, status=401)


@csrf_exempt
def getcache(request):
    cache_entry = cache.get('ZvvaBF1RBTUdP5BmxNytIc4viwmtoMjaWKS6Ia0cQm3o4Lko4cN6HQZBCpG9Z6XER05xpHG8XzKMpn2bC4Gvi6d224jhAcc07ck7AqaRqOMLKBxSRbknLWzgLhHPwT5W')
    episode_list = cache_entry['episode_list']
    new_trace = cache_entry['trace']
    target_action = cache_entry['target_action']
    cap_list = cache_entry['cap_list']
    cap_trigger_list = cache_entry['cap_trigger_list']
    cap_condition_list = cache_entry['cap_condition_list']
    cap_time_list = cache_entry['cap_time_list']
    template_dict = cache_entry['template_dict']
    location = cache_entry['location']
    
    mask = [
        True,
        True,
        False,
        True,
        False,
        True,
        False,
        True,
        True,
        True,
        True,
        False,
        True,
        True,
        False,
        False,
        False,
        False,
        True,
        True,
        True,
        True,
        False,
        True,
        True,
        True,
        False,
        True,
        False,
        True,
        False,
        False,
        False,
        False,
        False,
        False,
        True
    ]
    mask_tap_list = synthesizeRuleGeneral(episode_list, target_action, learning_rate=0.5,
                                          variable_list=cap_list, trig_var_list=cap_trigger_list,
                                          cond_var_list=cap_condition_list,
                                          timing_cap_list=cap_time_list,
                                          template_dict=template_dict, mask=mask)
    
    episode = cache_entry['episode_list'][5]
    for mask, tap in mask_tap_list:
        print(tap, mask)
    raise Exception('setting: %d', settings.DEBUG)
    return JsonResponse({})


@csrf_exempt
def revert(request):
    if request.method == 'GET':
        template = loader.get_template('revert.html')
        location_list = m.Location.objects.all()
        location_name_list = [loc.name for loc in location_list]
        return HttpResponse(template.render(context={'location_name_list': location_name_list}))

    elif request.method == 'POST':
        location_name = request.POST.get('location')
        location = m.Location.objects.get(name=location_name)

        device_list = m.Device.objects.filter(location=location)
        state_logs = m.StateLog.objects.filter(dev__in=device_list,
                                               status__in=(m.StateLog.HAPPENED, m.StateLog.CURRENT))
        automation_queue = list()

        http_content = ''
        for state_log in state_logs.order_by('timestamp'):
            if state_log.status in (m.StateLog.HAPPENED, m.StateLog.CURRENT):
                while automation_queue and state_log.timestamp - automation_queue[0].timestamp > datetime.timedelta(seconds=120):
                    automation_queue.pop(0)
                
                if state_log.is_superifttt:
                    automation_queue.append(state_log)
                else:
                    for sl in automation_queue:
                        if sl.param == state_log.param and sl.value != state_log.value and sl.dev == state_log.dev:
                            relevant_sl_list = m.StateLog.objects.filter(timestamp__gte=sl.timestamp-datetime.timedelta(seconds=300), 
                                                                         timestamp__lte=state_log.timestamp, 
                                                                         dev__in=device_list, 
                                                                         status__in=(m.StateLog.HAPPENED, m.StateLog.CURRENT)).order_by('timestamp')
                            for rsl in relevant_sl_list:
                                time_rsl = rsl.timestamp.replace(tzinfo=timezone('UTC'))
                                time_rsl = time_rsl.astimezone(timezone('US/Central'))
                                event_dict_rsl = {
                                    'time': time_rsl.strftime('%Y-%m-%d %H:%M:%S %Z%z'),
                                    'device_id': str(rsl.dev.id),
                                    'device_name': rsl.dev.name if rsl.dev.dev_type == 'v' else rsl.dev.label,
                                    'capability': rsl.cap.name,
                                    'attribute': rsl.param.name,
                                    'current_value': str(rsl.value)
                                }
                                http_content = http_content + str(event_dict_rsl) + '<br>'
                            # time_auto = sl.timestamp.replace(tzinfo=timezone('UTC'))
                            # time_revert = state_log.timestamp.replace(tzinfo=timezone('UTC'))

                            # event_dict_auto = {
                            #     'time': time_auto.astimezone(timezone('US/Central')).strftime('%Y-%m-%d %H:%M:%S %Z%z'),
                            #     'device_id': str(sl.dev.id),
                            #     'device_name': sl.dev.name if sl.dev.dev_type == 'v' else sl.dev.label,
                            #     'capability': sl.cap.name,
                            #     'attribute': sl.param.name,
                            #     'current_value': str(sl.value)
                            # }
                            # event_dict_revert = {
                            #     'time': time_revert.astimezone(timezone('US/Central')).strftime('%Y-%m-%d %H:%M:%S %Z%z'),
                            #     'device_id': str(state_log.dev.id),
                            #     'device_name': state_log.dev.name if state_log.dev.dev_type == 'v' else state_log.dev.label,
                            #     'capability': state_log.cap.name,
                            #     'attribute': state_log.param.name,
                            #     'current_value': str(state_log.value)
                            # }
                            # http_content = http_content + str(event_dict_auto) + '<br>'
                            # http_content = http_content + str(event_dict_revert) + '<br>'

                            http_content = http_content + '-------------------------------' + '<br>'

        return HttpResponse(http_content)


@csrf_exempt
def gettrace(request):
    if request.method == 'GET':
        template = loader.get_template('gettrace.html')
        location_list = m.Location.objects.all()
        location_name_list = [loc.name for loc in location_list]
        return HttpResponse(template.render(context={'location_name_list': location_name_list}))

    elif request.method == 'POST':
        location_name = request.POST.get('location')
        location = m.Location.objects.get(name=location_name)
        template_dict = generate_all_device_templates(location, use_label=True)
        boolean_map = generate_boolean_map()

        device_list = m.Device.objects.filter(location=location)
        state_logs = m.StateLog.objects.filter(dev__in=device_list,
                                               status__in=(m.StateLog.HAPPENED, m.StateLog.CURRENT))

        log_list = list()
        for state_log in state_logs.order_by('timestamp'):
            if state_log.status in (m.StateLog.HAPPENED, m.StateLog.CURRENT):
                time_sl = state_log.timestamp.replace(tzinfo=timezone('UTC'))
                time_sl = time_sl.astimezone(timezone('US/Central'))
                event_dict_sl = {
                                    'time': time_sl.strftime('%Y-%m-%d %H:%M:%S'),
                                    'device_id': str(state_log.dev.id),
                                    'device_name': state_log.dev.name if state_log.dev.dev_type == 'v' else state_log.dev.label,
                                    'capability': state_log.cap.name,
                                    'attribute': state_log.param.name,
                                    'current_value': str(state_log.value),
                                    'external': not state_log.is_superifttt
                                }
                log_list.append(event_dict_sl)
               
        result = {'trace': log_list, 'template_dict': template_dict, 'boolean_map': boolean_map}
        return JsonResponse(result)


def get_revert_for_location(request):
    if request.user.is_authenticated and request.user.is_superuser:
        kwargs = json.loads(request.body.decode('utf-8'))
        loc_id = kwargs['loc_id']
        location = m.Location.objects.get(id=loc_id)
        template_dict = generate_all_device_templates(location, use_label=True)
        boolean_map = generate_boolean_map()
        trace = get_trace_for_location(location)
        devs = m.Device.objects.filter(location=location)
        rule_set = m.Rule.objects.filter(st_installed_app_id=location.st_installed_app_id).order_by('id')
        orig_tap_list = [translate_rule_into_autotap_tap(rule, use_tick_header=False) for rule in rule_set]
        cap_time_list = []
        for tap in orig_tap_list:
            cap_time_list += generate_cap_time_list_from_tap(tap)
        cap_time_list = list(set(cap_time_list))
        trace = enhanceTraceWithTiming(trace, cap_time_list, '*')

        commands = []
        devices = []
        for dev in devs:
            command_tup_list = get_dev_commands(dev, trace=trace, template_dict=template_dict, 
                                                boolean_map=boolean_map, orig_tap_list=orig_tap_list)
            for cap, param, val, count, covered, reverted in command_tup_list:
                if reverted:
                    command = {
                        "capability": {"id": cap.id, "name": cap.name, "label": cap.commandlabel}, 
                        "parameter": {"id": param.id, "name": param.name, "type": param.type, "values": get_param_vals(param)}, 
                        "value": val, "count": count, "covered": covered, 'reverted': reverted
                    }
                    commands.append(command)
        
        return JsonResponse({'commands': commands}, status=200)
    else:
        return JsonResponse({"msg": "You need to log in as a superuser!"}, status=401)


def get_revert_action(request):
    if request.user.is_authenticated and request.user.is_superuser:
        kwargs = json.loads(request.body.decode('utf-8'))
        device_id = kwargs['device']['id']
        device = m.Device.objects.get(id=device_id)
        location = device.location
        trace = get_trace_for_location(location)
        target_action = pv_clause_to_autotap_statement(kwargs['device'], kwargs['command']['capability'], 
                                                       kwargs['command']['parameter'], kwargs['command']['value'])

        # Generate items for translation
        rev_map = generate_reverse_template(loc=location)

        # Enhance trace with timing
        rule_set = m.Rule.objects.filter(st_installed_app_id=location.st_installed_app_id).order_by('id')
        orig_tap_list = [translate_rule_into_autotap_tap(rule, use_tick_header=False) for rule in rule_set]
        orig_tap_list = [tap for tap in orig_tap_list if tap.action == target_action]
        cap_time_list = []
        for tap in orig_tap_list:
            cap_time_list += generate_cap_time_list_from_tap(tap)
        cap_time_list = list(set(cap_time_list))
        trace = enhanceTraceWithTiming(trace, cap_time_list, '*')

        # Get dev/cap names
        name_translate = lambda dev: dev.name if dev.dev_type == 'v' else dev.label
        device_list = [name_translate(rev_map[cap][0]) for cap in trace.system.getFieldNameList()]
        capability_list = [rev_map[cap][1].name for cap in trace.system.getFieldNameList()]
        target_dev_cap_id = trace.system.getFieldNameList().index(target_action.split('=')[0])

        # Extract revert cases
        time_window = datetime.timedelta(seconds=settings.VIS_DEBUG)
        revert_time_list = extractRevertCases(trace, target_action)
        time_dict_list = []

        for time in revert_time_list:
            episode = generate_clip(trace, time-time_window, time+time_window)
            event_id = episode.actions.index((time, target_action))
            time_dict = translate_time_clip_debug(episode, event_id, rev_map)
            time_dict_list.append(time_dict)

        trace_vis_list = parse_trace_new(time_dict_list)
        json_resp = {'log_list': trace_vis_list, 'dev_list': device_list, 
                     'cap_list': capability_list, 'target_id': target_dev_cap_id}
        return JsonResponse(json_resp, status=200)
    else:
        return JsonResponse({"msg": "You need to log in as a superuser!"}, status=401)


def get_manual_changes(request):
    if request.user.is_authenticated and request.user.is_superuser:
        kwargs = json.loads(request.body.decode('utf-8'))
        location = m.Location.objects.get(id=kwargs['loc_id'])
        all_records = m.Record.objects.filter(typ='edit_rule', location=location).order_by('timestamp')
        resp_list = []
        for record in all_records:
            if record.response:
                resp = json.loads(record.response)
                resp['time'] = record.timestamp
                if 'loc_id' in resp and resp['loc_id'] == location.id:
                    resp_list.append(resp)

        json_resp = {'resp_list': resp_list}
        return JsonResponse(json_resp, status=200)
    else:
        return JsonResponse({"msg": "You need to log in as a superuser!"}, status=401)


def get_debug_pages(request):
    if request.user.is_authenticated and request.user.is_superuser:
        kwargs = json.loads(request.body.decode('utf-8'))
        location = m.Location.objects.get(id=kwargs['loc_id'])
        all_records = m.Record.objects.filter(typ__in=('debug_first', 'debug_followup'), location=location).order_by('timestamp')
        resp_list = []
        for record in all_records:
            if record.response:
                resp = json.loads(record.response)
                resp['time'] = str(record.timestamp)
                resp_list.append(resp)
        json_resp = {'resp_list': resp_list}
        return JsonResponse(json_resp, status=200)
    else:
        return JsonResponse({"msg": "You need to log in as a superuser!"}, status=401)
