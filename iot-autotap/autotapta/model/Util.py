import z3


class Expression(object):
    def __init__(self, var: str, comp: str, val):
        """

        :param var: the variable
        :param comp: comparator
        :param val: the value
        """
        self.var = var
        self.comp = comp
        self.val = val

    def _simpleCheck(self, var: str, val):
        if var == self.var:
            if self.comp == '=':
                return val == self.val
            elif self.comp == '!=':
                return val != self.val
            elif self.comp == '<':
                return val < self.val
            elif self.comp == '>':
                return val > self.val
            elif self.comp == '<=':
                return val <= self.val
            else:  # self.comp == '>=
                return val >= self.val
        else:
            return False


class ActionExpression(Expression):
    def __init__(self, var: str, comp: str, val):
        """

        :param var:
        :param comp: this time the comparator must be '='
        :param val:
        """
        super(ActionExpression, self).__init__(var, '=', val)


class ConditionExpression(Expression):
    def __init__(self, var: str, comp: str, val):
        """

        :param var:
        :param comp:
        :param val:
        """
        super(ConditionExpression, self).__init__(var, comp, val)

    def check(self, var: str, val):
        return self._simpleCheck(var, val)


class TriggerExpression(Expression):
    def __init__(self, var: str, comp: str, val, hold_t: int=None, delay: int=None):
        """

        :param var:
        :param comp: this time the comparator must be '='
        :param val:
        :param hold_t: time for "state has been true for more than xxx time" in seconds
        :param delay: time for "xxx time after event happens" in seconds
        """
        super(TriggerExpression, self).__init__(var, comp, val)
        if hold_t is not None and delay is not None:
            raise Exception("a trigger cannot be both types of timing expression")
        self.hold_t = hold_t
        self.delay = delay


    def check(self, event):
        if not isinstance(event, TriggerExpression):
            raise TypeError("event should be an Event Expression")
        if self.hold_t is not None:
            return z3.And(event.hold_t == self.hold_t, self._simpleCheck(event.var, event.val))
        if self.delay is not None:
            return z3.And(event.delay == self.delay, self._simpleCheck(event.var, event.val))
        return self._simpleCheck(event.var, event.val)

    def checkTrigger(self, val):
        if self.hold_t is not None or self.delay is not None:
            return False
        else:
            return self._simpleCheck(self.var, val)

    def __str__(self):
        return 'hold: %s, delay: %s, %s%s%s' % (self.hold_t, self.delay, self.var, self.comp, self.val)

EventExpression = TriggerExpression

# ====== the following is all for symbolic expressions ====== #
# comparator for boolean and set variables
Comparator = z3.Datatype('Comparator')
Comparator.declare('eq')
Comparator.declare('neq')
Comparator = Comparator.create()
# comparator for range variables
ComparatorRange = z3.Datatype('ComparatorRange')
ComparatorRange.declare('gt')
ComparatorRange.declare('lt')
ComparatorRange.declare('geq')
ComparatorRange.declare('leq')
ComparatorRange.declare('eq')
ComparatorRange.declare('neq')
ComparatorRange = ComparatorRange.create()


def checkExpression(value, target_value, comp, typ='bool'):
    """
    check if the expression is satisfied (without considering the variable)
    :param value:
    :param target_value:
    :param comp:
    :param typ:
    :return:
    """
    if typ != 'numeric':
        eq_clause = z3.And(comp == Comparator.eq, value == target_value)
        neq_clause = z3.And(comp == Comparator.neq, value != target_value)
        sat_clause = z3.Or(eq_clause, neq_clause)
    else:
        eq_clause = z3.And(comp == ComparatorRange.eq, value == target_value)
        neq_clause = z3.And(comp == ComparatorRange.neq, value != target_value)
        gt_clause = z3.And(comp == ComparatorRange.gt, value > target_value)
        lt_clause = z3.And(comp == ComparatorRange.lt, value < target_value)
        geq_clause = z3.And(comp == ComparatorRange.geq, value >= target_value)
        leq_clause = z3.And(comp == ComparatorRange.leq, value <= target_value)
        sat_clause = z3.Or(eq_clause, neq_clause, gt_clause, lt_clause, geq_clause, leq_clause)

    return sat_clause