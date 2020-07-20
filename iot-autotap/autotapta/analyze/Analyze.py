from autotapta.model.Trace import Trace
from autotapta.analyze.Formula import checkEventAgainstTrigger
from autotapmc.model.IoTSystem import IoTSystem
import autotapmc.buchi.Buchi as Buchi
import copy
from autotapmc.analyze.Build import generateTimeExp, ltlFormat
from autotapmc.utils.Boolean import calculateBoolean
from autotapmc.channels.template import DbTemplate
import autotapta.input.Template as Template
from autotapta.model.ParameterizedSystem import SynthParSystem, SynthTimeSystem, SynthTimeSystemSplit, PatchSystem, DebugSystem
from autotapmc.model.Tap import Tap
from autotapta.model.Trace import Trace
import math
import z3
import datetime
from sklearn.cluster import KMeans
from numpy import reshape


def _getAction(ts, src_index, dst_index):
    tran = [t for t in ts.trans_list if t.src_index == src_index and t.dst_index == dst_index]
    assert len(tran) == 1
    return tran[0].act


def calcTriggerTime(tap: Tap, trace: Trace):
    rule_trigger_timing = list()

    if not trace.actions:
        raise Exception('Empty trace not accepted by calcScore')
    start_time = trace.actions[0][0]

    for time_action, pre_condition, is_ext in zip(trace.actions, trace.pre_condition, trace.is_ext_list):
        time, action = time_action

        if checkEventAgainstTrigger(action, tap.trigger) and trace.system.tapConditionSatisfied(tap, pre_condition) and \
            ('*' in tap.trigger or not trace.system.conditionSatisfied(tap.trigger, pre_condition)):
                # and not trace.system.conditionSatisfied(tap.action, pre_condition):
            rule_trigger_timing.append(time)

    return rule_trigger_timing


def generateCombinedGraph(system: IoTSystem, ltl):
    # the efficiency of this is bad, we actually don't need to construct the transition system
    # a better way is to calculate the position in the buchi_ltl on the fly
    ts = system.transition_system
    buchi_ts = Buchi.tsToGenBuchi(ts, [])
    buchi_ltl = Buchi.ltlToBuchi(ltl)
    (buchi_final, pairs) = Buchi.product(buchi_ts, buchi_ltl)

    field_list = [state.field for state in ts.state_list]

    init_state = (buchi_ts.init_state, buchi_ltl.init_state)
    graph = dict()
    accepted_list = list()

    for edge in buchi_final.edge_list:
        src_index_ts = pairs[edge.src][0]
        dst_index_ts = pairs[edge.dst][0]

        src_index_ltl = pairs[edge.src][1]
        dst_index_ltl = pairs[edge.dst][1]
        src_field = field_list[src_index_ts]
        dst_field = field_list[dst_index_ts]
        action = _getAction(ts, src_index_ts, dst_index_ts)

        if buchi_final.getStateAcc(edge.src) and (src_index_ts, src_index_ltl) not in accepted_list:
            accepted_list.append((src_index_ts, src_index_ltl))

        if buchi_final.getStateAcc(edge.dst) and (dst_index_ts, dst_index_ltl) not in accepted_list:
            accepted_list.append((dst_index_ts, dst_index_ltl))

        if (src_index_ts, src_index_ltl) not in graph:
            graph[(src_index_ts, src_index_ltl)] = [{'action': action, 'destination': (dst_index_ts, dst_index_ltl)}]
        else:
            graph[(src_index_ts, src_index_ltl)].append(
                {'action': action, 'destination': (dst_index_ts, dst_index_ltl)})

    return graph, accepted_list, init_state


def generateLTLGraph(ltl):
    new_ltl = ltlFormat(ltl)

    buchi_ltl = Buchi.ltlToBuchi(new_ltl)

    init_state = buchi_ltl.init_state
    graph = dict()
    accepted_list = list()

    for edge in buchi_ltl.edge_list:
        if buchi_ltl.getStateAcc(edge.src) and edge.src not in accepted_list:
            accepted_list.append(edge.src)
        if buchi_ltl.getStateAcc(edge.dst) and edge.dst not in accepted_list:
            accepted_list.append(edge.dst)

        if edge.src not in graph:
            graph[edge.src] = [{'ap': edge.ap, 'destination': edge.dst}]
        else:
            graph[edge.src].append({'ap': edge.ap, 'destination': edge.dst})

    return graph, accepted_list, init_state


def applyActionFromTrace(system, action=None, curr_time=0, time=0, state_vec=None, record_exp_list=[]):
    """
    should return a list of (time, description, ap, field) tuple indicating the state progressions
    :param action:
    :param time:
    :param state_vec:
    :param record_exp_list:
    :return:
    """
    if state_vec:
        system.restoreFromStateVector(state_vec)

    result_list = list()
    while system.getSmallestTimerValue() + curr_time < time:
        # should tick one time, and get the time, description, and ap
        time_interval = system.getSmallestTimerValue()
        description = system.applyTick()
        ap = system.getApDict()
        result_list.append((curr_time, description, ap, system.saveToStateVector()))
        curr_time = curr_time + time_interval

    # should tick down the remaining time using "apply Tick"
    if curr_time < time:
        time_interval = time - curr_time
        description = system.applyTick(time=time_interval)
        ap = system.getApDict()
        # result_list.append((curr_time, description, ap, system.saveToStateVector()))
        curr_time = time

    # now it should be safe to apply the action
    if action:
        description = system.applyAction(action)
    else:
        description = ''
    ap = system.getApDict()
    result_list.append((curr_time, description, ap, system.saveToStateVector()))

    return result_list


def identifyViolations(trace: Trace, ltl):
    """
    identify the indexes where the property is violated
    :param trace: a trace
    :param system: the IoTSystem that holds the trace
    :param ltl: the ltl property being checked
    :return: should return a list of indexes where in the trace the property is violated because of the event happened
    """
    system = trace.system

    ltl_graph, accepted_list, init_position = generateLTLGraph(ltl)
    record_exp_list = generateTimeExp(ltl, [])

    trace_list = copy.deepcopy(trace.actions)
    trace_list = [(0, None)] + trace_list
    current_position = init_position
    current_time = 0
    violation_positions = list()

    while trace_list:
        # should follow the generation of buchi_ts to get the APs on the fly, and then compare to the requirements
        time_action, action = trace_list.pop(0)
        happened_action_list = applyActionFromTrace(system=system, action=action, time=time_action, curr_time=current_time,
                                                    state_vec=None if action else trace.initial_state,
                                                    record_exp_list=record_exp_list)

        for time, description, ap, field in happened_action_list:
            dst_position_list = [dct['destination'] for dct in ltl_graph[current_position] if
                                 calculateBoolean(dct['ap'], ap)]
            assert len(dst_position_list) == 1
            dst_position = dst_position_list[0]

            if dst_position in accepted_list:
                # should stop looping,
                # reset the system to the status right after violation,
                # and push result into violation_positions
                # should we re-submit the action: depends on whether it happens before violation
                violation_positions.append((time, description, ap))
                current_position = init_position
                system.restoreFromStateVector(field)
                current_time = time
                if not (description == action and time == time_action):
                    trace_list.insert(0, (time, action))
                break
            else:
                current_position = dst_position
                current_time = time

    return violation_positions


def calcMutualInformation(trace, variable_name, action_name):
    var_action_prob_dict = dict()
    var_prob_dict = dict()
    action_prob_dict = dict()

    var_index = trace.system.getFieldNameList().index(variable_name)

    # if not isinstance(trace.initial_state[var_index], bool) and not isinstance(trace.initial_state[var_index], str):
    #     # range variable, should group them
    #     var_label_list = list()
    #     for index, tup in zip(range(len(trace.actions)), trace.actions):
    #         var_label = trace.pre_condition[index][var_index]
    #         var_label_list.append(var_label)
    #     var_label_list = reshape(var_label_list, (-1, 1))
    #     kmeans = KMeans(n_clusters=3).fit(var_label_list)
    #     label_list = list(kmeans.labels_)
    # else:
    label_list = [pre_cond[var_index] for pre_cond in trace.pre_condition]

    for index, tup in zip(range(len(trace.actions)), trace.actions):
        action = tup[1]
        if action == action_name:
            action_label = action
        else:
            action_label = '!' + action_name

        # var_label = trace.pre_condition[index][var_index]
        var_label = label_list[index]
        if (var_label, action_label) not in var_action_prob_dict:
            var_action_prob_dict[(var_label, action_label)] = 1
        else:
            var_action_prob_dict[(var_label, action_label)] = var_action_prob_dict[(var_label, action_label)] + 1

        if var_label not in var_prob_dict:
            var_prob_dict[var_label] = 1
        else:
            var_prob_dict[var_label] = var_prob_dict[var_label] + 1

        if action_label not in action_prob_dict:
            action_prob_dict[action_label] = 1
        else:
            action_prob_dict[action_label] = action_prob_dict[action_label] + 1

    total_case_var_action = sum([v for k, v in var_action_prob_dict.items()])
    total_case_var = sum([v for k, v in var_prob_dict.items()])
    total_case_action = sum([v for k, v in action_prob_dict.items()])

    mutual_info = 0
    entropy_var = 0
    for k, v in var_action_prob_dict.items():
        var = k[0]
        action = k[1]

        p_var_action = v * 1.0 / total_case_var_action
        p_var = var_prob_dict[var] * 1.0 / total_case_var
        p_action = action_prob_dict[action] * 1.0 / total_case_action

        mutual_info = mutual_info + p_var_action * math.log(p_var_action/p_var/p_action)

    for k, v in var_prob_dict.items():
        p_var = v * 1.0 / total_case_var
        entropy_var = entropy_var - p_var * math.log(p_var)

    return mutual_info, entropy_var


