# support for translating variable's values into AutoTap traces
# for example, clustering the range variables and color variables
import backend.models as m
import webcolors
import colorsys
import itertools


light_brightness_sep_list = [
    (float('-inf'), 10, 5), 
    (10, 20, 15), 
    (20, 30, 25), 
    (30, 40, 35), 
    (40, 50, 45), 
    (50, 60, 55), 
    (60, 70, 65), 
    (70, 80, 75), 
    (80, 90, 85), 
    (90, float('inf'), 95)
]


light_color_temp_sep_list = [
    (float('-inf'), 2500, 2250), 
    (2500, 3000, 2750), 
    (3000, 3500, 3250), 
    (3500, 4000, 3750), 
    (4000, 4500, 4250), 
    (4500, 5000, 4750), 
    (5000, 5500, 5250), 
    (5500, 6000, 5750), 
    (6000, float('inf'), 6250)
]


def _dev_name_to_autotap(name):
    name = name.replace(' ', '_').lower()
    name = ''.join([ch for ch in name if ch.isalnum() or ch == '_'])
    return name


def _cap_name_to_autotap(name):
    name = name.replace(' ', '_')
    name = ''.join([ch for ch in name if ch.isalnum() or ch == '_'])
    name = name.lower()
    return name


def _var_name_to_autotap(name):
    name = name.replace(' ', '_')
    return name


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


# TODO: function===>initialize cluster model instances for a device
def initialize_range_sep_for_dev(dev):
    caps = dev.caps.all()
    for cap in caps:
        params = m.Parameter.objects.filter(cap=cap)
        if cap.name == 'Color Temperature':
            # should be only one param
            print('====== Initializing Counter for %s ======' % cap.name)
            param = list(params)[0]
            for min_v, max_v, rep_v in light_color_temp_sep_list:
                m.RangeCounter.objects.create(min=min_v, max=max_v, representative=rep_v, 
                                                    param=param, cap=cap, dev=dev, typ='range')
        elif cap.name == 'Brightness':
            # should be only one param
            print('====== Initializing Counter for %s ======' % cap.name)
            param = list(params)[0]
            for min_v, max_v, rep_v in light_brightness_sep_list:
                m.RangeCounter.objects.create(min=min_v, max=max_v, representative=rep_v, 
                                                    param=param, cap=cap, dev=dev, typ='range')
        elif cap.name == 'Light Color':
            # should be only one param
            # should go use colors in webcolors
            print('====== Initializing Counter for %s ======' % cap.name)
            param = list(params)[0]
            color_dict = webcolors.CSS3_NAMES_TO_HEX
            for color_name in color_dict:
                color = color_dict[color_name]
                rgb = webcolors.hex_to_rgb(color)
                rgb = ','.join([str(rgb.red), str(rgb.green), str(rgb.blue)])
                m.ColorCounter.objects.create(name=color_name, rgb=rgb, 
                                              param=param, dev=dev, cap=cap, typ='color')
        else:
            if cap.writeable:
                # should be added
                print('====== Initializing Counter for %s ======' % cap.name)
                param = list(params)[0]
                typ = param.type
                if typ == 'bin':
                    opts = [param.binparam.tval, param.binparam.fval]
                    for opt in opts:
                        m.BinCounter.objects.create(val=opt,
                                                    param=param, dev=dev, cap=cap, typ=typ)
                elif typ == 'set':
                    opts = [set_opt.value for set_opt in m.SetParamOpt.objects.filter(param=param)]
                    for opt in opts:
                        m.SetCounter.objects.create(val=opt,
                                                    param=param, dev=dev, cap=cap, typ=typ)
                else:
                    pass


