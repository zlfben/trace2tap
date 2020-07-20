import backend.models as m
from backend.util import trigger_to_clause, state_to_clause, time_to_int, action_to_clause
from autotap.variable import generate_all_device_templates, generate_boolean_map
import re
import ast
import itertools
import sys
import os
import collections
import webcolors
import colorsys
from autotapmc.model.Tap import Tap


def split_autotap_formula(formula):
    # should not be location/music
    if formula.startswith('tick['):
        formula = formula[5:-1]
    if '*' in formula:
        formula = formula.split('*')[1]
    if '#' in formula:
        formula = formula.split('#')[1]
    if '<=' in formula:
        st_list = formula.split('<=')
        if len(st_list) == 2:
            dev_cap_par = formula.split('<=')[0].strip()
            val = formula.split('<=')[1].strip()
            comp = '<='
        else:
            # ugly handler of interval, which the interface doesn't support
            val1 = st_list[0]
            dev_cap_par = st_list[1].strip()
            val2 = st_list[2]
            if val1 == val2:
                comp = '='
                val = val1
            else:
                raise Exception('unsupported AutoTap statement %s' % formula)
    elif '>=' in formula:
        dev_cap_par = formula.split('>=')[0].strip()
        val = formula.split('>=')[1].strip()
        comp = '>='
    elif '<' in formula:
        dev_cap_par = formula.split('<')[0].strip()
        val = formula.split('<')[1].strip()
        comp = '<'
    elif '>' in formula:
        dev_cap_par = formula.split('>')[0].strip()
        val = formula.split('>')[1].strip()
        comp = '>'
    elif '=' in formula:
        dev_cap_par = formula.split('=')[0].strip()
        val = formula.split('=')[1].strip()
        comp = '='
    else:
        raise Exception('formula %s could not be splited' % formula)
    dev = dev_cap_par.split('.')[0].strip()
    cap_par = dev_cap_par.split('.')[1].strip()
    cap = '_'.join(cap_par.split('_')[:-1])
    par = cap_par.split('_')[-1]
    return dev, cap, par, comp, val


def _dev_name_to_autotap(name):
    name = name.replace(' ', '_').lower()
    name = ''.join([ch for ch in name if ch.isalnum() or ch == '_'])
    return name


def dev_name_to_autotap(name):
    return _dev_name_to_autotap(name)


def _cap_name_to_autotap(name):
    name = name.replace(' ', '_')
    name = ''.join([ch for ch in name if ch.isalnum() or ch == '_'])
    name = name.lower()
    return name


def cap_name_to_autotap(name):
    return _cap_name_to_autotap(name)


def _var_name_to_autotap(name):
    name = name.replace(' ', '_')
    return name


def var_name_to_autotap(name):
    return _var_name_to_autotap(name)


def _set_opt_to_autotap(opt):
    opt = opt.replace(' ', '').replace('&', 'n').replace('-', '').capitalize()
    return opt


def _color_to_autotap(color):
    hue, saturation = color.split(',')
    hue = int(hue) * 1.0 / 100
    saturation = int(saturation) * 1.0 / 100
    value = 1
    r, g, b = colorsys.hsv_to_rgb(hue, saturation, value)
    r *= 255
    g *= 255
    b *= 255

    current_color = None
    min_diff = None
    for key in webcolors.CSS3_NAMES_TO_HEX:
        rc, gc, bc = webcolors.hex_to_rgb(webcolors.CSS3_NAMES_TO_HEX[key])
        rd = (r - rc) * (r - rc)
        gd = (g - gc) * (g - gc)
        bd = (b - bc) * (b - bc)
        diff = rd + gd + bd
        min_diff = diff if min_diff is None else min(min_diff, diff)
        current_color = key if min_diff is None or min_diff < diff else current_color
    
    return current_color


def _regular_statement_clause_generator(dev_autotap, cap_autotap, par_autotap, comp, val, neg,
                                        location=None, use_label=False):
    """
    handle non-special case (not location, not music)
    :param dev_autotap:
    :param cap_autotap:
    :param par_autotap:
    :param comp:
    :param val:
    :param neg:
    :param location:
    :param use_label
    :return: parameters, parameter_vals
    """
    if location:
        dev_list_backend = list(m.Device.objects.filter(location=location).order_by('id'))
    else:
        dev_list_backend = list(m.Device.objects.all().order_by('id'))
    if use_label:
        dev_name_list = [_dev_name_to_autotap(dev.label if dev.dev_type == 'st' else dev.name)
                         for dev in dev_list_backend]
    else:
        dev_name_list = [_dev_name_to_autotap(dev.name) for dev in dev_list_backend]
    device = dev_list_backend[dev_name_list.index(dev_autotap)]
    if par_autotap == 'bpm':
        par_autotap = par_autotap.upper()
    # Step 1: find the device

    # Step 2: find the capability
    cap_list_backend = list(device.caps.all().order_by('id'))
    cap_name_list = [_cap_name_to_autotap(cap.name) for cap in cap_list_backend]
    capability = cap_list_backend[cap_name_list.index(cap_autotap)]

    # Step 3: fill in the parameters and values
    parameters = list()
    parameter_vals = list()

    par_list_backend = list(capability.parameter_set.all().order_by('id'))
    if len(par_list_backend) != 1:
        raise Exception('par-val num is not 1 for capability: %s (%d)' % (capability.name, capability.id))
    parameter = par_list_backend[0]
    parameters.append({'id': parameter.id, 'name': parameter.name, 'type': parameter.type})
    if parameter.type == 'bin':
        bin_param = m.BinParam.objects.get(id=parameter.id)
        if (val == 'true') == (not neg):
            value = bin_param.tval
        else:
            value = bin_param.fval
        parameters[-1]['values'] = [bin_param.tval, bin_param.fval]
        parameter_vals.append({'comparator': '=', 'value': value})
    elif parameter.type == 'range':
        if (comp == '<' and (not neg)) or (comp == '>=' and neg):
            comparator = '<'
        elif (comp == '>' and (not neg)) or (comp == '<=' and neg):
            comparator = '>'
        elif (comp == '<=' and (not neg)) or (comp == '>' and neg):
            # comparator = '<='
            comparator = '<'  # current interface don't support "<=", so we use "<" instead.
        elif (comp == '>=' and (not neg)) or (comp == '<' and neg):
            # comparator = '>='
            comparator = '>'  # current interface don't support "<=", so we use "<" instead.
        elif comp == '=' and not neg:
            comparator = '='
        elif comp == '=' and neg:
            comparator = '!='
        else:
            raise Exception('Failed to translate with comparator %s' % comp)
        parameter_vals.append({'comparator': comparator, 'value': float(val)})
    elif parameter.type == 'set':
        # get all set options
        option_list = list(m.SetParamOpt.objects.filter(param_id=parameter.id).order_by('id'))
        option_autotap_list = [_set_opt_to_autotap(opt.value) for opt in option_list]
        # find the correct option
        option = option_list[option_autotap_list.index(val)]
        parameter_vals.append({'comparator': '=' if not neg else '!=', 'value': option.value})
    else:
        raise Exception('unknown parameter type %s' % parameter.type)

    return parameters, parameter_vals


