from autotapta.analyze.Generator import generateTrace, PoiisonGenerator, \
    BooleanGenerator, RandomWalkValueGenerator, SetGenerator, generateTraceEnhanced
from autotapmc.channels.template.DbTemplate import template_dict
from autotapmc.model.Tap import Tap
from autotapta.analyze.Analyze import truncateTraceByLastAction, synthesizeRuleWithSatSolver


cap_dict = dict()
for channel in template_dict:
    for cap, typ in template_dict[channel].items():
        if typ.startswith('bool'):
            cap_dict[channel+'.'+cap] = (PoiisonGenerator(3600), BooleanGenerator())
        elif typ.startswith('numeric'):
            cap_dict[channel+'.'+cap] = (PoiisonGenerator(1000), RandomWalkValueGenerator(step=5, target=50))
        else:
            opt_list = typ.split('[')[-1][:-1].split(', ')
            cap_dict[channel+'.'+cap] = (PoiisonGenerator(3600), SetGenerator(opt_list=opt_list))

tap_dict = {'rule1': Tap(action='smart_oven.lockunlock_setting=true',
                         trigger='smart_oven.lockunlock_setting=false',
                         condition=['location_sensor.kitchen_bobbie=true']),
            'rule2': Tap(action='smart_oven.lockunlock_setting=true',
                         trigger='location_sensor.kitchen_bobbie=true',
                         condition=['smart_oven.lockunlock_setting=false'])
            }
trace = generateTraceEnhanced(cap_dict, tap_dict, length=100000, template_dict=template_dict)

trace = truncateTraceByLastAction(trace, 'smart_oven.lockunlock_setting=true')
trace.actions = trace.actions[:-1]  # TEST: delete this afterwards
trace.pre_condition = trace.pre_condition[:-1]  # TEST: delete this afterwards
synthesizeRuleWithSatSolver(trace, 'smart_oven.lockunlock_setting=true')