def truncateTraceByLastAction(trace, action):
    action_name_list = [a for t, a in trace.actions]
    try:
        index = list(reversed(action_name_list)).index(action)
        index = len(action_name_list) - index
    except ValueError:
        index = len(action_name_list)
    trace.actions = trace.actions[:index]
    trace.pre_condition = trace.pre_condition[:index]
    return trace


def truncateTraceByTime(trace, t):
    index_list = [index for index, action_tup in zip(range(len(trace.actions)), trace.actions) if action_tup[0] < t]
    if index_list:
        index = max(index_list)
        trace.actions = trace.actions[:index+1]
        trace.pre_condition = trace.pre_condition[:index+1]
    else:
        trace.actions = list()
        trace.pre_condition = list()
    return trace


def strValueToZ3(var_name, value, set_z3_dict):
    if value == 'false':
        z3_value = False
    elif value == 'true':
        z3_value = True
    elif value.replace('.', '').isnumeric():
        z3_value = float(value)
    else:
        z3_value = set_z3_dict[var_name][1][value]
    return z3_value


def timeCorFunc(time1, time2, span=900):
    time_diff = abs(time1-time2)
    if time_diff > span:
        return 0
    else:
        return 0.50 + 0.50 * float(span - time_diff)/span


def calcTimingCorrelation(trace: Trace, target_action, cor_cap, time_span: datetime.timedelta):
    target_action_time_list = list()
    cor_cap_time_list = list()

    if not trace.actions:
        raise Exception("Empty trace detected!")

    cor_cap_last_time = None
    start_time, _ = trace.actions[0]
    for time, action in trace.actions:
        if action == target_action:
            target_action_time_list.append((time - start_time).total_seconds())
        elif action.startswith(cor_cap):
            if cor_cap_last_time is not None and time - cor_cap_last_time > time_span:
                cor_cap_time_list.append((cor_cap_last_time + time_span - start_time).total_seconds())
            cor_cap_last_time = time

    # Compare to time lists
    score = 0
    for ta_time in target_action_time_list:
        for co_time in cor_cap_time_list:
            score = score + timeCorFunc(ta_time, co_time)

    if not target_action_time_list or not cor_cap_time_list:
        return 0
    else:
        # if number of action is too small, prevent coincidence
        len_target_action = len(target_action_time_list)
        len_cor_cap = len(cor_cap_time_list) if len(cor_cap_time_list) > len_target_action * 2 \
            else len_target_action * 2
        return score / len_target_action / len_cor_cap


def listTimingCandidates(trace: Trace, target_action, num_sel=3,
                         only_ext=True, template_dict=Template.template_dict):
    field_name_list = trace.system.getFieldNameList()
    # span_test_list = [1, 5, 15, 30, 60, 120, 180, 240, 300, 360, 420, 480, 540, 600, 660, 720, 780, 840, 900, 1800]
    span_test_list = [1, 5, 15, 30, 60, 120, 180]
    result_list = list()
    for cor_cap in field_name_list:
        cor_list = [calcTimingCorrelation(trace, target_action,
                                          cor_cap, datetime.timedelta(seconds=span))
                    for span in span_test_list]
        max_cor = max(cor_list)
        max_index = cor_list.index(max_cor)
        # if max_index == 0: # probably not related to timing, but is a plain trigger
        #     continue
        max_time = span_test_list[max_index]
        result_list.append((cor_cap, max_time, max_cor))

    if only_ext:
        result_list = [(cor_cap, max_time, max_cor) for cor_cap, max_time, max_cor in result_list
                       if 'external' in template_dict[cor_cap.split('.')[0]][cor_cap.split('.')[1]] and 
                          'disabled' not in template_dict[cor_cap.split('.')[0]][cor_cap.split('.')[1]] and 
                          cor_cap.split('.')[0] != target_action.split('.')[0]]

    result_list = sorted(result_list, key=lambda x: x[2], reverse=True)
    return result_list[:num_sel] if num_sel < len(result_list) else result_list


def listRelatedCandidates(trace: Trace, target_action, num_sel=3,
                          only_ext=False, template_dict=Template.template_dict):
    field_name_list = trace.system.getFieldNameList()
    mi_list = list()

    for field_name in field_name_list:
        mi, entropy = calcMutualInformation(trace, field_name, target_action)
        try:
            mi_list.append((field_name, mi / entropy))
        except ZeroDivisionError:
            mi_list.append((field_name, 0))

    entropy_list = sorted(mi_list, reverse=True, key=lambda x: x[1])


    if not only_ext:
        entropy_list = [(fn, ent) for fn, ent in entropy_list
                        if 'external' in template_dict[fn.split('.')[0]][fn.split('.')[1]] and 
                           'disabled' not in template_dict[fn.split('.')[0]][fn.split('.')[1]] and
                           fn.split('.')[0] != target_action.split('.')[0]]

    result_list = entropy_list[:num_sel] if len(entropy_list) > num_sel else entropy_list
    return result_list