def _location_statement_clause_generator(dev_autotap, cap_autotap, par_autotap, comp, val, neg):
    """
    handle special case: it is a location sensor statement
    :param dev_autotap:
    :param cap_autotap:
    :param par_autotap:
    :param comp:
    :param val:
    :param neg:
    :return:
    """
    dev_list_backend = list(m.Device.objects.all().order_by('id'))
    dev_name_list = [_dev_name_to_autotap(dev.name) for dev in dev_list_backend]
    device = dev_list_backend[dev_name_list.index(dev_autotap)]

    param_location = m.Parameter.objects.get(id=70)
    param_person = m.Parameter.objects.get(id=71)
    location_list = list(m.SetParamOpt.objects.filter(param_id=70).order_by('id'))
    person_list = list(m.SetParamOpt.objects.filter(param_id=71).order_by('id'))
    location_autotap_list = [_cap_name_to_autotap(loc.value) for loc in location_list]
    person_autotap_list = [_cap_name_to_autotap(per.value) for per in person_list]
    location_person_list = list(itertools.product(location_list, person_list))
    location_person_autotap_list = [loc+'_'+per for loc, per in
                                    list(itertools.product(location_autotap_list, person_autotap_list))]

    cap_par_autotap = cap_autotap + '_' + par_autotap
    location, person = location_person_list[location_person_autotap_list.index(cap_par_autotap)]

    parameters = []
    parameter_vals = []

    parameters.append({'id': 70, 'name': param_location.name, 'type': param_location.type})
    parameters.append({'id': 71, 'name': param_person.name, 'type': param_person.type})

    if (val == 'true') == (not neg):
        parameter_vals.append({'comparator': '=', 'value': location.value})
        parameter_vals.append({'comparator': '=', 'value': person.value})
    else:
        parameter_vals.append({'comparator': '!=', 'value': location.value})
        parameter_vals.append({'comparator': '=', 'value': person.value})

    return parameters, parameter_vals


def _music_statement_clause_generator(val, comp, neg):
    if val == 'Stop':
        return list(), list()
    else:
        genre_list = list(m.SetParamOpt.objects.filter(param_id=8))
        genre_autotap_list = [_set_opt_to_autotap(opt.value) for opt in genre_list]
        genre = genre_list[genre_autotap_list.index(val)]

        param = m.Parameter.objects.get(id=8)

        parameters = list()
        parameter_vals = list()

        parameters.append({'id': param.id, 'name': param.name, 'type': param.type})
        if (comp == '=') == (not neg):
            parameter_vals.append({'comparator': '=', 'value': genre.value})
        else:
            parameter_vals.append({'comparator': '!=', 'value': genre.value})
        return parameters, parameter_vals


def _clock_statement_clause_generator(val, comp, neg):
    val = int(val)
    seconds = val % 60
    val //= 60
    minutes = val % 60
    val //= 60
    hours = val % 60

    parameters = list()
    parameter_vals = list()

    param = m.Parameter.objects.get(id=23)  # TODO: very hard code, should work around this later
    
    parameters.append({'id': param.id, 'name': param.name, 'type': param.type})

    reverse_comp_dict = {
        '=': '!=',
        '!=': '=',
        '<': '>=',
        '>': '<=',
        '<=': '>',
        '>=': '<',
    }
    real_comp = comp if not neg else reverse_comp_dict[comp]

    # the value: seconds should be zero so we ignore it
    value = '%02d:%02d' % (hours, minutes)
    parameter_vals.append({'comparator': real_comp, 'value': value})

    return parameters, parameter_vals


def _guess_channel(device, capability):
    dev_chans = set(device.chans.all())
    cap_chans = set(capability.channels.all())
    chans = dev_chans.intersection(cap_chans)
    return chans.pop()


def _fetch_capability(cap_autotap):
    cap_list = list(m.Capability.objects.all().order_by('id'))
    cap_autotap_list = [_cap_name_to_autotap(cap.name) for cap in cap_list]
    return cap_list[cap_autotap_list.index(cap_autotap)]


