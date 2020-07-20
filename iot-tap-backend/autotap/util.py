from django.shortcuts import render

# Create your views here.
from django.http import HttpResponse, JsonResponse
from django.template import loader
from django.core.cache import cache, caches
from django.utils.crypto import get_random_string
import backend.models as m
import os, sys
from autotapta.input.IoTCore import inputTraceFromList, updateTraceFromList
from autotapta.model.Trace import Trace
from autotapmc.model.Tap import Tap

from django.conf import settings
from django.utils.timezone import make_aware
from django.views.decorators.csrf import csrf_exempt
from autotap.variable import find_closest_color
from autotap.variable import generate_all_device_templates, generate_boolean_map

import itertools
import json
import datetime
from numpy import array
from pytz import timezone


def generate_dict_from_state_log(state_log, cluster=False):
    if not cluster:
        value = state_log.value
    else:
        param = state_log.param
        cap = state_log.cap
        dev = state_log.dev
        
        if param.type == 'range':
            range_seps = m.RangeCounter.objects.filter(param=param, cap=cap, dev=dev, 
                                                       min__lte=float(state_log.value), 
                                                       max__gt=float(state_log.value))
            if range_seps:
                # should be only one
                range_sep = list(range_seps)[0]
                value = range_sep.representative
            else:
                value = state_log.value
        elif param.type == 'color':
            color_name = find_closest_color(state_log.value)
            value = color_name
        else:
            value = state_log.value
    
    result = {
        'time': state_log.timestamp.strftime('%Y-%m-%d %H:%M:%S'),
        'device_id': str(state_log.dev.id),
        'device_name': state_log.dev.name if state_log.dev.dev_type == 'v' else state_log.dev.label,
        'capability': state_log.cap.name,
        'attribute': state_log.param.name,
        'current_value': str(value),
        'external': not state_log.is_superifttt, 
        'is_changed': "true"
    }
    return result        


def update_trace_in_cache(state_log):
    location = state_log.loc
    trace_cache = caches['trace']
    cached_trace = trace_cache.get(str(location.id))

    if cached_trace is None:
        initialize_trace_for_location(state_log.loc, rewrite=False)
    else:
        # Get old logs
        template_dict = cached_trace['template_dict']
        boolean_map = cached_trace['boolean_map']
        trace = cached_trace['trace']
        # Get new logs
        log_list = [generate_dict_from_state_log(state_log, cluster=True)]

        # Insert new logs into old ones
        trace = updateTraceFromList(trace, log_list, template_dict=template_dict, 
                                    boolean_map=boolean_map, if_disting_ext=True)
        # Store new trace into cache
        cached_trace['trace'] = trace
        cached_trace['timestamp'] = state_log.timestamp

        trace_cache.set(str(location.id), cached_trace)
        
        return trace


def initialize_trace_for_location(loc, rewrite=True):
    trace_cache = caches['trace']
    if not rewrite and trace_cache.get(str(loc.id)) is not None:
        return None
    # Fetch logs from the database
    state_logs = m.StateLog.objects.filter(loc=loc)
    state_logs = state_logs.filter(status__in=(m.StateLog.HAPPENED, m.StateLog.CURRENT)).order_by('timestamp')

    log_list = [generate_dict_from_state_log(state_log, cluster=True) for state_log in state_logs.iterator()]
    
    # Translate trace, gather important information
    template_dict = generate_all_device_templates(loc, use_label=True)
    boolean_map = generate_boolean_map()
    trace = inputTraceFromList(log_list, trunc_none=True, 
                            template_dict=template_dict, boolean_map=boolean_map, if_disting_ext=True)
    # Store information in cache
    cached_trace = {
        'template_dict': template_dict, 
        'boolean_map': boolean_map, 
        'timestamp': datetime.datetime.now(), 
        'trace': trace
    }
    trace_cache.set(str(loc.id), cached_trace)
    return trace