def synthesizeRuleWithSatSolver(trace, target_action, target_action_time=-1,
                                variable_list=None, template_dict=DbTemplate.template_dict):
    # if variable list not specified, choose the top 3 related based on entropy loss
    if not variable_list:
        field_name_list = trace.system.getFieldNameList()
        mi_list = list()

        for field_name in field_name_list:
            mi, entropy = calcMutualInformation(trace, field_name, target_action)
            mi_list.append((field_name, mi / entropy))

        entropy_list = sorted(mi_list, reverse=True, key=lambda x: x[1])

        variable_list = [var_name for var_name, entropy in entropy_list[:3]]

    # if target_action_time specified, truncate the trace
    if target_action_time != -1:
        trace = truncateTraceByTime(trace, target_action_time)

    # go through every variables. initialize z3 support for them
    system = trace.system
    system.restoreFromStateVector(trace.initial_state)

    # set initial value
    init_value_dict = dict()
    var_type_list = [template_dict[var_name.split('.')[0]][var_name.split('.')[1]].split(', ')[0]
                     for var_name in variable_list]
    for var_name in variable_list:
        init_value = system.state_dict[var_name]
        init_value_dict[var_name] = init_value

    # set up system
    par_system = SynthParSystem(variable_list, target_action, [], init_value_dict, template_dict)

    for _time, action in trace.actions:
        par_system.applyAction(action)

    # gathering important information
    set_z3_dict = par_system.getZ3SetDict()
    z3_var_dict, z3_var_default_val_dict = par_system.getAllZ3Variables()
    trigger_event_var_list = variable_list
    ap_var_list = variable_list
    trigger_event_show_list, triggger_event_comp_list, trigger_event_val_list = par_system.getTriggerZ3Vars()
    ap_show_list, ap_comp_list, ap_val_list = par_system.getApZ3Vars()
    z3_range_val_list = par_system.getRangeVars()

    # find the constraints
    target_action_var_name = target_action.split('=')[0]
    target_action_val = target_action.split('=')[1]
    target_action_index = variable_list.index(target_action_var_name)
    target_action_type = var_type_list[target_action_index]
    if target_action_type == 'bool':
        target_action_z3_val = (target_action_val == 'true')
    elif target_action_type == 'numeric':
        target_action_z3_val = int(target_action_val)
    else:
        z3_value = set_z3_dict[target_action_var_name][1][target_action_val]
        target_action_z3_val = z3_value
    noshow_c = list()  # when clause doesn't show up, use default value
    for name, trigshow in zip(trigger_event_var_list, trigger_event_show_list):
        name_1 = 'trigcomp_' + name
        name_2 = 'trigval_' + name
        if name_1 in z3_var_dict:
            cons = z3.Implies(z3.Not(trigshow), z3_var_dict[name_1] == z3_var_default_val_dict[name_1])
            noshow_c.append(cons)
        if name_2 in z3_var_dict:
            cons = z3.Implies(z3.Not(trigshow), z3_var_dict[name_2] == z3_var_default_val_dict[name_2])
            noshow_c.append(cons)
    for name, apshow in zip(ap_var_list, ap_show_list):
        name_1 = 'apcomp_' + name
        name_2 = 'apval_' + name
        if name_1 in z3_var_dict:
            cons = z3.Implies(z3.Not(apshow), z3_var_dict[name_1] == z3_var_default_val_dict[name_1])
            noshow_c.append(cons)
        if name_2 in z3_var_dict:
            cons = z3.Implies(z3.Not(apshow), z3_var_dict[name_2] == z3_var_default_val_dict[name_2])
            noshow_c.append(cons)
    # should automatically apply final action
    target_c = [par_system.getStateValue(target_action_var_name) == target_action_z3_val]
    # at most adding one rule
    onemost_c = [sum([z3.If(lbd, 1, 0) for lbd in trigger_event_show_list]) <= 1]
    # don't triggered by target action
    action_c = [z3.Not(z3.And(trigger_event_show_list[target_action_index],
                              trigger_event_val_list[target_action_index] ==
                              target_action_z3_val))]
    # for boolean ap, keep using '=false' instead of '!=true'
    boolap_c = [comp == par_system.Comparator.eq
                for comp, typ in zip(ap_comp_list, par_system.cap_type_list)
                if typ == 'bool']
    # cap in trigger should not show up in condition
    trigcond_c = [z3.Implies(lbd, z3.Not(eta)) for lbd, eta in zip(trigger_event_show_list, ap_show_list)]

    s = z3.Solver()
    s.add(target_c + onemost_c + action_c + noshow_c + boolap_c + trigcond_c)

    sol_index = 0
    while s.check() == z3.sat:
        m = s.model()
        print('===================== Solution #' + str(sol_index))
        sol_index = sol_index + 1
        print(m)
        print('---------------------')
        # evaluate value for each variable
        z3Interpreted = lambda x: not (z3.is_const(x) and x.decl().kind() == z3.Z3_OP_UNINTERPRETED)

        z3_var_eval_dict = dict([(name, m.evaluate(var)) if z3Interpreted(m.evaluate(var))
                                 else (name, z3_var_default_val_dict[name])
                                 for name, var in z3_var_dict.items()])

        trig_event = ''
        cond_list = []
        for key, value in z3_var_eval_dict.items():
            if key.startswith('trigshow_') and value == True:
                trig_var = key[9:]
                trig_val = str(z3_var_eval_dict['trigval_'+trig_var])
                trig_comp = '=' if 'trigcomp_'+trig_var not in z3_var_dict \
                    else str(z3_var_eval_dict['trigcomp_'+trig_var])
                trig_event = trig_var + trig_comp + trig_val
            if key.startswith('apshow_') and value == True:
                ap_var = key[7:]
                ap_val = 'true' if 'apval_'+ap_var not in z3_var_dict else str(z3_var_eval_dict['apval_'+ap_var])
                ap_comp = str(z3_var_eval_dict['apcomp_'+ap_var])
                ap_comp = '=' if ap_comp == 'eq' else \
                          ('!=' if ap_comp == 'neq' else
                           ('<' if ap_comp == 'lt' else
                            ('>' if ap_comp == 'gt' else
                             ('<=' if ap_comp == 'leq' else
                              '>='))))
                cond_list.append(ap_var + ap_comp + ap_val)

        print('IF %s WHILE %s, THEN %s' % (trig_event, ' AND '.join(cond_list), target_action))

        s.add(z3.Or([z3_var_dict[key] != z3_var_eval_dict[key]
                     for key in z3_var_eval_dict.keys()
                     if key not in z3_range_val_list]))


def synthesizeRuleBasedOnMultipleEvents(trace, target_action, learning_rate=0.5,
                                        variable_list=None, template_dict=DbTemplate.template_dict):
    # if variable list not specified, choose the top 3 related based on entropy loss
    if not variable_list:
        field_name_list = trace.system.getFieldNameList()
        mi_list = list()

        for field_name in field_name_list:
            mi, entropy = calcMutualInformation(trace, field_name, target_action)
            mi_list.append((field_name, mi / entropy))

        entropy_list = sorted(mi_list, reverse=True, key=lambda x: x[1])

        variable_list = [var_name for var_name, entropy in entropy_list[:3]]

    # go through every variables. initialize z3 support for them
    system = trace.system
    system.restoreFromStateVector(trace.initial_state)

    # set initial value
    init_value_dict = dict()
    var_type_list = [template_dict[var_name.split('.')[0]][var_name.split('.')[1]].split(', ')[0]
                     for var_name in variable_list]
    for var_name in variable_list:
        init_value = system.state_dict[var_name]
        init_value_dict[var_name] = init_value

    # set up system
    par_system = SynthParSystem(variable_list, target_action, [], init_value_dict, template_dict)

    # gathering important information
    set_z3_dict = par_system.getZ3SetDict()
    z3_var_dict, z3_var_default_val_dict = par_system.getAllZ3Variables()
    trigger_event_var_list = variable_list
    ap_var_list = variable_list
    trigger_event_show_list, triggger_event_comp_list, trigger_event_val_list = par_system.getTriggerZ3Vars()
    ap_show_list, ap_comp_list, ap_val_list = par_system.getApZ3Vars()
    z3_range_val_list = par_system.getRangeVars()

    target_action_var_name = target_action.split('=')[0]
    target_action_val = target_action.split('=')[1]
    target_action_index = variable_list.index(target_action_var_name)
    target_action_type = var_type_list[target_action_index]
    if target_action_type == 'bool':
        target_action_z3_val = (target_action_val == 'true')
    elif target_action_type == 'numeric':
        target_action_z3_val = int(target_action_val)
    else:
        z3_value = set_z3_dict[target_action_var_name][1][target_action_val]
        target_action_z3_val = z3_value

    # run the system, retrieve the z3 formula to be automated
    target_c_list = list()
    total_num_target_action = 0
    for _time, action in trace.actions:
        if action == target_action:
            total_num_target_action = total_num_target_action + 1
            target_c_entry = par_system.getStateValue(target_action_var_name) == target_action_z3_val
            target_c_list.append(z3.If(target_c_entry, 1, 0))
        par_system.applyAction(action)

    # find the constraints
    noshow_c = list()  # when clause doesn't show up, use default value
    for name, trigshow in zip(trigger_event_var_list, trigger_event_show_list):
        name_1 = 'trigcomp_' + name
        name_2 = 'trigval_' + name
        if name_1 in z3_var_dict:
            cons = z3.Implies(z3.Not(trigshow), z3_var_dict[name_1] == z3_var_default_val_dict[name_1])
            noshow_c.append(cons)
        if name_2 in z3_var_dict:
            cons = z3.Implies(z3.Not(trigshow), z3_var_dict[name_2] == z3_var_default_val_dict[name_2])
            noshow_c.append(cons)
    for name, apshow in zip(ap_var_list, ap_show_list):
        name_1 = 'apcomp_' + name
        name_2 = 'apval_' + name
        if name_1 in z3_var_dict:
            cons = z3.Implies(z3.Not(apshow), z3_var_dict[name_1] == z3_var_default_val_dict[name_1])
            noshow_c.append(cons)
        if name_2 in z3_var_dict:
            cons = z3.Implies(z3.Not(apshow), z3_var_dict[name_2] == z3_var_default_val_dict[name_2])
            noshow_c.append(cons)
    # should automatically apply target_actions
    target_c = [sum(target_c_list) >= int(total_num_target_action * learning_rate)]
    # at most adding one rule
    onemost_c = [sum([z3.If(lbd, 1, 0) for lbd in trigger_event_show_list]) <= 1]
    # don't triggered by target action
    action_c = [z3.Not(z3.And(trigger_event_show_list[target_action_index],
                              trigger_event_val_list[target_action_index] ==
                              target_action_z3_val))]
    # for boolean ap, keep using '=false' instead of '!=true'
    boolap_c = [comp == par_system.Comparator.eq
                for comp, typ in zip(ap_comp_list, par_system.cap_type_list)
                if typ == 'bool']
    # cap in trigger should not show up in condition
    trigcond_c = [z3.Implies(lbd, z3.Not(eta)) for lbd, eta in zip(trigger_event_show_list, ap_show_list)]

    s = z3.Solver()
    s.add(target_c + onemost_c + action_c + noshow_c + boolap_c + trigcond_c)

    sol_index = 0
    while s.check() == z3.sat:
        m = s.model()
        print('===================== Solution #' + str(sol_index))
        sol_index = sol_index + 1
        print(m)
        print('---------------------')
        # evaluate value for each variable
        z3Interpreted = lambda x: not (z3.is_const(x) and x.decl().kind() == z3.Z3_OP_UNINTERPRETED)

        z3_var_eval_dict = dict([(name, m.evaluate(var)) if z3Interpreted(m.evaluate(var))
                                 else (name, z3_var_default_val_dict[name])
                                 for name, var in z3_var_dict.items()])

        trig_event = ''
        cond_list = []
        for key, value in z3_var_eval_dict.items():
            if key.startswith('trigshow_') and value == True:
                trig_var = key[9:]
                trig_val = str(z3_var_eval_dict['trigval_' + trig_var])
                trig_comp = '=' if 'trigcomp_' + trig_var not in z3_var_dict \
                    else str(z3_var_eval_dict['trigcomp_' + trig_var])
                trig_event = trig_var + trig_comp + trig_val
            if key.startswith('apshow_') and value == True:
                ap_var = key[7:]
                ap_val = 'true' if 'apval_' + ap_var not in z3_var_dict else str(z3_var_eval_dict['apval_' + ap_var])
                ap_comp = str(z3_var_eval_dict['apcomp_' + ap_var])
                ap_comp = '=' if ap_comp == 'eq' else \
                    ('!=' if ap_comp == 'neq' else
                    ('<' if ap_comp == 'lt' else
                    ('>' if ap_comp == 'gt' else
                    ('<=' if ap_comp == 'leq' else
                    '>='))))
                cond_list.append(ap_var + ap_comp + ap_val)

        print('IF %s WHILE %s, THEN %s' % (trig_event, ' AND '.join(cond_list), target_action))

        s.add(z3.Or([z3_var_dict[key] != z3_var_eval_dict[key]
                     for key in z3_var_eval_dict.keys()
                     if key not in z3_range_val_list]))