def _update_clause_text(clause, use_label=False):
    parameters = clause['parameters']
    parameter_vals = clause['parameterVals']
    text = clause['capability']['label']

    if not use_label or 'label' not in clause['device'] or not clause['device']['label']:
        text = re.sub(r'{DEVICE}', clause['device']['name'], text)
    else:
        text = re.sub(r'{DEVICE}', clause['device']['label'], text)

    for p_dct, p_val_dct in zip(parameters, parameter_vals):
        # substitute the text here
        if p_dct['type'] == 'bin':
            # substitute {name/T|xxx} and {name/F|xxx}
            t_val = m.BinParam.objects.get(id=p_dct['id']).tval
            t_temp = r'{%s/T|([\w &\-]+)}'.replace('|', r'\|') % p_dct['name']
            f_temp = r'{%s/F|([\w &\-]+)}'.replace('|', r'\|') % p_dct['name']
            t_sub = r'\1' if (p_val_dct['value'] == t_val) == (p_val_dct['comparator'] == '=') else r''
            f_sub = r'' if (p_val_dct['value'] == t_val) == (p_val_dct['comparator'] == '=') else r'\1'
            text = re.sub(t_temp, t_sub, text)
            text = re.sub(f_temp, f_sub, text)
        if p_dct['type'] == 'meta':
            # substitute {$trigger$}
            temp = r'{\$%s\$}' % p_dct['name']
            if 'text' not in p_val_dct['value']:
                p_val_dct['value'] = _update_clause_text(p_val_dct['value'])
            sub = p_val_dct['value']['text']
            text = re.sub(temp, sub, text)

        # substitute comp {name/<|xxx}, ...
        eq_temp = r'{%s/=|([\w &\-]+)}'.replace('|', r'\|') % p_dct['name']
        neq_temp = r'{%s/!=|([\w &\-]+)}'.replace('|', r'\|') % p_dct['name']
        geq_temp = r'{%s/>=|([\w &\-]+)}'.replace('|', r'\|') % p_dct['name']
        leq_temp = r'{%s/<=|([\w &\-]+)}'.replace('|', r'\|') % p_dct['name']
        gt_temp = r'{%s/>|([\w &\-]+)}'.replace('|', r'\|') % p_dct['name']
        lt_temp = r'{%s/<|([\w &\-]+)}'.replace('|', r'\|') % p_dct['name']

        eq_sub = r'\1' if p_val_dct['comparator'] == '=' else r''
        neq_sub = r'\1' if p_val_dct['comparator'] == '!=' else r''
        geq_sub = r'\1' if p_val_dct['comparator'] == '>=' else r''
        leq_sub = r'\1' if p_val_dct['comparator'] == '<=' else r''
        gt_sub = r'\1' if p_val_dct['comparator'] == '>' else r''
        lt_sub = r'\1' if p_val_dct['comparator'] == '<' else r''

        text = re.sub(eq_temp, eq_sub, text)
        text = re.sub(neq_temp, neq_sub, text)
        text = re.sub(geq_temp, geq_sub, text)
        text = re.sub(leq_temp, leq_sub, text)
        text = re.sub(gt_temp, gt_sub, text)
        text = re.sub(lt_temp, lt_sub, text)

        # substitute value {name}
        temp = r'{%s}' % p_dct['name']
        sub = r'%s' % str(p_val_dct['value'])
        text = re.sub(temp, sub, text)

    clause['text'] = text
    return clause


def _negate_clause(clause):
    parameters = clause['parameters']
    parameter_vals = clause['parameterVals']
    if len(parameters) == 0:
        # 0-param cap: don't know how to negate
        pass
    elif len(parameters) == 1:
        # 1-param cap: bin - reverse, range - reverse comparator, set - reverse comparator
        for par, par_val in zip(parameters, parameter_vals):
            if par['type'] == 'bin':
                t_val = m.BinParam.objects.get(id=par['id']).tval
                f_val = m.BinParam.objects.get(id=par['id']).fval
                if par_val['value'] == t_val:
                    par_val['value'] = f_val
                else:
                    par_val['value'] = t_val
            elif par['type'] in ['range', 'set']:
                if par_val['comparator'] == '=':
                    par_val['comparator'] = '!='
                elif par_val['comparator'] == '!=':
                    par_val['comparator'] = '='
                elif par_val['comparator'] == '>=':
                    par_val['comparator'] = '<'
                elif par_val['comparator'] == '<=':
                    par_val['comparator'] = '>'
                elif par_val['comparator'] == '>':
                    par_val['comparator'] = '<='
                elif par_val['comparator'] == '<':
                    par_val['comparator'] = '>='
                else:
                    raise Exception('unexpected comparator %s' % par_val['comparator'])
            else:
                raise Exception('unable to negate clause: %s' % clause('text'))
    elif len(parameters) == 2:
        # 2-param cap: location - reverse comparator of location, history - reverse comparator of time
        # check if it is location or history
        if clause['capability']['id'] in [49, 50, 51, 52]:
            # history channel
            for par, par_val in zip(parameters, parameter_vals):
                if par['type'] == 'duration':
                    if par_val['comparator'] == '=':
                        par_val['comparator'] = '!='
                    elif par_val['comparator'] == '!=':
                        par_val['comparator'] = '='
                    elif par_val['comparator'] == '>=':
                        par_val['comparator'] = '<'
                    elif par_val['comparator'] == '<=':
                        par_val['comparator'] = '>'
                    elif par_val['comparator'] == '>':
                        par_val['comparator'] = '<='
                    elif par_val['comparator'] == '<':
                        par_val['comparator'] = '>='
                    else:
                        raise Exception('unexpected comparator %s' % par_val['comparator'])
        elif clause['capability']['id'] in [63]:
            # location sensor
            for par, par_val in zip(parameters, parameter_vals):
                if par['id'] == 70:
                    if par_val['comparator'] == '=':
                        par_val['comparator'] = '!='
                    elif par_val['comparator'] == '!=':
                        par_val['comparator'] = '='
                    else:
                        raise Exception('unexpected comparator %s' % par_val['comparator'])

    clause = _update_clause_text(clause)
    return clause