def get_trace_for_location(location):
    trace_cache = caches['trace']
    cached_trace = trace_cache.get(str(location.id))
    if cached_trace is None:
        trace = initialize_trace_for_location(location)
    else:
        trace = cached_trace['trace']
    return trace


def get_sensor_dev_cap(rule_clause):
    result = []
    for if_clause in rule_clause['ifClause']:
        dev_clause = if_clause['device']
        cap_clause = if_clause['capability']
        dev_name = dev_clause['name'] if not dev_clause['label'] else dev_clause['label']

        if dev_clause['name'] != 'Clock':
            result.append((dev_name, cap_clause['name']))
        else:
            for par, par_val in zip(if_clause['parameters'], if_clause['parameterVals']):
                if par['type'] == 'meta':
                    d_c = par_val['value']['device']
                    c_c = par_val['value']['capability']
                    d_name = d_c['name'] if not d_c['label'] else d_c['label']
                    result.append((d_name, c_c['name']))
    
    return result


def get_action_dev_cap(rule_clause):
    then_clause = rule_clause['thenClause'][0]
    dev_clause = then_clause['device']
    cap_clause = then_clause['capability']
    dev_name = dev_clause['name'] if not dev_clause['label'] else dev_clause['label']
    return dev_name, cap_clause['name']


def get_sensor_dev_cap_django(rule):
    result = []
    esrule = rule.esrule

    for trigger in [esrule.Etrigger] + list(esrule.Striggers.all()):
        dev = trigger.dev
        cap = trigger.cap
        dev_name = dev.name if not dev.label else dev.label

        if dev.name != 'Clock':
            result.append((dev_name, cap.name))
        else:
            conditions = m.Condition.objects.filter(trigger=trigger)
            for condition in conditions:
                par = condition.par
                val = condition.val
                if par.type == 'meta':
                    val_clause = json.loads(val.replace('\'', '\"'))
                    d_c = val_clause['device']
                    c_c = val_clause['capability']
                    d_name = d_c['name'] if not d_c['label'] else d_c['label']
                    result.append((d_name, c_c['name']))
    
    return result


def get_action_dev_cap_django(rule):
    esrule = rule.esrule
    action = esrule.action
    dev = action.dev
    cap = action.cap
    dev_name = dev.name if not dev.label else dev.label
    return dev_name, cap.name


def merge_times(primary_list, secondary_list, diff):
    """
    merge two time lists
    for each time in the secondary list, 
    if exist a time in the primary list that is really close, don't put into final list
    """
    if not primary_list:
        return secondary_list
    if not secondary_list:
        return primary_list
    
    index_p = 0
    index_s = 0

    n_p = len(primary_list)
    n_s = len(secondary_list)

    final_list = []

    while index_p != n_p - 1 or index_s != n_s - 1:
        if index_p != n_p - 1 and index_s != n_s - 1:
            if primary_list[index_p] < secondary_list[index_s]:
                final_list.append(primary_list[index_p])
                index_p += 1
            else:
                if secondary_list[index_s] - primary_list[index_p] < diff and \
                    -diff < secondary_list[index_s] - primary_list[index_p+1] < diff:
                    index_s += 1
                else:
                    final_list.append(secondary_list[index_s])
                    index_s += 1
        elif index_p != n_p - 1:
            final_list.append(primary_list[index_p])
            index_p += 1
        elif index_s != n_s - 1:
            if secondary_list[index_s] - primary_list[n_p-1] < diff:
                index_s += 1
            else:
                final_list.append(secondary_list[index_s])
                index_s += 1
        else:
            break
    
    return final_list


def find_time_clips(time_list, span):
    """
    given a time_list, find time clips that cover all of them
    """
    holding_starting_time = None
    current_time = None
    time_clips = []

    for time in time_list:
        if holding_starting_time is None:
            holding_starting_time = time - span
            current_time = time
        else:
            if time > current_time + span:
                time_clips.append((holding_starting_time, current_time + span))
                holding_starting_time = time - span
                current_time = time
            else:
                current_time = time
    
    if holding_starting_time is not None:
        time_clips.append((holding_starting_time, current_time + span))
    
    return time_clips