def extractTimePoints(trace, target_action, span: datetime.timedelta=datetime.timedelta(minutes=2)):
    """
    given a time_list, find the time points that doesn't have another time point within span
    """
    time_points = []
    target_action_cap, target_action_val = target_action.split('=')
    for ta, is_ext in zip(trace.actions, trace.is_ext_list):
        time, action = ta
        if action == target_action and is_ext:
            # this is a candidate, need to check whether it is reverted
            indexs_post = [index
                           for action_tup, index in zip(trace.actions, range(len(trace.actions)))
                           if action_tup[0] >= time and action_tup[0] < time+span]
            for index_p in indexs_post:
                if trace.is_ext_list[index_p] and trace.actions[index_p][1].startswith(target_action_cap):
                    if trace.actions[index_p][1].split('=')[1] != target_action_val:
                        # this is a revert action
                        break
            else:
                time_points.append(time)
    
    return time_points

# each episode is part of the trace starting from target_action.time-pre_time_span
# to target_action.time+post_time_span
def extractEpisodes(trace: Trace, target_action, pre_time_span: datetime.timedelta=datetime.timedelta(minutes=15),
                    post_time_span: datetime.timedelta=datetime.timedelta(minutes=2)):
    """
    split the whole trace into some episode sub-traces based on target action
    :param trace: the whole trace
    :param target_action: the target action to be automated
    :param pre_time_span: episode's time before target action
    :param post_time_span: episode's time after target action
    :return: episode_list: each episode is part of the trace starting from target_action.time-pre_time_span
    to target_action.time+post_time_span
    """
    # TODO: when an action is reverted, we shouldn't consider it
    # TODO: we should only consider actions not being reverted within post_time_span
    # target_time_list = list()
    # for ta, is_ext in zip(trace.actions, trace.is_ext_list):
    #     time, action = ta
    #     if action == target_action and is_ext:
    #         target_time_list.append(time)

    target_time_list = extractTimePoints(trace, target_action, post_time_span)

    episode_trace_list = list()
    for target_time in target_time_list:
        # start time and end time of episode
        start_time = target_time - pre_time_span
        end_time = target_time + post_time_span
        # extract all actions that is within time range
        actions_index = [(index, action_tup)
                         for action_tup, index in zip(trace.actions, range(len(trace.actions)))
                         if action_tup[0] > target_time - pre_time_span and
                         action_tup[0] < target_time + post_time_span]
        # extract informations of those actions
        indexs = [index for index, _ in actions_index]
        actions = [action_tup for _, action_tup in actions_index]
        is_ext_list = [trace.is_ext_list[index] for index in indexs]
        initial_actions = [(*action_tup, is_ext) for action_tup, is_ext in zip(actions, is_ext_list)]
        initial_state = trace.pre_condition[indexs[0]]

        # generate trace
        episode_trace = Trace(initial_state, trace.system, initial_actions, start_time=start_time, end_time=end_time)
        # need to check the final state of the action
        field_list = episode_trace.system.getFieldNameList()
        var_name, val = target_action.split('=')
        var_index = field_list.index(var_name)
        if episode_trace.pre_condition and str(episode_trace.getPostCondition()[var_index]).lower() == str(val).lower():
            # append only if the episode ends in the target state  
            episode_trace_list.append(episode_trace)

    return episode_trace_list


def extractTriggerCases(trace: Trace, target_action, tap_list, 
                        pre_time_span: datetime.timedelta=datetime.timedelta(seconds=15), 
                        revert_time_span: datetime.timedelta=datetime.timedelta(minutes=1)):
    """
    find all cases where a rule is triggered and causes the target_action
    also find if any revert actions are triggered, come up with a revert_list

    """
    target_time_list = list()
    for ta, is_ext in zip(trace.actions, trace.is_ext_list):
        time, action = ta
        if action == target_action and not is_ext:
            target_time_list.append(time)

    target_action_cap, target_action_val = target_action.split('=')
    revert_list = list()
    episode_event_list = list()
    for target_time in target_time_list:
        # start time and end time of episode
        start_time = target_time - pre_time_span
        end_time = target_time
        post_time = target_time + revert_time_span
        # extract all actions that is within time range
        indexs = [index 
                  for action_tup, index in zip(trace.actions, range(len(trace.actions))) 
                  if action_tup[0] > start_time and action_tup[0] <= end_time]
        indexs_post = [index
                       for action_tup, index in zip(trace.actions, range(len(trace.actions)))
                       if action_tup[0] >= target_time and action_tup[0] < post_time]
        for index in indexs:
            time, action = trace.actions[index]
            pre_condition = trace.pre_condition[index]
            is_ext = trace.is_ext_list[index]
            for tap in tap_list:
                if trace.system.tapConditionSatisfied(tap, pre_condition) and checkEventAgainstTrigger(action, tap.trigger) and \
                    ('*' in tap.trigger or not trace.system.conditionSatisfied(tap.trigger, pre_condition)):
                    # this is a candidate event
                    episode_event_list.append((time, action, pre_condition))
                    for index_p in indexs_post:
                        if trace.is_ext_list[index_p] and trace.actions[index_p][1].startswith(target_action_cap):
                            if trace.actions[index_p][1].split('=')[1] != target_action_val:
                                # this is a revert action
                                revert_list.append(True)
                                break
                    else:
                        revert_list.append(False)
                    break

    return episode_event_list, revert_list


def extractRevertCases(trace: Trace, target_action, 
                       pre_time_span: datetime.timedelta=datetime.timedelta(seconds=15), 
                       revert_time_span: datetime.timedelta=datetime.timedelta(minutes=1)):
    target_time_list = list()
    for ta, is_ext in zip(trace.actions, trace.is_ext_list):
        time, action = ta
        if action == target_action and not is_ext:
            target_time_list.append(time)

    target_action_cap, target_action_val = target_action.split('=')
    revert_time_list = list()
    for target_time in target_time_list:
        # start time and end time of episode
        post_time = target_time + revert_time_span
        # extract all actions that is within time range
        indexs_post = [index
                       for action_tup, index in zip(trace.actions, range(len(trace.actions)))
                       if action_tup[0] >= target_time and action_tup[0] < post_time]
        
        
        for index_p in indexs_post:
            if trace.is_ext_list[index_p] and trace.actions[index_p][1].startswith(target_action_cap):
                if trace.actions[index_p][1].split('=')[1] != target_action_val:
                    # this is a revert action
                    revert_time_list.append(target_time)

    return revert_time_list