def autotap_simple_formula_to_clause(formula, flag=0, location=None, use_label=False, skip_channel=False):
    if location:
        dev_list_backend = list(m.Device.objects.filter(location=location).order_by('id'))
    else:
        dev_list_backend = list(m.Device.objects.all().order_by('id'))

    if not use_label:
        dev_name_list = [_dev_name_to_autotap(dev.name) for dev in dev_list_backend]
    else:
        dev_name_list = [_dev_name_to_autotap(dev.label if dev.dev_type == 'st' else dev.name)
                         for dev in dev_list_backend]

    clause = dict()

    # extract "neg" out
    if formula.startswith('!'):
        neg = True
        formula = formula[1:]
    else:
        neg = False

    # split the formula statement
    dev_autotap, cap_autotap, par_autotap, comp, val = split_autotap_formula(formula)
    device = dev_list_backend[dev_name_list.index(dev_autotap)]

    # interprete dev, cap and par
    if dev_autotap == 'location_sensor':
        # special case 1: location sensor
        parameters, parameter_vals = _location_statement_clause_generator(
            dev_autotap, cap_autotap, par_autotap, comp, val, neg)
        capability = m.Capability.objects.get(id=63)
    elif cap_autotap == 'genre' and par_autotap == 'genre':
        # special case 2: music
        if val == 'Stop':
            capability = m.Capability.objects.get(id=56)
        else:
            capability = m.Capability.objects.get(id=9)
        parameters, parameter_vals = _music_statement_clause_generator(val, comp, neg)
    elif cap_autotap == 'clock' and par_autotap == 'time':
        parameters, parameter_vals = _clock_statement_clause_generator(val, comp, neg)
        capability = m.Capability.objects.get(id=25)
    else:
        # non-special case
        parameters, parameter_vals = _regular_statement_clause_generator(
            dev_autotap, cap_autotap, par_autotap, comp, val, neg, location, use_label)
        capability = _fetch_capability(cap_autotap)

    label = capability.statelabel if flag == 0 else (capability.eventlabel if flag == 1 else capability.commandlabel)
    if not skip_channel:
        channel = _guess_channel(device, capability)
        clause['channel'] = {'id': channel.id, 'name': channel.name, 'icon': channel.icon}
    clause['device'] = {'id': device.id, 'name': device.name,
                        'label': device.label if device.dev_type == 'st' else ''}
    clause['capability'] = {'id': capability.id, 'name': capability.name, 'label': label}
    clause['parameters'] = parameters
    clause['parameterVals'] = parameter_vals

    # also should send back text
    clause = _update_clause_text(clause, use_label)
    return clause


def seconds_to_time(value):
    seconds = value % 60
    value //= 60
    minutes = value % 60
    value //= 60
    hours = value
    return {
        'hours': hours,
        'minutes': minutes,
        'seconds': seconds
    }


def autotap_formula_to_clause(formula, flag=0):
    """

    :param formula: the tap formula such as 'ac.power=false'
    :param flag: 0 - state, 1 - event, 2 - command
    :return:
    """
    if formula.startswith('tick'):
        formula = formula[5:-1]
        if '*' in formula:
            # it becomes true that negative was last in effect more than time ago
            time = formula.split('*')[0]
            statement = formula.split('*')[1]
            statement_clause = autotap_simple_formula_to_clause(statement, 0)
            statement_clause = _negate_clause(statement_clause)
            device = m.Device.objects.get(id=11)
            capability = m.Capability.objects.get(id=51)
            channel = _guess_channel(device, capability)
            parameters = [{'id': 55, 'name': 'trigger', 'type': 'meta'}, {'id': 56, 'name': 'time', 'type': 'duration'}]
            parameter_vals = [{'comparator': '=', 'value': statement_clause}, {'comparator': '>', 'value': seconds_to_time(int(time))}]
            clause = {
                'device': {'id': device.id, 'name': device.name},
                'capability': {'id': capability.id, 'name': capability.name, 'label': capability.eventlabel},
                'channel': {'id': channel.id, 'name': channel.name, 'icon': channel.icon},
                'parameters': parameters,
                'parameterVals': parameter_vals}
            return _update_clause_text(clause)
        elif '#' in formula:
            # it becomes true that event last happened more than time ago
            time = formula.split('#')[0]
            statement = formula.split('#')[1]
            statement_clause = autotap_simple_formula_to_clause(statement, 1)
            statement_clause = _negate_clause(statement_clause)
            device = m.Device.objects.get(id=11)
            capability = m.Capability.objects.get(id=52)
            channel = _guess_channel(device, capability)
            parameters = [{'id': 57, 'name': 'trigger', 'type': 'meta'}, {'id': 58, 'name': 'time', 'type': 'duration'}]
            parameter_vals = [{'comparator': '=', 'value': statement_clause}, {'comparator': '>', 'value': seconds_to_time(int(time))}]
            clause = {
                'device': {'id': device.id, 'name': device.name},
                'capability': {'id': capability.id, 'name': capability.name, 'label': capability.eventlabel},
                'channel': {'id': channel.id, 'name': channel.name, 'icon': channel.icon},
                'parameters': parameters,
                'parameterVals': parameter_vals}
            return _update_clause_text(clause)
        else:
            raise Exception('unknown tick formula %s' % formula)
    elif '*' in formula:
        # negative was last in effect more than time ago
        time = formula.split('*')[0]
        if time.startswith('!'):
            neg = True
            time = time[1:]
        else:
            neg = False
        statement = formula.split('*')[1]
        statement_clause = autotap_simple_formula_to_clause(statement, 0)
        statement_clause = _negate_clause(statement_clause)
        device = m.Device.objects.get(id=11)
        capability = m.Capability.objects.get(id=51)
        channel = _guess_channel(device, capability)
        parameters = [{'id': 55, 'name': 'trigger', 'type': 'meta'}, {'id': 56, 'name': 'time', 'type': 'duration'}]
        parameter_vals = [{'comparator': '=', 'value': statement_clause},
                          {'comparator': '>' if not neg else '<', 'value': seconds_to_time(int(time))}]
        clause = {
            'device': {'id': device.id, 'name': device.name},
            'capability': {'id': capability.id, 'name': capability.name, 'label': capability.statelabel},
            'channel': {'id': channel.id, 'name': channel.name, 'icon': channel.icon},
            'parameters': parameters,
            'parameterVals': parameter_vals}
        return _update_clause_text(clause)
    elif '#' in formula:
        # happen less than time ago
        time = formula.split('#')[0]
        if time.startswith('!'):
            neg = True
            time = time[1:]
        else:
            neg = False
        statement = formula.split('#')[1]
        statement_clause = autotap_simple_formula_to_clause(statement, 1)
        statement_clause = _negate_clause(statement_clause)
        device = m.Device.objects.get(id=11)
        capability = m.Capability.objects.get(id=52)
        channel = _guess_channel(device, capability)
        parameters = [{'id': 57, 'name': 'trigger', 'type': 'meta'}, {'id': 58, 'name': 'time', 'type': 'duration'}]
        parameter_vals = [{'comparator': '=', 'value': statement_clause},
                          {'comparator': '<' if not neg else '>', 'value': seconds_to_time(int(time))}]
        clause = {
            'device': {'id': device.id, 'name': device.name},
            'capability': {'id': capability.id, 'name': capability.name, 'label': capability.statelabel},
            'channel': {'id': channel.id, 'name': channel.name, 'icon': channel.icon},
            'parameters': parameters,
            'parameterVals': parameter_vals}
        return _update_clause_text(clause)
    else:
        return autotap_simple_formula_to_clause(formula, flag)