def generate_clip(trace, start_time, end_time):
    # extract all actions that is within time range
    actions_index = [(index, action_tup)
                        for action_tup, index in zip(trace.actions, range(len(trace.actions)))
                        if action_tup[0] >= start_time and action_tup[0] < end_time]
    if not actions_index:
        post_index = [(index, action_tup)
                      for action_tup, index in zip(trace.actions, range(len(trace.actions)))
                      if action_tup[0] >= start_time]
        if not post_index:
            # should be using the final state
            if trace.actions:
                trace.system.restoreFromStateVector(trace.pre_condition[-1])
                if '*' not in trace.actions[-1][1] and '#' not in trace.actions[-1][1]:
                    trace.system.applyAction(trace.actions[-1][1])
                initial_state = trace.system.saveToStateVector()
            else:
                initial_state = trace.initial_state
            initial_actions = []
        else:
            # should be using the pre_cond
            initial_state = trace.pre_condition[post_index[0][0]]
            initial_actions = []
    else:
        # extract informations of those actions
        indexs = [index for index, _ in actions_index]
        actions = [action_tup for _, action_tup in actions_index]
        is_ext_list = [trace.is_ext_list[index] for index in indexs]
        initial_actions = [(*action_tup, is_ext) for action_tup, is_ext in zip(actions, is_ext_list)]
        initial_state = trace.pre_condition[indexs[0]]

    # generate trace
    episode_trace = Trace(initial_state, trace.system, initial_actions, start_time=start_time, end_time=end_time)
    
    return episode_trace


def translate_value(cap, val, rev_map):
    _, _, parameter, p_map = rev_map[cap]
    if parameter.type not in {'set', 'bin'}:
        return val
    else:
        val = str(val).lower()
        return p_map[val]
        

def push_entry(time_dict, target_action, time, index, cap_dict, shown_new_tap, rev_map):
    cap, val = target_action.split('=')
    val = translate_value(cap, val, rev_map)
    date_str = time.strftime('%m-%d %H:%M')
    if index == -1:  # orig rule
        val = 'orig_triggered[%s]' % val
    else:  # new rule
        shown_new_tap.add(index)
        val = '%d_triggered[%s]' % (index, val)
    time_dict[date_str][cap_dict[cap]].append(val)

    
