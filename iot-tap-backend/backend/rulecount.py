from autotapta.model.Trace import enhanceTraceWithTiming
from autotapta.analyze.Rank import getRealActionTimeAndRuleTriggerTime, getInfoFromTiming, getRuleCoverage
from autotap.util import update_trace_in_cache, get_trace_for_location
from autotap.translator import translate_rule_into_autotap_tap


def generate_cap_time_list_from_tap(tap):
    if tap.trigger.startswith('tick['):
        tap_trigger = tap.trigger[5:-1]
    else:
        tap_trigger = tap.trigger

    if '<=' in tap_trigger:
        var, _ = tap_trigger.split('<=')
    elif '>=' in tap_trigger:
        var, _ = tap_trigger.split('>=')
    elif '!=' in tap_trigger:
        var, _ = tap_trigger.split('!=')
    elif '>' in tap_trigger:
        var, _ = tap_trigger.split('>')
    elif '<' in tap_trigger:
        var, _ = tap_trigger.split('<')
    else:
        var, _ = tap_trigger.split('=')
    
    if '*' in var:
        time, var = var.split('*')
    elif '#' in var:
        time, var = var.split('#')
    else:
        return []
    
    return [(var, int(time))]


# def update_rule_count(rule, location):
#     trace = get_trace_for_location(location)
#     tap = translate_rule_into_autotap_tap(rule, use_tick_header=False)
#     cap_time_list = generate_cap_time_list_from_tap(tap)
#     new_trace = enhanceTraceWithTiming(trace, cap_time_list, '*')
    
#     actual_time_list, trigger_time_list = getRealActionTimeAndRuleTriggerTime(new_trace, tap, tap.action)
#     TP = getRuleCoverage(trigger_time_list, actual_time_list)
#     rule.count = TP
#     rule.save()