def synthesizeRuleBasedOnEpisodes(episode_list, target_action, learning_rate=0.5,
                                  variable_list=None, template_dict=DbTemplate.template_dict):
    # if variable list not specified, use all variables
    if not variable_list:
        try:
            field_name_list = episode_list[0].system.getFieldNameList()
        except IndexError as e:
            raise IndexError("episode list should not be empty")
        variable_list = field_name_list

    var_type_list = [template_dict[var_name.split('.')[0]][var_name.split('.')[1]].split(', ')[0]
                     for var_name in variable_list]

    # set up system
    par_system = SynthParSystem(variable_list, target_action, [], {}, template_dict)

    # gathering important information
    set_z3_dict = par_system.getZ3SetDict()
    z3_var_dict, z3_var_default_val_dict = par_system.getAllZ3Variables()
    trigger_event_var_list = variable_list
    ap_var_list = variable_list
    trigger_event_show_list, triggger_event_comp_list, trigger_event_val_list = par_system.getTriggerZ3Vars()
    ap_show_list, ap_comp_list, ap_val_list = par_system.getApZ3Vars()
    z3_range_val_list = par_system.getRangeVars()

    target_action_var_name = target_action.split('=')[0]
    target_action_val = target_action.split('=')[1]
    target_action_index = variable_list.index(target_action_var_name)
    target_action_type = var_type_list[target_action_index]
    if target_action_type == 'bool':
        target_action_z3_val = (target_action_val == 'true')
    elif target_action_type == 'numeric':
        target_action_z3_val = int(target_action_val)
    else:
        z3_value = set_z3_dict[target_action_var_name][1][target_action_val]
        target_action_z3_val = z3_value

    # run the system, retrieve the z3 formula to be automated
    target_c_list = list()
    total_num_target_action = len(episode_list)
    for trace, ii in zip(episode_list, range(len(episode_list))):
        # set up system
        system = trace.system
        system.restoreFromStateVector(trace.initial_state)
        # set initial value
        init_value_dict = dict()

        for var_name in variable_list:
            init_value = system.state_dict[var_name]
            init_value_dict[var_name] = init_value

        par_system.resetInitState(init_value_dict)

        for _time, action in trace.actions:
            if action == target_action:
                continue
            par_system.applyAction(action)
        target_c_entry = par_system.getStateValue(target_action_var_name) == target_action_z3_val
        target_c_list.append(z3.If(target_c_entry, 1, 0))
        print('Finish constructing episode ' + str(ii))

    # find the constraints
    noshow_c = list()  # when clause doesn't show up, use default value
    for name, trigshow in zip(trigger_event_var_list, trigger_event_show_list):
        name_1 = 'trigcomp_' + name
        name_2 = 'trigval_' + name
        if name_1 in z3_var_dict:
            cons = z3.Implies(z3.Not(trigshow), z3_var_dict[name_1] == z3_var_default_val_dict[name_1])
            noshow_c.append(cons)
        if name_2 in z3_var_dict:
            cons = z3.Implies(z3.Not(trigshow), z3_var_dict[name_2] == z3_var_default_val_dict[name_2])
            noshow_c.append(cons)
    for name, apshow in zip(ap_var_list, ap_show_list):
        name_1 = 'apcomp_' + name
        name_2 = 'apval_' + name
        if name_1 in z3_var_dict:
            cons = z3.Implies(z3.Not(apshow), z3_var_dict[name_1] == z3_var_default_val_dict[name_1])
            noshow_c.append(cons)
        if name_2 in z3_var_dict:
            cons = z3.Implies(z3.Not(apshow), z3_var_dict[name_2] == z3_var_default_val_dict[name_2])
            noshow_c.append(cons)
    # should automatically apply target_actions
    target_c = [sum(target_c_list) >= int(total_num_target_action * learning_rate)]
    # at most adding one rule
    onemost_c = [sum([z3.If(lbd, 1, 0) for lbd in trigger_event_show_list]) <= 1]
    # don't triggered by target action
    action_c = [z3.Not(z3.And(trigger_event_show_list[target_action_index],
                              trigger_event_val_list[target_action_index] ==
                              target_action_z3_val))]
    # for boolean ap, keep using '=false' instead of '!=true'
    boolap_c = [comp == par_system.Comparator.eq
                for comp, typ in zip(ap_comp_list, par_system.cap_type_list)
                if typ == 'bool']
    # cap in trigger should not show up in condition
    trigcond_c = [z3.Implies(lbd, z3.Not(eta)) for lbd, eta in zip(trigger_event_show_list, ap_show_list)]

    s = z3.Solver()
    s.add(target_c + onemost_c + action_c + noshow_c + boolap_c + trigcond_c)

    sol_index = 0
    while s.check() == z3.sat:
        m = s.model()
        print('===================== Solution #' + str(sol_index))
        sol_index = sol_index + 1
        print(m)
        print('---------------------')
        # evaluate value for each variable
        z3Interpreted = lambda x: not (z3.is_const(x) and x.decl().kind() == z3.Z3_OP_UNINTERPRETED)

        z3_var_eval_dict = dict([(name, m.evaluate(var)) if z3Interpreted(m.evaluate(var))
                                 else (name, z3_var_default_val_dict[name])
                                 for name, var in z3_var_dict.items()])

        trig_event = ''
        cond_list = []
        for key, value in z3_var_eval_dict.items():
            if key.startswith('trigshow_') and value == True:
                trig_var = key[9:]
                trig_val = str(z3_var_eval_dict['trigval_' + trig_var])
                trig_comp = '=' if 'trigcomp_' + trig_var not in z3_var_dict \
                    else str(z3_var_eval_dict['trigcomp_' + trig_var])
                trig_event = trig_var + trig_comp + trig_val
            if key.startswith('apshow_') and value == True:
                ap_var = key[7:]
                ap_val = 'true' if 'apval_' + ap_var not in z3_var_dict else str(z3_var_eval_dict['apval_' + ap_var])
                ap_comp = str(z3_var_eval_dict['apcomp_' + ap_var])
                ap_comp = '=' if ap_comp == 'eq' else \
                    ('!=' if ap_comp == 'neq' else
                    ('<' if ap_comp == 'lt' else
                    ('>' if ap_comp == 'gt' else
                    ('<=' if ap_comp == 'leq' else
                    '>='))))
                cond_list.append(ap_var + ap_comp + ap_val)

        print('IF %s WHILE %s, THEN %s' % (trig_event, ' AND '.join(cond_list), target_action))

        s.add(z3.Or([z3_var_dict[key] != z3_var_eval_dict[key]
                     for key in z3_var_eval_dict.keys()
                     if key not in z3_range_val_list]))