def find_closest_color(color_val):
    hue, saturation = color_val.split(',')
    hue = float(hue) / 100
    saturation = float(saturation) / 100
    value = 1.0
    r, g, b = colorsys.hsv_to_rgb(hue, saturation, value)
    min_diff = float('inf')
    current_color = None
    for name, hex_color in webcolors.CSS3_NAMES_TO_HEX.items():
        rgb_c = webcolors.hex_to_rgb(hex_color)
        r_c = rgb_c.red * 1.0 / 255
        g_c = rgb_c.green * 1.0 / 255
        b_c = rgb_c.blue * 1.0 / 255
        diff = (r_c - r) ** 2 + (g_c - g) ** 2 + (b_c - b) ** 2
        if diff < min_diff:
            min_diff = diff
            current_color = name
    return current_color


# TODO: function===>update the current state_log into the separation's count
def update_separation_count(state_log):
    dev = state_log.dev
    cap = state_log.cap
    param = state_log.param

    if not state_log.loc:
        # if loc is blank, this should be an initialization state log
        return

    counters = m.Counter.objects.filter(dev=dev, cap=cap, param=param)

    for counter in counters:
        if counter.typ == 'range':
            range_counter = counter.rangecounter
            if range_counter.min <= float(state_log.value) < range_counter.max:
                range_counter.count += 1
                range_counter.save()
        elif counter.typ == 'color':
            current_color = find_closest_color(state_log.value)
            color_counter = counter.colorcounter
            if current_color == color_counter.name:
                color_counter.count += 1
                color_counter.save()
        elif counter.typ == 'bin':
            bin_counter = counter.bincounter
            if bin_counter.val == state_log.value:
                bin_counter.count += 1
                bin_counter.save()
        elif counter.typ == 'set':
            set_counter = counter.setcounter
            if set_counter.val == state_log.value:
                set_counter.count += 1
                set_counter.save()
        else:
            pass


def generate_reverse_template(loc=None, use_label=True):
    """
    the reverse version
    build a map from autotap's cap to the real (dev, cap)
    """
    rev_map = dict()
    if not loc:
        device_list = m.Device.objects.all()
    else:
        device_list = m.Device.objects.filter(location=loc)
    for dev in device_list:
        if use_label and dev.dev_type == 'st':
            dev_name = _dev_name_to_autotap(dev.label)
        else:
            dev_name = _dev_name_to_autotap(dev.name)
        dev_name = ''.join([ch for ch in dev_name if ch.isalnum() or ch == '_'])

        for cap in dev.caps.all():
            param_list = list(m.Parameter.objects.filter(cap_id=cap.id))
            if len(param_list) == 1:
                # we only consider single-parameter capability
                param = param_list[0]
                var_name = cap.name + ' ' + param.name
                var_name = _var_name_to_autotap(var_name)
                var_name = ''.join([ch for ch in var_name if ch.isalnum() or ch == '_'])
                var_name = var_name.lower()
                if param.type == 'bin':
                    param_map = {'true': param.binparam.tval, 'false': param.binparam.fval}
                elif param.type == 'set':
                    opts = m.SetParamOpt.objects.filter(param=param.setparam)
                    param_map = {_set_opt_to_autotap(opt.value): opt.value for opt in opts}
                else:
                    param_map = {}
                rev_map[dev_name + '.' + var_name] = (dev, cap, param, param_map)
    return rev_map