def autotapta_formula_to_clause(formula, flag=0, location=None, use_label=True, skip_channel=True):
    """

    :param formula: the tap formula such as 'ac.power=false'
    :param flag: 0 - state, 1 - event, 2 - command
    :param location: the location of the device
    :param user_label: whether to use label of devices or name of devices
    :param skip_channel: whether or not to skip finding the channel
    :return:
    """
    if '*' in formula and flag == 1:
        # it becomes true that negative was last in effect more than time ago
        time, statement = formula.split('*')
        statement_clause = autotap_simple_formula_to_clause(statement, 0, location, use_label, skip_channel)
        # statement_clause = _negate_clause(statement_clause)
        if location:
            device = m.Device.objects.get(name='Clock', location=location)
        else:
            device = m.Device.objects.get(id=11)
        capability = m.Capability.objects.get(id=51)
        parameters = [{'id': 55, 'name': 'trigger', 'type': 'meta'}, {'id': 56, 'name': 'time', 'type': 'duration'}]
        parameter_vals = [{'comparator': '=', 'value': statement_clause}, {'comparator': '>', 'value': seconds_to_time(int(time))}]
        if not skip_channel:
            channel = _guess_channel(device, capability)
            clause = {
                'device': {'id': device.id, 'name': device.name, 'label': ''},
                'capability': {'id': capability.id, 'name': capability.name, 'label': capability.eventlabel},
                'channel': {'id': channel.id, 'name': channel.name, 'icon': channel.icon},
                'parameters': parameters,
                'parameterVals': parameter_vals}
        else:
            clause = {
                'device': {'id': device.id, 'name': device.name, 'label': ''},
                'capability': {'id': capability.id, 'name': capability.name, 'label': capability.eventlabel},
                'parameters': parameters,
                'parameterVals': parameter_vals}
        return _update_clause_text(clause, use_label)
    elif '#' in formula and flag == 1:
        # it becomes true that event last happened more than time ago
        time = formula.split('#')[0]
        statement = formula.split('#')[1]
        # statement_clause = _negate_clause(statement_clause)
        if location:
            device = m.Device.objects.get(name='Clock', location=location)
        else:
            device = m.Device.objects.get(id=11)
        capability = m.Capability.objects.get(id=52)
        parameters = [{'id': 57, 'name': 'trigger', 'type': 'meta'}, {'id': 58, 'name': 'time', 'type': 'duration'}]
        parameter_vals = [{'comparator': '=', 'value': statement_clause}, {'comparator': '>', 'value': seconds_to_time(int(time))}]
        if not skip_channel:
            channel = _guess_channel(device, capability)
            clause = {
                'device': {'id': device.id, 'name': device.name, 'label': ''},
                'capability': {'id': capability.id, 'name': capability.name, 'label': capability.eventlabel},
                'channel': {'id': channel.id, 'name': channel.name, 'icon': channel.icon},
                'parameters': parameters,
                'parameterVals': parameter_vals}
        else:
            clause = {
                'device': {'id': device.id, 'name': device.name, 'label': ''},
                'capability': {'id': capability.id, 'name': capability.name, 'label': capability.eventlabel},
                'parameters': parameters,
                'parameterVals': parameter_vals}
        return _update_clause_text(clause, use_label)
    else:
        return autotap_simple_formula_to_clause(formula, flag, location, use_label, skip_channel)


def tap_to_frontend_view(tap):
    # tap should be in formula format, need translation from autotap
    trigger_clause = autotap_formula_to_clause(tap.trigger, 1)
    channel_clause_list = [autotap_formula_to_clause(cond, 0) for cond in tap.condition]
    if not isinstance(tap.action, list):
        tap_action = [tap.action]
    else:
        tap_action = tap.action
    action_clause_list = [autotap_formula_to_clause(action, 2) for action in tap_action]

    clause = dict()
    clause['ifClause'] = [trigger_clause] + channel_clause_list
    clause['thenClause'] = action_clause_list
    clause['temporality'] = 'event-state'

    return clause


def tap_to_frontend_view_ta(tap, location):
    # tap should be in formula format, need translation from autotap
    trigger_clause = autotapta_formula_to_clause(tap.trigger, 1, use_label=True, location=location)
    channel_clause_list = [autotapta_formula_to_clause(cond, 0, use_label=True, location=location) 
                           for cond in tap.condition]
    if not isinstance(tap.action, list):
        tap_action = [tap.action]
    else:
        tap_action = tap.action
    action_clause_list = [autotapta_formula_to_clause(action, 2, use_label=True, location=location) 
                          for action in tap_action]

    clause = dict()
    clause['ifClause'] = [trigger_clause] + channel_clause_list
    clause['thenClause'] = action_clause_list
    clause['temporality'] = 'event-state'

    return clause