def synthesizeTimingRuleBasedOnEpisodes(episode_list, target_action, timing_cap_list=list(), learning_rate=0.5,
                                        variable_list=None, template_dict=DbTemplate.template_dict):
    # if variable list not specified, use all variables
    if not variable_list:
        try:
            field_name_list = episode_list[0].system.getFieldNameList()
        except IndexError as e:
            raise IndexError("episode list should not be empty")
        variable_list = field_name_list

    var_type_list = [template_dict[var_name.split('.')[0]][var_name.split('.')[1]].split(', ')[0]
                     for var_name in variable_list]

    # set up system
    par_system = SynthTimeSystem(variable_list, target_action, [], {}, template_dict, timing_cap_list=timing_cap_list)

    # gathering important information
    set_z3_dict = par_system.getZ3SetDict()
    z3_var_dict, z3_var_default_val_dict = par_system.getAllZ3Variables()
    trigger_event_var_list = variable_list
    ap_var_list = variable_list
    timing_var_list = [var_name for var_name, _ in timing_cap_list]
    trigger_event_show_list, triggger_event_comp_list, trigger_event_val_list = par_system.getTriggerZ3Vars()
    ap_show_list, ap_comp_list, ap_val_list = par_system.getApZ3Vars()
    timing_trigshow_list, timing_trigcomp_list, timing_trigval_list = par_system.getTimingZ3Vars()
    z3_range_val_list = par_system.getRangeVars()

    target_action_var_name = target_action.split('=')[0]
    target_action_val = target_action.split('=')[1]
    target_action_index = variable_list.index(target_action_var_name)
    target_action_type = var_type_list[target_action_index]
    if target_action_type == 'bool':
        target_action_z3_val = (target_action_val == 'true')
    elif target_action_type == 'numeric':
        target_action_z3_val = int(target_action_val)
    else:
        z3_value = set_z3_dict[target_action_var_name][1][target_action_val]
        target_action_z3_val = z3_value

    # run the system, retrieve the z3 formula to be automated
    target_c_list = list()
    total_num_target_action = len(episode_list)
    for trace, ii in zip(episode_list, range(len(episode_list))):
        # set up system
        system = trace.system
        system.restoreFromStateVector(trace.initial_state)
        # set initial value
        init_value_dict = dict()

        for var_name in variable_list:
            init_value = system.state_dict[var_name]
            init_value_dict[var_name] = init_value

        par_system.resetInitState(init_value_dict)

        for _time, action in trace.actions:
            if target_action in action:
                continue
            par_system.applyAction(action)
        target_c_entry = par_system.getStateValue(target_action_var_name) == target_action_z3_val
        target_c_list.append(z3.If(target_c_entry, 1, 0))
        print('Finish constructing episode ' + str(ii))

    # find the constraints
    noshow_c = list()  # when clause doesn't show up, use default value
    for name, trigshow in zip(trigger_event_var_list, trigger_event_show_list):
        name_1 = 'trigcomp_' + name
        name_2 = 'trigval_' + name
        if name_1 in z3_var_dict:
            cons = z3.Implies(z3.Not(trigshow), z3_var_dict[name_1] == z3_var_default_val_dict[name_1])
            noshow_c.append(cons)
        if name_2 in z3_var_dict:
            cons = z3.Implies(z3.Not(trigshow), z3_var_dict[name_2] == z3_var_default_val_dict[name_2])
            noshow_c.append(cons)
    for name, apshow in zip(ap_var_list, ap_show_list):
        name_1 = 'apcomp_' + name
        name_2 = 'apval_' + name
        if name_1 in z3_var_dict:
            cons = z3.Implies(z3.Not(apshow), z3_var_dict[name_1] == z3_var_default_val_dict[name_1])
            noshow_c.append(cons)
        if name_2 in z3_var_dict:
            cons = z3.Implies(z3.Not(apshow), z3_var_dict[name_2] == z3_var_default_val_dict[name_2])
            noshow_c.append(cons)
    for name, timingtrigshow in zip(timing_var_list, timing_trigshow_list):
        name_1 = 'timingtrigcomp_' + name
        name_2 = 'timingtrigval_' + name
        if name_1 in z3_var_dict:
            cons = z3.Implies(z3.Not(timingtrigshow), z3_var_dict[name_1] == z3_var_default_val_dict[name_1])
            noshow_c.append(cons)
        if name_2 in z3_var_dict:
            cons = z3.Implies(z3.Not(timingtrigshow), z3_var_dict[name_2] == z3_var_default_val_dict[name_2])
            noshow_c.append(cons)
    # should automatically apply target_actions
    target_c = [sum(target_c_list) >= int(total_num_target_action * learning_rate)]
    # at most adding one rule
    onemost_c = [sum([z3.If(lbd, 1, 0) for lbd in trigger_event_show_list] +
                     [z3.If(lbd, 1, 0) for lbd in timing_trigshow_list]) <= 1]
    # don't triggered by target action
    action_c = [z3.Not(z3.And(trigger_event_show_list[target_action_index],
                              trigger_event_val_list[target_action_index] ==
                              target_action_z3_val))]
    # for boolean ap, keep using '=false' instead of '!=true'
    boolap_c = [comp == par_system.Comparator.eq
                for comp, typ in zip(ap_comp_list, par_system.cap_type_list)
                if typ == 'bool']
    # cap in trigger should not show up in condition
    trigcond_c = [z3.Implies(lbd, z3.Not(eta)) for lbd, eta in zip(trigger_event_show_list, ap_show_list)]

    s = z3.Solver()
    s.add(target_c + onemost_c + action_c + noshow_c + boolap_c + trigcond_c)

    result_list = list()
    sol_index = 0
    while s.check() == z3.sat:
        m = s.model()
        print('===================== Solution #' + str(sol_index))
        sol_index = sol_index + 1
        print(m)
        print('---------------------')
        # evaluate value for each variable
        z3Interpreted = lambda x: not (z3.is_const(x) and x.decl().kind() == z3.Z3_OP_UNINTERPRETED)

        z3_var_eval_dict = dict([(name, m.evaluate(var)) if z3Interpreted(m.evaluate(var))
                                 else (name, z3_var_default_val_dict[name])
                                 for name, var in z3_var_dict.items()])

        trig_event = ''
        cond_list = []
        for key, value in z3_var_eval_dict.items():
            if key.startswith('trigshow_') and value == True:
                trig_var = key[9:]
                trig_val = str(z3_var_eval_dict['trigval_' + trig_var])
                trig_val = trig_val.lower() if trig_val in ('True', 'False') else trig_val
                trig_comp = '=' if 'trigcomp_' + trig_var not in z3_var_dict \
                    else str(z3_var_eval_dict['trigcomp_' + trig_var])
                trig_event = trig_var + trig_comp + trig_val
                tap_trig_event = trig_event
            if key.startswith('apshow_') and value == True:
                ap_var = key[7:]
                ap_val = 'True' if 'apval_' + ap_var not in z3_var_dict else str(z3_var_eval_dict['apval_' + ap_var])
                ap_val = ap_val.lower() if ap_val in ('True', 'False') else ap_val
                ap_comp = str(z3_var_eval_dict['apcomp_' + ap_var])
                ap_comp = '=' if ap_comp == 'eq' else \
                    ('!=' if ap_comp == 'neq' else
                    ('<' if ap_comp == 'lt' else
                    ('>' if ap_comp == 'gt' else
                    ('<=' if ap_comp == 'leq' else
                    '>='))))
                cond_list.append(ap_var + ap_comp + ap_val)
            if key.startswith('timingtrigshow_') and value == True:
                trig_var = key[15:]
                trig_val = str(z3_var_eval_dict['timingtrigval_' + trig_var])
                trig_val = trig_val.lower() if trig_val in ('True', 'False') else trig_val
                trig_comp = '=' if 'trigcomp_' + trig_var not in z3_var_dict \
                    else str(z3_var_eval_dict['trigcomp_' + trig_var])
                timing_cap_list_cap = [cap for cap, _ in timing_cap_list]
                trig_time = timing_cap_list[timing_cap_list_cap.index(trig_var)][1]
                trig_event = trig_var + trig_comp + trig_val + \
                             ' happened more than %s ago' % (datetime.timedelta(seconds=trig_time))
                tap_trig_event = str(trig_time) + '*' + trig_var + trig_comp + trig_val

        result_list.append(Tap(action=target_action, trigger=tap_trig_event, condition=cond_list))
        print('IF %s WHILE %s, THEN %s' % (trig_event, ' AND '.join(cond_list), target_action))

        s.add(z3.Or([z3_var_dict[key] != z3_var_eval_dict[key]
                     for key in z3_var_eval_dict.keys()
                     if key not in z3_range_val_list]))

    return result_list