def generate_all_device_templates(loc=None, use_label=False):
    """

    :return: a complete list of device templates for AutoTap
    """
    template_dict = dict()
    irregular_cap_list = [9, 25, 26, 56, 35, 30, 31, 33, 32, 52, 51, 49, 50, 29, 63, 37]
    if not loc:
        device_list = m.Device.objects.all()
    else:
        device_list = m.Device.objects.filter(location=loc)

    for dev in device_list:
        dev_template = dict()

        if use_label and dev.dev_type == 'st':
            dev_name = _dev_name_to_autotap(dev.label)
        else:
            dev_name = _dev_name_to_autotap(dev.name)

        dev_name = ''.join([ch for ch in dev_name if ch.isalnum() or ch == '_'])

        cap_list = dev.caps.all()
        for cap in cap_list:
            if cap.id not in irregular_cap_list:
                # this is a zero/single-parameter capability
                param_list = list(m.Parameter.objects.filter(cap_id=cap.id))
                if len(param_list) == 1:
                    # this is a single-parameter capability
                    param = param_list[0]
                    var_name = cap.name + ' ' + param.name
                    var_name = _var_name_to_autotap(var_name)
                    var_name = ''.join([ch for ch in var_name if ch.isalnum() or ch == '_'])
                    var_name = var_name.lower()

                    if param.type == 'bin':
                        var_type = 'bool'
                        if not cap.writeable:
                            var_type = var_type + ', external'
                        if not cap.readable:
                            var_type = var_type + ', disabled'
                        dev_template[var_name] = var_type
                    elif param.type == 'range':
                        var_type = 'numeric'
                        if not cap.writeable:
                            var_type = var_type + ', external'
                        if not cap.readable:
                            var_type = var_type + ', disabled'
                        dev_template[var_name] = var_type
                    elif param.type == 'set':
                        var_type = 'set'
                        if not cap.writeable:
                            var_type = var_type + ', external'
                        if not cap.readable:
                            var_type = var_type + ', disabled'
                        # need to write down all options into the template
                        value_list = [_set_opt_to_autotap(opt.value)
                                      for opt in m.SetParamOpt.objects.filter(param_id=param.id)]
                        value_list = ', '.join(value_list)
                        value_list = ', [' + value_list + ']'
                        var_type = var_type + value_list
                        dev_template[var_name] = var_type
                    elif param.type == 'color':
                        var_type = 'set'
                        if not cap.writeable:
                            var_type = var_type + ', external'
                        if not cap.readable:
                            var_type = var_type + ', disabled'
                        # need to write down all options into the template
                        value_list = ', '.join(webcolors.CSS3_NAMES_TO_HEX.keys())
                        value_list = ', [' + value_list + ']'
                        var_type = var_type + value_list
                        dev_template[var_name] = var_type
                    else:
                        print('[[[%d, %s]]]' % (cap.id, cap.name))
            elif cap.id == 63:
                # this is location cap
                location_list = m.SetParamOpt.objects.filter(param_id=70)
                person_list = m.SetParamOpt.objects.filter(param_id=71)

                for location, person in itertools.product(location_list, person_list):
                    var_name = location.value + ' ' + person.value
                    var_name = _var_name_to_autotap(var_name)
                    var_name = ''.join([ch for ch in var_name if ch.isalnum() or ch == '_'])
                    var_name = var_name.lower()

                    var_type = 'bool, external'

                    dev_template[var_name] = var_type
            elif cap.id in [49, 50, 51, 52]:
                # this is history channel
                # probably don't need to have it as a real device in AutoTap
                # should be handled by '#' and '*'
                pass
            elif cap.id in [9, 35, 56]:
                # music caps
                # 9: start playing genre, 35: start playing some music (not supported), 56: stop
                if cap.id == 9:
                    param = m.Parameter.objects.get(cap_id=cap.id)
                    var_name = cap.name + ' ' + param.name
                    var_name = _var_name_to_autotap(var_name)
                    var_name = ''.join([ch for ch in var_name if ch.isalnum() or ch == '_'])
                    var_name = var_name.lower()
                    var_type = 'set'
                    genre_list = [genre.value for genre in m.SetParamOpt.objects.filter(param_id=8)]
                    genre_list.append('Stop')
                    value_list = [_set_opt_to_autotap(genre) for genre in genre_list]
                    value_list = ', '.join(value_list)
                    value_list = ', [' + value_list + ']'
                    var_type = var_type + value_list
                    dev_template[var_name] = var_type
                else:
                    # no need to handle
                    pass
        if dev_template:
            template_dict[dev_name] = dev_template

    return template_dict


def generate_boolean_map():
    true_list = []
    false_list = []

    bool_params = m.BinParam.objects.all()
    for bool_param in bool_params:
        true_list.append(bool_param.tval)
        false_list.append(bool_param.fval)

    true_list = list(set(true_list))
    false_list = list(set(false_list))

    return {'true': true_list, 'false': false_list}