def backend_to_frontend_view(rule):
    # translate m.Rule into frontend json format
    rule = rule.esrule
    ifclause = []
    t = rule.Etrigger
    ifclause.append(trigger_to_clause(t,True))
    for t in sorted(rule.Striggers.all(),key=lambda x: x.pos):
        ifclause.append(trigger_to_clause(t,False))

    a = rule.action
    thenclause = state_to_clause(a)

    json_resp = {'id' : rule.id,
                 'ifClause' : ifclause,
                 'thenClause' : [thenclause],
                 'temporality' : 'event-state'}

    return json_resp


def check_action_external(action, template_dict):
    var, val = action.split('=')
    dev, cap = var.split('.')
    return 'external' in template_dict[dev][cap]


def pv_clause_to_autotap_statement(dev_c, cap_c, par_c, val):
    if dev_c['label']:
        dev_name = _dev_name_to_autotap(dev_c['label'])
    else:
        dev_name = _dev_name_to_autotap(dev_c['name'])
    var_name = cap_c['name'] + ' ' + par_c['name']
    var_name = _var_name_to_autotap(var_name)
    var_name = ''.join([ch for ch in var_name if ch.isalnum() or ch == '_'])
    var_name = var_name.lower()
    var_name = dev_name + '.' + var_name

    if par_c['type'] == 'bin':
        value = 'false' if val == m.BinParam.objects.get(id=par_c['id']).fval else 'true'
        clause_statement = var_name + '=' + value
    elif par_c['type'] in ('range', 'set', 'color'):
        clause_statement = var_name + '=' + _set_opt_to_autotap(str(val))
    else:
        raise Exception('not supported type: %s' % par_c['type'])
    return clause_statement