def synthesizeTimingRuleBasedOnEpisodesSplit(episode_list, target_action, timing_cap_list=list(), learning_rate=0.5,
                                             variable_list=None, trig_var_list=None, cond_var_list=None,
                                             template_dict=DbTemplate.template_dict):
    # if variable list not specified, use all variables
    if not variable_list:
        try:
            field_name_list = episode_list[0].system.getFieldNameList()
        except IndexError as e:
            raise IndexError("episode list should not be empty")
        variable_list = field_name_list

    trig_var_list = trig_var_list if trig_var_list else variable_list
    cond_var_list = cond_var_list if cond_var_list else variable_list

    var_type_list = [template_dict[var_name.split('.')[0]][var_name.split('.')[1]].split(', ')[0]
                     for var_name in variable_list]

    # set up system
    par_system = SynthTimeSystemSplit(variable_list, target_action, trig_var_list, cond_var_list,
                                      [], {}, template_dict, timing_cap_list=timing_cap_list)

    # gathering important information
    set_z3_dict = par_system.getZ3SetDict()
    z3_var_dict, z3_var_default_val_dict = par_system.getAllZ3Variables()
    trigger_event_var_list = trig_var_list
    ap_var_list = cond_var_list
    timing_var_list = [var_name for var_name, _ in timing_cap_list]
    trigger_event_show_list, triggger_event_comp_list, trigger_event_val_list = par_system.getTriggerZ3Vars()
    ap_show_list, ap_comp_list, ap_val_list = par_system.getApZ3Vars()
    timing_trigshow_list, timing_trigcomp_list, timing_trigval_list = par_system.getTimingZ3Vars()
    z3_range_val_list = par_system.getRangeVars()
    z3_set_val_list = par_system.getSetVars()

    target_action_var_name = target_action.split('=')[0]
    target_action_val = target_action.split('=')[1]
    target_action_index = variable_list.index(target_action_var_name)
    target_action_type = var_type_list[target_action_index]
    if target_action_type == 'bool':
        target_action_z3_val = (target_action_val == 'true')
    elif target_action_type == 'numeric':
        target_action_z3_val = int(target_action_val)
    else:
        z3_value = set_z3_dict[target_action_var_name][1][target_action_val]
        target_action_z3_val = z3_value

    # run the system, retrieve the z3 formula to be automated
    target_c_list = list()
    total_num_target_action = len(episode_list)
    for trace, ii in zip(episode_list, range(len(episode_list))):
        # set up system
        system = trace.system
        system.restoreFromStateVector(trace.initial_state)
        # set initial value
        init_value_dict = dict()

        for var_name in variable_list:
            init_value = system.state_dict[var_name]
            init_value_dict[var_name] = init_value

        par_system.resetInitState(init_value_dict)

        for _time, action in trace.actions:
            if target_action in action:
                continue
            par_system.applyAction(action)
        target_c_entry = par_system.getStateValue(target_action_var_name) == target_action_z3_val
        target_c_list.append(z3.If(target_c_entry, 1, 0))
        # print('Finish constructing episode ' + str(ii))

    # find the constraints
    noshow_c = list()  # when clause doesn't show up, use default value
    for name, trigshow in zip(trigger_event_var_list, trigger_event_show_list):
        name_1 = 'trigcomp_' + name
        name_2 = 'trigval_' + name
        if name_1 in z3_var_dict:
            cons = z3.Implies(z3.Not(trigshow), z3_var_dict[name_1] == z3_var_default_val_dict[name_1])
            noshow_c.append(cons)
        if name_2 in z3_var_dict:
            cons = z3.Implies(z3.Not(trigshow), z3_var_dict[name_2] == z3_var_default_val_dict[name_2])
            noshow_c.append(cons)
    for name, apshow in zip(ap_var_list, ap_show_list):
        name_1 = 'apcomp_' + name
        name_2 = 'apval_' + name
        if name_1 in z3_var_dict:
            cons = z3.Implies(z3.Not(apshow), z3_var_dict[name_1] == z3_var_default_val_dict[name_1])
            noshow_c.append(cons)
        if name_2 in z3_var_dict:
            cons = z3.Implies(z3.Not(apshow), z3_var_dict[name_2] == z3_var_default_val_dict[name_2])
            noshow_c.append(cons)
    for name, timingtrigshow in zip(timing_var_list, timing_trigshow_list):
        name_1 = 'timingtrigcomp_' + name
        name_2 = 'timingtrigval_' + name
        if name_1 in z3_var_dict:
            cons = z3.Implies(z3.Not(timingtrigshow), z3_var_dict[name_1] == z3_var_default_val_dict[name_1])
            noshow_c.append(cons)
        if name_2 in z3_var_dict:
            cons = z3.Implies(z3.Not(timingtrigshow), z3_var_dict[name_2] == z3_var_default_val_dict[name_2])
            noshow_c.append(cons)
    # should automatically apply target_actions
    target_c = [sum(target_c_list) >= int(total_num_target_action * learning_rate)]
    # at most adding one rule
    onemost_c = [sum([z3.If(lbd, 1, 0) for lbd in trigger_event_show_list] +
                     [z3.If(lbd, 1, 0) for lbd in timing_trigshow_list]) <= 1]
    # don't triggered by target action
    if target_action_var_name in trig_var_list:
        target_action_index_in_trig = trig_var_list.index(target_action_var_name)
        action_c = [z3.Not(z3.And(trigger_event_show_list[target_action_index_in_trig],
                                  trigger_event_val_list[target_action_index_in_trig] ==
                                  target_action_z3_val))]
    else:
        action_c = []
    # for boolean ap, keep using '=false' instead of '!=true'
    boolap_c = [comp == par_system.Comparator.eq
                for comp, typ in zip(ap_comp_list, par_system.cond_cap_type_list)
                if typ == 'bool']
    # cap in trigger should not show up in condition
    trigcond_c = list()
    for lbd, trig_cap in zip(trigger_event_show_list, trig_var_list):
        if trig_cap in cond_var_list:
            index_cond = cond_var_list.index(trig_cap)
            trigcond_c.append(z3.Implies(lbd, z3.Not(ap_show_list[index_cond])))

    # for range ap, shouldn't be using '=' or '!='
    range_c = [z3.Implies(ap_show,
                          z3.And(comp != par_system.ComparatorRange.eq, comp != par_system.ComparatorRange.neq,
                                 comp != par_system.ComparatorRange.geq, comp != par_system.ComparatorRange.leq))
               for ap_show, comp, typ in zip(ap_show_list, ap_comp_list, par_system.cond_cap_type_list)
               if typ == 'numeric']

    s = z3.Solver()
    s.add(target_c + onemost_c + action_c + noshow_c + boolap_c + trigcond_c + range_c)

    result_list = list()
    sol_index = 0
    while s.check() == z3.sat:
        m = s.model()
        # print('===================== Solution #' + str(sol_index))
        # sol_index = sol_index + 1
        # print(m)
        # print('---------------------')
        # evaluate value for each variable
        z3Interpreted = lambda x: not (z3.is_const(x) and x.decl().kind() == z3.Z3_OP_UNINTERPRETED)

        z3_var_eval_dict = dict([(name, m.evaluate(var)) if z3Interpreted(m.evaluate(var))
                                 else (name, z3_var_default_val_dict[name])
                                 for name, var in z3_var_dict.items()])

        trig_event = ''
        cond_list = []
        for key, value in z3_var_eval_dict.items():
            if key.startswith('trigshow_') and value == True:
                trig_var = key[9:]
                trig_val = str(z3_var_eval_dict['trigval_' + trig_var])
                trig_val = trig_val.lower() if trig_val in ('True', 'False') else trig_val
                trig_comp = 'eq' if 'trigcomp_' + trig_var not in z3_var_dict \
                    else str(z3_var_eval_dict['trigcomp_' + trig_var])
                trig_comp = '=' if trig_comp == 'eq' else \
                            ('!=' if trig_comp == 'neq' else
                            ('<' if trig_comp == 'lt' else
                            ('>' if trig_comp == 'gt' else
                            ('<=' if trig_comp == 'leq' else
                            '>='))))
                trig_event = trig_var + trig_comp + trig_val
                tap_trig_event = trig_event
            if key.startswith('apshow_') and value == True:
                ap_var = key[7:]
                ap_val = 'True' if 'apval_' + ap_var not in z3_var_dict else str(z3_var_eval_dict['apval_' + ap_var])
                ap_val = ap_val.lower() if ap_val in ('True', 'False') else ap_val
                ap_comp = str(z3_var_eval_dict['apcomp_' + ap_var])
                ap_comp = '=' if ap_comp == 'eq' else \
                    ('!=' if ap_comp == 'neq' else
                    ('<' if ap_comp == 'lt' else
                    ('>' if ap_comp == 'gt' else
                    ('<=' if ap_comp == 'leq' else
                    '>='))))
                cond_list.append(ap_var + ap_comp + ap_val)
            if key.startswith('timingtrigshow_') and value == True:
                trig_var = key[15:]
                trig_val = str(z3_var_eval_dict['timingtrigval_' + trig_var])
                trig_val = trig_val.lower() if trig_val in ('True', 'False') else trig_val
                trig_comp = 'eq' if 'timingtrigcomp_' + trig_var not in z3_var_dict \
                    else str(z3_var_eval_dict['timingtrigcomp_' + trig_var])
                trig_comp = '=' if trig_comp == 'eq' else \
                    ('!=' if trig_comp == 'neq' else
                    ('<' if trig_comp == 'lt' else
                    ('>' if trig_comp == 'gt' else
                    ('<=' if trig_comp == 'leq' else
                    '>='))))
                timing_cap_list_cap = [cap for cap, _ in timing_cap_list]
                trig_time = timing_cap_list[timing_cap_list_cap.index(trig_var)][1]
                trig_event = trig_var + trig_comp + trig_val + \
                             ' happened more than %s ago' % (datetime.timedelta(seconds=trig_time))
                tap_trig_event = str(trig_time) + '*' + trig_var + trig_comp + trig_val

        result_list.append(Tap(action=target_action, trigger=tap_trig_event, condition=cond_list))
        # print('IF %s WHILE %s, THEN %s' % (trig_event, ' AND '.join(cond_list), target_action))

        s.add(z3.Or([z3_var_dict[key] != z3_var_eval_dict[key]
                     for key in z3_var_eval_dict.keys()
                     if key not in z3_range_val_list and key not in z3_set_val_list]))

    return result_list


