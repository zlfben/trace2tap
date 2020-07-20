def splitTime(formula):
    if '*' in formula:
        formula_time = int(formula.split('*')[0])
        formula = formula.split('*')[1]
        formula_time_symb = '*'
    elif '#' in formula:
        formula_time = int(formula.split('#')[0])
        formula = formula.split('#')[1]
        formula_time_symb = '#'
    else:
        formula_time = None
        formula_time_symb = None

    return formula_time, formula_time_symb, formula


def splitSimpleFormula(formula):
    if '<=' in formula:
        comp = '<='
        cap, val = formula.split('<=')
    elif '>=' in formula:
        comp = '>='
        cap, val = formula.split('>=')
    elif '!=' in formula:
        comp = '!='
        cap, val = formula.split('!=')
    elif '>' in formula:
        comp = '>'
        cap, val = formula.split('>')
    elif '<' in formula:
        comp = '<'
        cap, val = formula.split('<')
    else:
        comp = '='
        cap, val = formula.split('=')
    
    return cap, comp, val


def checkEventAgainstTrigger(event, trigger):
    if trigger.startswith('tick['):
        trigger = trigger[5:-1]
    if event.startswith('tick['):
        event = event[5:-1]

    trigger_time, trigger_time_symb, trigger = splitTime(trigger)
    event_time, event_time_symb, event = splitTime(event)
    
    if trigger_time is not None and event_time is not None:
        if trigger_time_symb != event_time_symb or trigger_time != event_time:
            return False
    elif trigger_time is None and event_time is None:
        pass
    else:
        return False
    
    trigger_cap, trigger_comp, trigger_val = splitSimpleFormula(trigger)
    event_cap, event_comp, event_val = splitSimpleFormula(event)
    
    if trigger_cap != event_cap:
        return False

    if trigger_comp == '<=':
        return float(event_val) <= float(trigger_val)
    elif trigger_comp == '>=':
        return float(event_val) >= float(trigger_val)
    elif trigger_comp == '<':
        return float(event_val) < float(trigger_val)
    elif trigger_comp == '>':
        return float(event_val) > float(trigger_val)
    elif trigger_comp == '!=':
        return event_val != trigger_val
    else:
        return event_val == trigger_val