def trigger_to_autotap_statement(clause, if_event=False):
    irregular_cap_list = [9, 25, 26, 56, 35, 30, 31, 33, 32, 52, 51, 49, 50, 29, 63, 37]
    dev_name = clause['device']['label'] \
               if ('label' in clause['device'] and clause['device']['label'] != '') \
               else clause['device']['name']
    dev_name = _dev_name_to_autotap(dev_name)
    dev_name = ''.join([ch for ch in dev_name if ch.isalnum() or ch == '_'])
    if clause['capability']['id'] not in irregular_cap_list:
        # should be only one parameter
        param = clause['parameters'][0]
        param_val = clause['parameterVals'][0]

        if param['type'] == 'bin':
            var_name = clause['capability']['name'] + ' ' + param['name']
            var_name = _var_name_to_autotap(var_name)
            var_name = ''.join([ch for ch in var_name if ch.isalnum() or ch == '_'])
            var_name = var_name.lower()

            var_name = dev_name + '.' + var_name
            if param_val['comparator'] == '=':
                value = 'false' if param_val['value'] == m.BinParam.objects.get(id=param['id']).fval else 'true'
            else:
                value = 'true' if param_val['value'] == m.BinParam.objects.get(id=param['id']).fval else 'false'
            clause_statement = var_name + param_val['comparator'] + value

        elif param['type'] in ('range', 'set', 'color'):
            var_name = clause['capability']['name'] + ' ' + param['name']
            var_name = _var_name_to_autotap(var_name)
            var_name = ''.join([ch for ch in var_name if ch.isalnum() or ch == '_'])
            var_name = var_name.lower()

            var_name = dev_name + '.' + var_name
            if param['type'] != 'color':
                clause_statement = var_name + param_val['comparator'] + _set_opt_to_autotap(str(param_val['value']))
            else:
                clause_statement = var_name + param_val['comparator'] + _color_to_autotap(str(param_val['value']))

        else:
            raise Exception('not supported type: %s' % param['type'])
    else:
        if clause['capability']['id'] == 63:
            # this is location sensor
            param_list = clause['parameters']
            param_val_list = clause['parameterVals']

            location_val = param_val_list[0] if param_list[0]['name'] == 'location' else param_val_list[1]
            who_val = param_val_list[0] if param_list[0]['name'] == 'who' else param_val_list[1]

            var_name = location_val['value'] + ' ' + who_val['value']
            var_name = _var_name_to_autotap(var_name)
            var_name = ''.join([ch for ch in var_name if ch.isalnum() or ch == '_'])
            var_name = var_name.lower()

            var_name = dev_name + '.' + var_name

            if location_val['comparator'] != '!=' and who_val['comparator'] != '!=':
                clause_statement = var_name + '=' + 'true'
            else:
                clause_statement = var_name + '=' + 'false'
        elif clause['capability']['id'] in [9, 35, 56]:
            # start/stop playing music
            # stop is 0-parameter cap
            # start is 1-parameter cap
            # 9: start playing genre, 35: start playing some music (not supported), 56: stop
            var_name = 'genre_genre'

            var_name = dev_name + '.' + var_name
            if clause['capability']['id'] == 9:
                param_list = clause['parameters']
                param_val_list = clause['parameterVals']
                genre_val = param_val_list[0]
                if not genre_val['comparator'].strip():
                    genre_val['comparator'] = '='  # ugly fix for bug
                clause_statement = var_name + genre_val['comparator'] + \
                                   _set_opt_to_autotap(genre_val['value'])
            elif clause['capability']['id'] == 56:
                clause_statement = var_name + '=' + 'Stop'
            else:
                raise Exception('Playing specific music not supported by AutoTap yet')
        elif clause['capability']['id'] in [49, 50, 51, 52]:
            # handle history channel
            if clause['capability']['id'] == 52:
                param_list = clause['parameters']
                param_val_list = clause['parameterVals']

                trigger_val = param_val_list[0] if param_list[0]['name'] == 'trigger' else param_val_list[1]
                time_val = param_val_list[0] if param_list[0]['name'] == 'time' else param_val_list[1]
                time = time_to_int(ast.literal_eval(str(time_val['value'])))
                trigger = trigger_to_autotap_statement(ast.literal_eval(str(trigger_val['value'])), True)
                if not if_event:
                    if time_val['comparator'] == '<':
                        clause_statement = '%d#%s' % (time, trigger)
                    elif time_val['comparator'] == '>':
                        clause_statement = '!%d#%s' % (time, trigger)
                    elif time_val['comparator'] == '=':
                        # this is a wrong condition
                        # there shouldn't be a state saying "something happened exactly xxx time ago"
                        raise Exception('something happened exactly xxx time ago cannot be a state')
                    else:
                        raise Exception('Unknown comparator %s' % time_val['comparator'])
                else:
                    if time_val['comparator'] == '<':
                        clause_statement = trigger
                    elif time_val['comparator'] == '>' or time_val['comparator'] == '=':
                        clause_statement = 'tick[%d#%s]' % (time, trigger)
                    else:
                        raise Exception('Unknown comparator %s' % time_val['comparator'])
            elif clause['capability']['id'] == 51:
                # a condition was last in effect xxx time ago
                # could only be an event
                # now only binary variable supported because of AutoTap's limitation
                param_list = clause['parameters']
                param_val_list = clause['parameterVals']

                trigger_val = param_val_list[0] if param_list[0]['name'] == 'trigger' else param_val_list[1]
                time_val = param_val_list[0] if param_list[0]['name'] == 'time' else param_val_list[1]
                time = time_to_int(ast.literal_eval(str(time_val['value'])))
                trigger = trigger_to_autotap_statement(ast.literal_eval(str(trigger_val['value'])), False)
                if 'false' in trigger:
                    trigger.replace('false', 'true')
                elif 'true' in trigger:
                    trigger.replace('true', 'false')
                else:
                    raise Exception('Only binary variable supported for capability %d' % clause['capability']['id'])

                if if_event:
                    clause_statement = 'tick[%d*%s]' % (time, trigger)
                else:
                    raise Exception('Capability %d doesn\'t have a state form' % clause['capability']['id'])
            elif clause['capability']['id'] == 49:
                # state was active some time ago
                # state version not supported by AutoTap,
                # but the rules in the user study is equivalent to AutoTap's format
                param_list = clause['parameters']
                param_val_list = clause['parameterVals']

                trigger_val = param_val_list[0] if param_list[0]['name'] == 'trigger' else param_val_list[1]
                time_val = param_val_list[0] if param_list[0]['name'] == 'time' else param_val_list[1]
                time = time_to_int(ast.literal_eval(str(time_val['value'])))
                trigger = trigger_to_autotap_statement(ast.literal_eval(str(trigger_val['value'])), True)

                if if_event:
                    # this is equivalent to "event that activated the state happened some time ago"
                    clause_statement = 'tick[%d#%s]' % (time, trigger)
                else:
                    raise Exception('Capability %d not supported in state form' % clause['capability']['id'])
            elif clause['capability']['id'] == 50:
                param_list = clause['parameters']
                param_val_list = clause['parameterVals']
                trigger_val = None
                time_val = None
                occurrence_val = None
                for index, p, pv in zip(range(len(param_list)), param_list, param_val_list):
                    if p['name'] == 'trigger':
                        trigger_val = pv
                    elif p['name'] == 'time':
                        time_val = pv
                    elif p['name'] == 'occurrences':
                        occurrence_val = pv

                trigger = trigger_to_autotap_statement(ast.literal_eval(str(trigger_val['value'])), True)
                time = time_to_int(ast.literal_eval(str(time_val['value'])))

                if occurrence_val['comparator'] == '<':
                    if occurrence_val['value'] == 1:
                        # never happen
                        if if_event:
                            raise Exception('Event frequency not supported by AutoTap')
                        else:
                            clause_statement = '!%d#%s' % (time, trigger)
                    else:
                        raise Exception('Event frequency not supported by AutoTap')
                elif occurrence_val['comparator'] == '>':
                    if occurrence_val['value'] == 0:
                        # happen
                        if if_event:
                            clause_statement = '%s' % trigger
                        else:
                            clause_statement = '%d#%s' % (time, trigger)
                    else:
                        raise Exception('Event frequency not supported by AutoTap')
                elif occurrence_val['comparator'] == '=':
                    if occurrence_val['value'] == 0:
                        # never happen
                        if if_event:
                            raise Exception('Event frequency not supported by AutoTap')
                        else:
                            clause_statement = '!%d#%s' % (time, trigger)
                    elif occurrence_val['value'] == 1:
                        # happen (not perfect interpretation, multiple time is okay)
                        if if_event:
                            clause_statement = '%s' % trigger
                        else:
                            clause_statement = '%d#%s' % (time, trigger)
                    else:
                        raise Exception('Event frequency not supported by AutoTap')
                else:
                    raise Exception('Unknown comparator %s' % occurrence_val['comparator'])
            else:
                raise Exception('Capability %d not supported yet' % clause['capability']['id'])
        elif clause['capability']['id'] in [25]:
            # clock
            clause_statement = 'clock.clock_time'
            par_val = clause['parameterVals'][0]
            hour, minute = par_val['value'].split(':')
            time_value = int(hour) * 3600 + int(minute) * 60
            clause_statement += par_val['comparator']
            clause_statement += str(time_value)
        else:
            # print(clause['capability']['id'], clause['capability']['name'])
            raise Exception('something goes wrong when translating into autotap: %s' % clause['capability']['id'])
    if '!=' in clause_statement:
        clause_statement = '!' + clause_statement.replace('!=', '=') if not clause_statement.startswith('!') \
            else clause_statement.replace('!=', '=')[1:]
    return clause_statement