def synthesizeRuleGeneral(episode_list, target_action, timing_cap_list=list(), learning_rate=0.5,
                          variable_list=None, trig_var_list=None, cond_var_list=None,
                          template_dict=DbTemplate.template_dict, mask=None, tap_list=None):
    
    if not episode_list:
        return []  # Don't do anything when there's nothing to learn

    # TODO: add original rules into the system
    if not tap_list:
        tap_list = []
    
    if not variable_list:
        try:
            field_name_list = episode_list[0].system.getFieldNameList()
        except IndexError as e:
            raise IndexError("episode list should not be empty")
        variable_list = field_name_list
    if mask is None:
        mask = [True] * len(episode_list)

    trig_var_list = trig_var_list if trig_var_list else variable_list
    cond_var_list = cond_var_list if cond_var_list else variable_list

    var_type_list = [template_dict[var_name.split('.')[0]][var_name.split('.')[1]].split(', ')[0]
                     for var_name in variable_list]

    # set up system
    # par_system = SynthTimeSystemSplit(variable_list, target_action, trig_var_list, cond_var_list,
    #                                   [], {}, template_dict, timing_cap_list=timing_cap_list)
    par_system = PatchSystem(variable_list, target_action, trig_var_list,
                             timing_cap_list, cond_var_list, 
                             template_dict=template_dict, tap_list=tap_list)

    target_var, target_comp, target_val = par_system.parseSimpleFormula(target_action)

    target_c_list = list()
    for episode in episode_list:
        # set up system
        system = episode.system
        system.restoreFromStateVector(episode.initial_state)
        # set initial value
        init_value_dict = dict()

        for var_name in variable_list:
            init_value = system.state_dict[var_name]
            init_value_dict[var_name] = init_value

        par_system.resetInitState(init_value_dict)
        current_time = episode.start_time
        for _time, action in episode.actions:
            if target_action in action:
                continue
            par_system.timePass(current_time, _time)
            current_time = _time
            par_system.applyAction(action)
        par_system.timePass(current_time, episode.end_time)
        target_c_entry = par_system.getStateValue(target_var) == target_val
        target_c_list.append(z3.If(target_c_entry, 1, 0))

    # should automatically apply target_actions
    target_c_list_with_mask = [target for target, m in zip(target_c_list, mask) if m]
    total_num_target_action = len(target_c_list_with_mask)
    # print('target: ', len(target_c_list_with_mask))
    # print('learning_rate: ', learning_rate)
    # print('target to achieve: ', math.ceil(total_num_target_action * learning_rate))

    # solving
    s = z3.Solver()

    # syntax constraints
    syntax_c = par_system.getSyntaxConstraints()
    s.add(syntax_c)
    # constraint for adding rule
    other_c = par_system.getConstraintsForAdding()
    s.add(other_c)
    # must achieve target
    target_c = [sum(target_c_list_with_mask) >= math.ceil(total_num_target_action * learning_rate)]
    s.add(target_c)
    result_list = list()
    while s.check() == z3.sat:
        m = s.model()
        z3Interpreted = lambda x: not (z3.is_const(x) and x.decl().kind() == z3.Z3_OP_UNINTERPRETED)

        z3_var_dict, z3_default_val_dict = par_system.getAllZ3Variables()

        z3_var_eval_dict = dict([(name, m.evaluate(var)) if z3Interpreted(m.evaluate(var))
                                 else (name, z3_default_val_dict[name])
                                 for name, var in z3_var_dict.items()])

        z3_range_var_list = par_system.getRangeVars()
        z3_set_var_list = par_system.getSetVars()

        s.add(z3.Or([z3_var_dict[key] != z3_var_eval_dict[key]
              for key in z3_var_eval_dict.keys()
              if key not in z3_range_var_list and key not in z3_set_var_list]))

        rule_mask = []
        for target in target_c_list:
            t_val = bool(int(m.evaluate(target, model_completion=True).as_long()))
            rule_mask.append(t_val)
        tap = par_system.new_rule.to_tap(z3_var_eval_dict)
        result_list.append((rule_mask, tap))
    
    return result_list


def _merge_revert_result(revert_list, revert_mask):
    result = []
    ii = 0
    for rv in revert_list:
        if rv:
            result.append(revert_mask[ii])
            ii += 1
        else:
            result.append(False)
    return result


def debugRuleGeneral(trace, time_event_cond_list, revert_list, target_action, learning_rate=0.5, 
                     variable_list=None, cond_var_list=None,
                     template_dict=DbTemplate.template_dict, mask=None, tap_list=None):
    """
    This should handle all caps
    Try to handle the FP cases
    """
    if not time_event_cond_list:
        return []  # Don't do anything when there's nothing to learn

    if not tap_list:
        tap_list = []
    
    if not variable_list:
        try:
            field_name_list = trace.system.getFieldNameList()
        except IndexError as e:
            raise IndexError("episode list should not be empty")
        variable_list = field_name_list

    if mask is None:
        mask = [True] * len(time_event_cond_list)

    cond_var_list = cond_var_list if cond_var_list is not None else variable_list
    par_system = DebugSystem(variable_list, target_action, cond_var_list, 
                             template_dict=template_dict, tap_list=tap_list)

    # run, see if rule with target action triggered
    trigger_bit_list = []
    
    for time, event, pre_cond in time_event_cond_list:
        pre_cond_dict = dict(zip(par_system.cap_list, pre_cond))
        par_system.resetInitState(pre_cond_dict)
        trigger_bit = par_system.testIfRuleTriggered(event)
        trigger_bit_list.append(trigger_bit)

    # constraints
    # compare each trigger bits with revert_list. when revert is True, trigger bit should be False
    revert_target_list = [z3.If(target, 0, 1) for target, revert in zip(trigger_bit_list, revert_list) if revert]
    remaining_target_list = [z3.If(target, 1, 0) for target, revert in zip(trigger_bit_list, revert_list) if not revert]
    revert_num = len(revert_target_list)
    remaining_num = len(remaining_target_list)

    # should maintain the same for cases that don't need to be reverted
    # should handle action reverse for more than 3 times
    target_c = [
        sum(revert_target_list) >= min(3, math.ceil(revert_num * learning_rate)),
        sum(remaining_target_list) >= math.ceil(remaining_num * learning_rate)
    ]
    
    # syntax constraints
    syntax_c = par_system.getSyntaxConstraints()

    # solving
    s = z3.Solver()
    s.add(target_c + syntax_c)

    # first solve for deleting
    s.push()
    delete_c = par_system.getConstraintsForDeleting()
    s.add(delete_c)

    result_delete = []
    delete_rule_masks = []
    while s.check() == z3.sat:
        m = s.model()
        z3Interpreted = lambda x: not (z3.is_const(x) and x.decl().kind() == z3.Z3_OP_UNINTERPRETED)

        z3_var_dict, z3_default_val_dict = par_system.getAllZ3Variables()
        z3_var_eval_dict = dict([(name, m.evaluate(var)) if z3Interpreted(m.evaluate(var))
                                 else (name, z3_default_val_dict[name])
                                 for name, var in z3_var_dict.items()])

        z3_range_var_list = par_system.getRangeVars()
        z3_set_var_list = par_system.getSetVars()
        
        s.add(z3.Or([z3_var_dict[key] != z3_var_eval_dict[key]
              for key in z3_var_eval_dict.keys()
              if key not in z3_range_var_list and key not in z3_set_var_list]))

        rule_mask = []
        for target in revert_target_list:
            t_val = bool(int(m.evaluate(target, model_completion=True).as_long()))
            rule_mask.append(t_val)
        rule_mask = _merge_revert_result(revert_list, rule_mask)
        delete_rule_masks.append(rule_mask)
        
        sel_index = par_system.getSelectedRuleIndex(z3_var_eval_dict)
        result_delete.append({'index': sel_index})
    s.pop()

    # then solve for modifying
    s.push()
    modify_c = par_system.getConstraintsForModifying()
    s.add(modify_c)

    result_modify = []
    modify_rule_masks = []
    while s.check() == z3.sat:
        m = s.model()
        z3Interpreted = lambda x: not (z3.is_const(x) and x.decl().kind() == z3.Z3_OP_UNINTERPRETED)

        z3_var_dict, z3_default_val_dict = par_system.getAllZ3Variables()

        z3_var_eval_dict = dict([(name, m.evaluate(var)) if z3Interpreted(m.evaluate(var))
                                 else (name, z3_default_val_dict[name])
                                 for name, var in z3_var_dict.items()])

        z3_range_var_list = par_system.getRangeVars()
        z3_set_var_list = par_system.getSetVars()

        s.add(z3.Or([z3_var_dict[key] != z3_var_eval_dict[key]
              for key in z3_var_eval_dict.keys()
              if key not in z3_range_var_list and key not in z3_set_var_list]))

        rule_mask = []
        for target in revert_target_list:
            t_val = bool(int(m.evaluate(target, model_completion=True).as_long()))
            rule_mask.append(t_val)
        rule_mask = _merge_revert_result(revert_list, rule_mask)
        modify_rule_masks.append(rule_mask)

        sel_index = par_system.getSelectedRuleIndex(z3_var_eval_dict)
        added_formula = par_system.getNewConditionInFormula(z3_var_eval_dict)
        result_modify.append({'index': sel_index, 'new_condition': added_formula})
    s.pop()

    return result_delete, result_modify, delete_rule_masks, modify_rule_masks


def filterFlipping(trace: Trace, target_action: str, span: datetime.timedelta=datetime.timedelta(seconds=3)):
    target_action_cap, target_action_val = target_action.split('=')
    
    # step 1: identify flippings, mark indexs
    canceled_index_set = set()
    for index in range(len(trace.actions)):
        time, action = trace.actions[index]
        is_ext = trace.is_ext_list[index]
        if action == target_action and is_ext:
            # this is a candidate, need to check whether it is reverted
            indexs_post = [ii
                           for action_tup, ii in zip(trace.actions, range(len(trace.actions)))
                           if action_tup[0] >= time and action_tup[0] < time+span]
            for index_p in indexs_post:
                if trace.is_ext_list[index_p] and trace.actions[index_p][1].startswith(target_action_cap):
                    if trace.actions[index_p][1].split('=')[1] != target_action_val:
                        # this is a reverted action
                        canceled_index_set.add(index)
                        canceled_index_set.add(index_p)

    # step 2: generate new trace with the new action lists
    init_actions = [(trace.actions[index][0], trace.actions[index][1], trace.is_ext_list[index]) 
                    for index in range(len(trace.actions)) if index not in canceled_index_set]

    new_trace = Trace(trace.initial_state, trace.system, init_actions, start_time=trace.start_time, end_time=trace.end_time)

    return new_trace