def translate_time_clip(clip, target_action, time_list_t, n_new_tap, rev_map):
    field_name_list = clip.system.getFieldNameList()
    cap_dict = {cap: index for cap, index in zip(field_name_list, range(len(field_name_list)))}
    # initialize dictionary time_dict[(date, hour, minute)][cap_id]
    time_dict = dict()
    shown_new_tap = set()
    start_time_i = datetime.datetime(year=clip.start_time.year, 
                                     month=clip.start_time.month, 
                                     day=clip.start_time.day, 
                                     hour=clip.start_time.hour, 
                                     minute=clip.start_time.minute)
    end_time_i = datetime.datetime(year=clip.end_time.year, 
                                   month=clip.end_time.month, 
                                   day=clip.end_time.day, 
                                   hour=clip.end_time.hour, 
                                   minute=clip.end_time.minute)
    time = start_time_i
    while time <= end_time_i:
        date_str = time.strftime('%m-%d %H:%M')
        time_dict[date_str] = [[] for _ in range(len(clip.system.getFieldNameList()))]
        time += datetime.timedelta(minutes=1)
    time_dict[''] = [[] for _ in range(len(clip.system.getFieldNameList()))]

    index_time_list = 0
    current_time = clip.start_time

    # Should push the initial status into the dictionary
    for cap in cap_dict:
        cap_index = cap_dict[cap]
        val = clip.initial_state[cap_index]
        val = translate_value(cap, val, rev_map)
        time_dict[''][cap_index].append(val)
    
    for ta, is_ext in zip(clip.actions, clip.is_ext_list):
        time, action = ta
        while index_time_list <= len(time_list_t)-1 and time_list_t[index_time_list][0] < time:
            if time_list_t[index_time_list][0] >= current_time:
                push_entry(time_dict, target_action, time_list_t[index_time_list][0], 
                           time_list_t[index_time_list][1], cap_dict, 
                           shown_new_tap=shown_new_tap, rev_map=rev_map)
                
            index_time_list += 1
        # Now push the action into the dictionary
        if '*' not in action:
            cap, val = action.split('=')
            val = translate_value(cap, val, rev_map)
            date_str = time.strftime('%m-%d %H:%M')

            val = val if is_ext or not action == target_action else 'orig_triggered[%s]' % val
            time_dict[date_str][cap_dict[cap]].append(val)
        
        current_time = time
    
    while index_time_list <= len(time_list_t)-1 and time_list_t[index_time_list][0] < clip.end_time:
        if time_list_t[index_time_list][0] >= current_time:
            push_entry(time_dict, target_action, time_list_t[index_time_list][0], 
                       time_list_t[index_time_list][1], cap_dict, 
                       shown_new_tap=shown_new_tap, rev_map=rev_map)
        index_time_list += 1
    
    date_str_list = sorted(list(time_dict.keys()))
    for date_str in date_str_list:
        if all([not lst for lst in time_dict[date_str]]):
            del time_dict[date_str]
        else:
            break
    date_str_list.reverse()
    for date_str in date_str_list:
        if all([not lst for lst in time_dict[date_str]]):
            del time_dict[date_str]
        else:
            break

    return time_dict, shown_new_tap


def translate_time_clip_debug(clip, target_action_id, rev_map):
    field_name_list = clip.system.getFieldNameList()
    cap_dict = {cap: index for cap, index in zip(field_name_list, range(len(field_name_list)))}

    time_dict = dict()
    start_time_i = datetime.datetime(year=clip.start_time.year, 
                                     month=clip.start_time.month, 
                                     day=clip.start_time.day, 
                                     hour=clip.start_time.hour, 
                                     minute=clip.start_time.minute)
    end_time_i = datetime.datetime(year=clip.end_time.year, 
                                   month=clip.end_time.month, 
                                   day=clip.end_time.day, 
                                   hour=clip.end_time.hour, 
                                   minute=clip.end_time.minute)
    time = start_time_i
    while time <= end_time_i:
        date_str = time.strftime('%m-%d %H:%M')
        time_dict[date_str] = [[] for _ in range(len(clip.system.getFieldNameList()))]
        time += datetime.timedelta(minutes=1)
    
    for index in range(len(clip.actions)):
        time, action = clip.actions[index]
        # Now push the action into the dictionary
        if '*' not in action:
            cap, val = action.split('=')
            val = translate_value(cap, val, rev_map)
            date_str = time.strftime('%m-%d %H:%M')
            
            val = val if index != target_action_id else 'del_triggered[%s]' % val
            time_dict[date_str][cap_dict[cap]].append(val)
    
    return time_dict


def modify_patch_to_taps(orig_taps, modify_patch):
    index = modify_patch['index']
    new_cond = modify_patch['new_condition']
    new_taps = []
    for ii in range(len(orig_taps)):
        orig_tap = orig_taps[ii]
        if ii == index:
            new_conditions = orig_tap.condition + [new_cond]
            tap = Tap(action=orig_tap.action, trigger=orig_tap.trigger, condition=new_conditions)
        else:
            tap = orig_tap
        new_taps.append(tap)
    return new_taps


def delete_patch_to_taps(orig_taps, delete_patch):
    index = delete_patch['index']
    new_taps = [orig_taps[ii] for ii in range(len(orig_taps)) if ii != index]
    return new_taps