def _actionize(statement, time=None):
    if time:
        pass
    else:
        if not statement.startswith('!'):
            return '@' + statement
        else:
            statement = statement[1:]
            clause = autotap_formula_to_clause(statement, flag=1)
            if clause['parameters'][0]['type'] == 'bin':
                if 'false' in statement:
                    return '@' + statement.replace('false', 'true')
                else:
                    return '@' + statement.replace('true', 'false')
            elif clause['parameters'][0]['type'] == 'range':
                s_1 = '@' + statement.replace('=', '<')
                s_2 = '@' + statement.replace('=', '>')
                return '(%s | %s)' % (s_1, s_2)
            elif clause['parameters'][0]['type'] == 'set':
                value_list = list(m.SetParamOpt.objects.filter(param_id=clause['parameters'][0]['id']))
                value_autotap_list = [_set_opt_to_autotap(opt.value) for opt in value_list]
                if clause['parameters'][0]['id'] == 8:
                    value_autotap_list.append('Stop')
                orig_value = _set_opt_to_autotap(clause['parameterVals'][0]['value'])
                dev_cap = statement.split('=')[0]
                s_list = ['@%s=%s' % (dev_cap, value) for value in value_autotap_list if value != orig_value]
                return '(' + ' | '.join(s_list) + ')'


def translate_sp_to_autotap_ltl(sp):
    if sp.type == 1:
        sp1 = sp.sp1
        if_always = sp1.always
        triggers = sp1.triggers.all().order_by('pos')
        state_list = list(triggers)

        statement_list = [trigger_to_autotap_statement(trigger_to_clause(trigger, False), False)
                          for trigger in state_list]
        if if_always:
            neg_statement_list = ['!' + statement for statement in statement_list]
            return 'G((%s) | (%s))' % (' & '.join(statement_list), ' & '.join(neg_statement_list))
        else:
            return '!F(%s)' % (' & '.join(statement_list))

    elif sp.type == 2:
        sp2 = sp.sp2
        if_always = sp2.always
        clause = sp2.state
        also_clauses = list(sp2.conds.all().order_by('pos'))

        state = trigger_to_autotap_statement(trigger_to_clause(clause, False), False)
        also_states = [trigger_to_autotap_statement(trigger_to_clause(ac, False), False) for ac in also_clauses]

        if sp2.time:
            comparator = sp2.comp  # always translate into same: this is unused now
            time = sp2.time
            if also_states:
                if if_always:
                    return 'G(!(%s) | (%s W %s*%s))' % (' & '.join([state]+also_states), state, time, state)
                else:
                    return '!F(%s*%s & (%s))' % (time, state, ' & '.join(also_states))
            else:
                if if_always:
                    return 'G(!%s | (%s W %s*%s))' % (state, state, time, state)
                else:
                    return '!F(%s*%s)' % (time, state)
        else:
            if also_states:
                if if_always:
                    return 'G(!(%s) | %s)' % (' & '.join(also_states), state)
                else:
                    return '!F(%s)' % (' & '.join(also_states + [state]))
            else:
                if if_always:
                    return 'G(%s)' % state
                else:
                    return '!F(%s)' % state
    elif sp.type == 3:
        sp3 = sp.sp3
        if_always = sp3.always
        clause = sp3.event
        also_clauses = list(sp3.conds.all().order_by('pos'))

        event = trigger_to_autotap_statement(trigger_to_clause(clause, True), True)
        event_state = trigger_to_autotap_statement(trigger_to_clause(clause, False), False)
        also_states = [trigger_to_autotap_statement(trigger_to_clause(ac, False), False) for ac in also_clauses]

        if sp3.time:
            comparator = sp3.comp  # always translate into same: this is unused now
            time = sp3.time
            if if_always:
                return 'G(!(%s & !%s) | (%s#%s W %s))' % \
                       (_actionize(also_states[0]), event_state, time, also_states[0], _actionize(event))
            else:
                return '!F(%s#%s & X%s)' % (time, also_states[0], _actionize(event))
        else:
            if also_states:
                if if_always:
                    return 'G(!X%s | (%s))' % (_actionize(event), ' & '.join(also_states))
                else:
                    return '!F(%s & X%s)' % (' % '.join(also_states), _actionize(event))
            else:
                if if_always:
                    return 'G(%s)' % _actionize(event)
                else:
                    return '!F(%s)' % _actionize(event)


def translate_rule_into_autotap_tap(rule, use_tick_header=True):
    """

    :param rule:
    :return:
    """
    try:
        esrule = m.ESRule.objects.get(id=rule.id)

        trigger = trigger_to_clause(esrule.Etrigger, True)
        trigger_statement = trigger_to_autotap_statement(trigger, True)

        if not use_tick_header and trigger_statement.startswith('tick['):
            trigger_statement = trigger_statement[5:-1]

        # conditions of the rule
        condition_list = [trigger_to_clause(cond, False) for cond in esrule.Striggers.all()]
        condition_statement_list = [trigger_to_autotap_statement(cond, False) for cond in condition_list]

        # action of the rule
        action = action_to_clause(esrule.action)
        action_statement = trigger_to_autotap_statement(action, True)

        return Tap(action_statement, trigger_statement, condition_statement_list)
    except Exception as exc:
        raise exc


def translate_clause_into_autotap_tap(rule, use_tick_header=True):
    try:
        trigger = rule['ifClause'][0]
        condition_list = rule['ifClause'][1:]
        action = rule['thenClause'][0]

        trigger_statement = trigger_to_autotap_statement(trigger, True)
        if not use_tick_header and trigger_statement.startswith('tick['):
            trigger_statement = trigger_statement[5:-1]
        
        condition_statement_list = [trigger_to_autotap_statement(cond, False) for cond in condition_list]
        action_statement = trigger_to_autotap_statement(action, True)

        return Tap(action_statement, trigger_statement, condition_statement_list)
    except Exception as exc:
        raise exc