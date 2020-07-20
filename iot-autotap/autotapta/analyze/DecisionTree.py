import json
from sklearn import tree
import numpy as np
from datetime import datetime, timedelta
import graphviz


def _varNameToType(var_name, template_dict):
    dev_name, cap_name = var_name.split('.')
    typ_enhance = template_dict[dev_name][cap_name]
    if typ_enhance.startswith('bool'):
        typ = 'bool'
    elif typ_enhance.startswith('set'):
        typ = 'set'
    else:
        typ = 'numeric'

    if 'external' in typ_enhance:
        is_ext = True
    else:
        is_ext = False

    if typ == 'set':
        opt_list = typ_enhance.split('[')[1][:-1].split(', ')
    else:
        opt_list = None

    return typ, is_ext, opt_list


def _getVarList(var_list, var_type_list, only_ext=True, skip_var=None):
    result_var_list = list()
    for var, typ_enhanced in zip(var_list, var_type_list):
        typ, is_ext, opt_list = typ_enhanced
        if (only_ext and is_ext) or not only_ext:
            if var == skip_var:
                continue
            result_var_list.append(var)

    return result_var_list


def _transformField(field, var_list, var_type_list, only_ext=True, skip_var=None):
    new_field = list()
    for var, val, typ_enhanced in zip(var_list, field, var_type_list):
        typ, is_ext, opt_list = typ_enhanced
        if (only_ext and is_ext) or not only_ext:
            if var == skip_var:
                continue
            if typ == 'set':
                new_field.append(float(opt_list.index(val)))
            else:
                new_field.append(float(val))
    return new_field


def traceToTree(trace, target_action, template_dict):
    var_list = trace.system.getFieldNameList()
    var_type_list = [_varNameToType(var, template_dict) for var in var_list]
    ext_var_list = _getVarList(var_list, var_type_list, True)

    example_list = list()
    label_list = list()
    weight_list = list()

    action_var = target_action.split('=')[0]
    action_var_index = var_list.index(action_var)
    if var_type_list[action_var_index][0] == 'bool':
        action_list = ['False', 'True']
    elif var_type_list[action_var_index][0] == 'enumeric':
        action_list = var_type_list[action_var_index][2]
    else:
        raise Exception('range variable not supported as decision tree label yet')

    last_time = None
    for time_action, pre_cond in zip(trace.actions, trace.pre_condition):
        time, action = time_action
        if last_time:
            label = pre_cond[action_var_index]
            # if action == target_action:
            #     label = 1
            # else:
            #     label = 0
            example_list.append(_transformField(pre_cond, var_list, var_type_list))
            weight_list.append(float((time-last_time).total_seconds()))
            label_list.append(label)
        last_time = time

    # clf = tree.DecisionTreeClassifier(max_depth=3, class_weight="balanced", criterion="gini")
    clf = tree.DecisionTreeClassifier(max_depth=4, class_weight="balanced")
    clf = clf.fit(example_list, label_list, sample_weight=weight_list)
    dot_data = tree.export_graphviz(clf, out_file=None, filled=True, feature_names=ext_var_list,
                                    class_names=action_list, special_characters=True)
    dot_data = dot_data.split("\n")
    dot_data.insert(1, "size = \"10,7\";")
    dot_data = "\n".join(dot_data)
    graph = graphviz.Source(dot_data)
    print(graph.render(target_action))
    return graph


def traceToTreeTiming(trace, target_action, template_dict):
    var_list = trace.system.getFieldNameList()
    var_type_list = [_varNameToType(var, template_dict) for var in var_list]
    ext_var_list = _getVarList(var_list, var_type_list, True)

    example_list = list()
    label_list = list()
    weight_list = list()

    duration_var_list = [var for var, typ in zip(var_list, var_type_list) if typ[0] == 'bool' and typ[1]]
    duration_var_true_value = [-1] * len(duration_var_list)
    duration_var_false_value = [-1] * len(duration_var_list)
    duration_var_true_name_list = ['duration true ' + d_var for d_var in duration_var_list]
    duration_var_false_name_list = ['duration false ' + d_var for d_var in duration_var_list]

    action_var = target_action.split('=')[0]
    action_var_index = var_list.index(action_var)
    if var_type_list[action_var_index][0] == 'bool':
        action_list = ['False', 'True']
    elif var_type_list[action_var_index][0] == 'enumeric':
        action_list = var_type_list[action_var_index][2]
    else:
        raise Exception('range variable not supported as decision tree label yet')

    delta_sec = timedelta(seconds=1)
    current_time = trace.actions[0][0] - delta_sec
    current_state = trace.initial_state
    current_index = 0
    while current_index < len(trace.actions):
        label = current_state[action_var_index]
        example_list.append(_transformField(current_state, var_list, var_type_list) +
                            duration_var_true_value + duration_var_false_value)
        weight_list.append(1.0)
        label_list.append(label)

        current_time = current_time + delta_sec
        while current_index < len(trace.actions) and trace.actions[current_index][0] <= current_time:
            current_state = trace.pre_condition[current_index]
            current_index = current_index + 1

        for index_d in range(len(duration_var_list)):
            index = var_list.index(duration_var_list[index_d])
            if current_state[index]:
                if duration_var_false_value[index_d] != -1:
                    duration_var_false_value[index_d] = -1
                duration_var_true_value[index_d] = duration_var_true_value[index_d] + 1
            else:
                if duration_var_true_value[index_d] != -1:
                    duration_var_true_value[index_d] = -1
                duration_var_false_value[index_d] = duration_var_false_value[index_d] + 1

    # clf = tree.DecisionTreeClassifier(max_depth=3, class_weight="balanced", criterion="gini")
    clf = tree.DecisionTreeClassifier(max_depth=4, class_weight="balanced")
    clf = clf.fit(example_list, label_list, sample_weight=weight_list)
    dot_data = tree.export_graphviz(clf, out_file=None, filled=True,
                                    feature_names=ext_var_list +
                                                  duration_var_true_name_list +
                                                  duration_var_false_name_list,
                                    class_names=action_list, special_characters=True)
    dot_data = dot_data.split("\n")
    dot_data.insert(1, "size = \"10,7\";")
    dot_data = "\n".join(dot_data)
    graph = graphviz.Source(dot_data)
    print(graph.render(target_action))
    return graph
