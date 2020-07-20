import weatherapp as w
#import clockapp as t


def translate(command):
    try:
        mode = command['mode']
        args = command['args']
    except KeyError:
        return None

    if mode == 'is_it_raining':
        return w.is_it_raining(args['loc'])
    elif mode == 'match_weather':
        return w.match_weather(args['loc'],args['weather'])
    elif mode == 'comp_temp':
        return w.comp_temp(args['loc'],args['temp'],args['comp'])
    else:
        return None

