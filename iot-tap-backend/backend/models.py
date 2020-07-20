from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone

import re, datetime

class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    stapp_id = models.CharField(max_length=256, blank=True, default="")
    access_token = models.CharField(max_length=256, blank=True, default="")
    access_token_expired_at = models.DateTimeField(default=None, null=True)
    refresh_token= models.TextField(null=True, default="")

# USER FOR ICSE PAPER
class User_ICSE19(models.Model):
    name = models.CharField(max_length=30,unique=True,null=True)
    code = models.TextField(max_length=128)
    mode = models.CharField(max_length=5,choices=[('rules','Rule'),('sp','Safety Property')])

# CHANNEL
# name  : name of Channel
class Channel(models.Model):
    name = models.CharField(max_length=30)
    icon = models.TextField(null=True)

    def __str__(self):
        return self.name

# CAPABILITY
# name          : name of capability
# channel       : parent channel of capability (FK)
# readable      : does this capability maintain a state?
# writeable     : can this capability's state be edited?
# statelabel    : text description of capability (state form)
# commandlabel  : text description of capability (action form)
# eventlabel    : text description of capability (event form, entry into state)
class Capability(models.Model):
    name = models.CharField(max_length=30)
    channels = models.ManyToManyField(Channel)
    readable = models.BooleanField(default=True)
    writeable = models.BooleanField(default=True)
    statelabel = models.TextField(null=True, blank=True, max_length=256)
    commandlabel = models.TextField(null=True, blank=True, max_length=256)
    eventlabel = models.TextField(null=True, blank=True, max_length=256)
    commandname = models.TextField(null=True, blank=True, max_length=64) # should be st capability name instead?

    def update_paramname(self,old,new):
        try:
            p = Parameter.objects.get(name=old,cap_id=self.id)
        except Parameter.DoesNotExist:
            print("no such param")
            return

        l = self.statelabel
        if l != None:
            newl = re.sub(r'{%s((?:/\W{2,3}|/\w\W|).*?)}' % old,r'{%s\1}' % new,l)
            print("old:",l,"\nnew:",newl)
            self.statelabel=newl
            self.save()

        l = self.eventlabel
        if l != None:
            newl = re.sub(r'{%s((?:/\W{2,3}|/\w\W|).*?)}' % old,r'{%s\1}' % new,l)
            print("old:",l,"\nnew:",newl)
            self.eventlabel=newl
            self.save()

        l = self.commandlabel
        if l != None:
            newl = re.sub(r'{%s((?:/\W{2,3}|/\w\W|).*?)}' % old,r'{%s\1}' % new,l)
            print("old:",l,"\nnew:",newl)
            self.commandlabel = newl
            self.save()

        p.name=new
        p.save()
        return

    def prefix(self,s=True,e=True,c=True):
        if self.readable:
            if s:
                self.statelabel = "({DEVICE}) " + self.statelabel
            else:
                self.statelabel = re.sub(r'\(\{DEVICE\}\) ','',self.statelabel)

            if e:
                self.eventlabel = "({DEVICE}) " + self.eventlabel
            else:
                self.eventlabel = re.sub(r'\(\{DEVICE\}\) ','',self.eventlabel)
        if self.writeable:
            if c:
                self.commandlabel = "({DEVICE}) " + self.commandlabel
            else:
                self.commandlabel = re.sub(r'\(\{DEVICE\}\) ','',self.commandlabel)

        self.save()
        return

    def __str__(self):
        return "{} ({})".format(self.name, self.id)

# ST capability mapping
class STCapability(models.Model):
    name = models.CharField(max_length=30, unique=True)
    capabilities = models.ManyToManyField(Capability)
    command_type = models.TextField(null=True)

    def __str__(self):
        return "{} - {}".format(self.name, str(self.capabilities.all()))


##########################
# [PAM] Parameter Models #
##########################

class Parameter(models.Model):
    name = models.TextField()
    sysname = models.TextField(null=True)
    is_command = models.NullBooleanField()
    is_main_param = models.NullBooleanField()
    type = models.TextField(choices=[('set',"Set"),
                                    ('range',"Range"),
                                    ('bin',"Binary"),
                                    ('color',"Color"),
                                    ('time',"Time"),
                                    ('duration',"Duration"),
                                    ('input',"Input"),
                                    ('meta',"Meta")])
    cap = models.ForeignKey(Capability,on_delete=models.CASCADE)

    def __str__(self):
        return "{} - {} ({}) ({})".format(self.name, self.sysname, self.id, self.cap.name)

# PARVALMAPPING (map st vals into proj vals)
class ParValMapping(models.Model):
    param = models.ForeignKey(Parameter, on_delete = models.CASCADE)
    st_val = models.TextField()
    val = models.TextField()

# SETPARAM (Fixed-Set Parameter, represented by dropdown)
class SetParam(Parameter):
    numopts = models.IntegerField(default=0)

# SETPARAMOPT (Fixed-Set Parameter Option)
class SetParamOpt(models.Model):
    value = models.TextField()
    param = models.ForeignKey(SetParam,on_delete = models.CASCADE)

# RANGEPARAM (Range-based Parameter, represented by slider)
class RangeParam(Parameter):
    min = models.IntegerField()
    max = models.IntegerField()
    interval = models.FloatField(default=1.0)

# Range separation representing a range for range variables. Only writable caps have this.
# It is used to categorized user behaviors related to that variable.
class RangeSeparation(models.Model):
    min = models.FloatField(default=float('-inf'))
    max = models.FloatField(default=float('inf'))
    representative = models.FloatField()
    param = models.ForeignKey('Parameter', on_delete=models.CASCADE)
    cap = models.ForeignKey('Capability', on_delete=models.CASCADE)
    dev = models.ForeignKey('Device', on_delete=models.CASCADE)
    count = models.IntegerField(default=0)

# Color separation, count how many color has shown up in the trace for a particular device
class ColorCount(models.Model):
    name = models.TextField(blank=True)
    rgb = models.TextField(blank=True)
    param = models.ForeignKey('Parameter', on_delete=models.CASCADE)
    cap = models.ForeignKey('Capability', on_delete=models.CASCADE)
    dev = models.ForeignKey('Device', on_delete=models.CASCADE)
    count = models.IntegerField(default=0)

# Counter: count how many actuator events can be automated
class Counter(models.Model):
    typ = models.TextField(choices=[('set',"Set"),
                                    ('range',"Range"),
                                    ('bin',"Binary"),
                                    ('color',"Color"),])
    param = models.ForeignKey('Parameter', on_delete=models.CASCADE)
    cap = models.ForeignKey('Capability', on_delete=models.CASCADE)
    dev = models.ForeignKey('Device', on_delete=models.CASCADE)
    count = models.IntegerField(default=0)
    automated_count = models.IntegerField(default=0)

class BinCounter(Counter):
    val = models.TextField(blank=True)  # should be eigher of the bin options

class RangeCounter(Counter):
    min = models.FloatField(default=float('-inf'))
    max = models.FloatField(default=float('inf'))
    representative = models.FloatField()

class SetCounter(Counter):
    val = models.TextField(blank=True)  # should be eigher of the set options

class ColorCounter(Counter):
    name = models.TextField(blank=True)  # map to CSS3 colors
    rgb = models.TextField(blank=True)


# BINPARAM (Binary Parameter, represented by binary radial options)
class BinParam(Parameter):
    tval = models.TextField()
    fval = models.TextField()

# COLORPARAM (Color Parameter, represented by color picker)
class ColorParam(Parameter):
    mode = models.TextField(choices=[('rgb',"RGB"),('hsv',"HSV"),('hex',"Hex")])

# TIMEPARAM (Time Parameter, represented by time picker)
class TimeParam(Parameter):
    mode = models.TextField(choices=[('24',"24-hour"),('12',"12-hour")])

# DURATIONPARAM (Duration Parameter, represented by 1-3 int selection boxes)
class DurationParam(Parameter):
    comp = models.BooleanField(default=False)
    maxhours = models.IntegerField(null=True,default=23)
    maxmins = models.IntegerField(null=True,default=59)
    maxsecs = models.IntegerField(null=True,default=59)

# INPUTPARAM (User-Input Parameter, represented by text boxes)
class InputParam(Parameter):
    inputtype = models.TextField(choices=[('int',"Integer"),('stxt',"Short Text"),('ltxt',"Long Text"),('trig',"Trigger")])

# METAPARAM (Trigger Parameter, represented by Trigger Selector)
class MetaParam(Parameter):
    is_event = models.BooleanField()

# PARVAL (Parameter/Value Pair, used for state-tracking)
class ParVal(models.Model):
    par = models.ForeignKey(Parameter,on_delete = models.CASCADE)
    val = models.TextField()
    state = models.ForeignKey('State',on_delete = models.CASCADE)

    def __str__(self):
        return "{} - {} - {}: {} ({})".format(
            self.state.dev.name, 
            self.state.cap.name, 
            self.par.name, 
            self.val, 
            self.id
        )

# ACTIONPARVAL (Parameter/Value Pair, used for actions)
class ActionParVal(models.Model):
    par = models.ForeignKey(Parameter,on_delete = models.CASCADE)
    val = models.TextField()
    state = models.ForeignKey('State',on_delete = models.CASCADE)

    def __str__(self):
        return "{} - {} - {}: {} ({})".format(
            self.state.dev.name, 
            self.state.cap.name, 
            self.par.name, 
            self.val, 
            self.id
        )

###############################
# [DTM] Device/Trigger Models #
###############################

# CONDITION (used for triggers)
# par   : triggering parameter
# val   : value to trigger
# cond  : comparator to determine if condition is true
class Condition(models.Model):
    par = models.ForeignKey(Parameter,on_delete = models.CASCADE)
    val = models.TextField()
    comp = models.TextField(choices=[('=',"is"),('!=',"is not"),('<',"is less than"),('>',"is greater than")])
    trigger = models.ForeignKey('Trigger',on_delete = models.CASCADE)

# ActionCondition (used for actions)
# par   : triggering parameter
# val   : value to trigger
class ActionCondition(models.Model):
    par = models.ForeignKey(Parameter,on_delete = models.CASCADE)
    val = models.TextField()
    action = models.ForeignKey('Action',on_delete = models.CASCADE)

# LOCATION
# st_loc_id :   the location id in smartthings
# name      :   the name of the location (e.g. Super HQ)
# users     :   the users in that location
# lat:      :   the latitude from the location object
# lon:      :   the longitude from the location objects
# @TODO: When initializing Location, make a call to smartthings with loc id
#        and store lat/lon, so that we don't need to make a call to smartthings 
#        every time we need geo coordinates
# @TODO: Make st_loc_id have unique=True. Check that get_locations_from_st function 
#        in st_util supports this
class Location(models.Model):
    st_loc_id = models.CharField(max_length=40)
    st_installed_app_id = models.CharField(max_length=40, default="", blank=True)
    name = models.CharField(max_length=256)
    users = models.ManyToManyField(User)
    lat = models.FloatField(null=True, blank=True, default=None)
    lon = models.FloatField(null=True, blank=True, default=None)

class LocationVirtualDevices(models.Model):
    location = models.OneToOneField("Location", on_delete=models.CASCADE)
    weather_dev = models.ForeignKey("Device", on_delete=models.CASCADE, related_name='loc_weatherdev')
    clock_dev = models.ForeignKey("Device", on_delete=models.CASCADE, related_name='loc_clockdev')

class Device(models.Model):
    '''
    DEVICE
        owner    : user who owns device
        location : the location where the device is
        public   :
        dev_type :
        dev_type : device type (smartthings, virtualdev or fakedev)
        name     : name of device
        icon     :
        chans    :
        caps     : set of capabilities available to this device (M2M)
    '''
    # choices for device type
    SMARTTHINGS = 'st'
    VIRTUALDEV = 'v'
    FAKEDEV = 'f'
    DEV_TYPE_CHOICES = [
        (SMARTTHINGS, 'smartthings'),
        (VIRTUALDEV, 'virtualdev'),
        (FAKEDEV, 'fakedev')
    ]

    users = models.ManyToManyField(User)
    location = models.ForeignKey(Location, null=True, on_delete=models.SET_NULL)
    public = models.BooleanField(default=False)
    dev_type = models.TextField(default=FAKEDEV, choices=DEV_TYPE_CHOICES)
    name = models.CharField(max_length=128)
    label = models.CharField(max_length=256, default="", blank=True)
    icon = models.TextField(null=True, default="highlight")
    chans = models.ManyToManyField(Channel)
    caps = models.ManyToManyField(Capability)
    is_subscribed = models.BooleanField(default=False)

    def __str__(self):
        return "{} ({})".format(self.name, self.id)

class State(models.Model):
    '''
    If `action=True`, it's the 'action' part of all the rules. \n
    If `action=False`, it's the current state of the dev/cap pair.
        cap    : parent capability of state
        dev    : parent device of state
        chan   : parent channel of state
        action : if this state is an action
        text   : the text that displays in the frontend
    '''
    cap = models.ForeignKey(Capability,on_delete = models.CASCADE)
    dev = models.ForeignKey(Device,on_delete = models.CASCADE)
    chan = models.ForeignKey(Channel,on_delete = models.CASCADE,null=True)
    action = models.BooleanField()
    text = models.TextField(max_length=128,null=True)

    def __str__(self):
        return "{} - {} ({})".format(self.cap.name, self.dev.name, self.id)

class Action(models.Model):
    '''
        cap    : parent capability of state
        dev    : parent device of state
        chan   : parent channel of state
        action : if this state is an action
        text   : the text that displays in the frontend
    '''
    cap = models.ForeignKey(Capability,on_delete = models.CASCADE)
    dev = models.ForeignKey(Device,on_delete = models.CASCADE)
    chan = models.ForeignKey(Channel,on_delete = models.CASCADE,null=True)
    text = models.TextField(max_length=128,null=True)

    def __str__(self):
        return "{} - {} ({})".format(self.cap.name, self.dev.name, self.id)

class Trigger(models.Model):
    '''
    TRIGGER
        cap  : 
        dev  : 
        chan :
        pos  :
        text :
    '''
    cap = models.ForeignKey(Capability,on_delete = models.CASCADE)
    dev = models.ForeignKey(Device,on_delete = models.CASCADE)
    chan = models.ForeignKey(Channel,on_delete = models.CASCADE,null=True)
    pos = models.IntegerField(null=True)
    text = models.TextField(max_length=128,null=True)


####################
# [RM] Rule Models #
####################

class Rule(models.Model):
    '''
    RULE
        owner               : (legacy field for ICSE19) the person who created this rule in ICSE19
                              study
        st_owner            : the owner of this rule (can be applied to smartthings)
        st_installed_app_id : id of the installed smartthings app, so that we could know this rule
                              should be applied to which location that is owned by the owner 
        task                : (legacy field for ICSE19) the task that this rule belongs to
        lastedit            : the timestamp of last edit time
        type                : which type of rule this is (i.e. event-state or state-state)
    '''
    owner = models.ForeignKey(User_ICSE19,on_delete = models.CASCADE, blank=True, null=True, default=None)
    st_owner = models.ForeignKey(User,on_delete = models.CASCADE, default=None, blank=True, null=True)
    st_installed_app_id = models.CharField(max_length=37, default=None, blank=True, null=True)
    task = models.IntegerField(default=1, blank=True, null=True)
    lastedit = models.DateTimeField(auto_now=True)
    type = models.CharField(max_length=3,choices=[('es','es'),('ss','ss')])

class ESRule(Rule):
    '''
    ESRULE (Event-State Rule)
        Etrigger    : "event" that triggers rule
        Striggers   : states that must be true to trigger rule
        action      : state to make true when rule is triggered
    '''
    Etrigger = models.ForeignKey(Trigger,on_delete = models.CASCADE,related_name='EStriggerE')
    Striggers = models.ManyToManyField(Trigger)
    action = models.ForeignKey('Action',on_delete = models.CASCADE,related_name='ESactionstate')

# SSRULE (State-State Rule)
# triggers      : states that must be true to trigger rule
# priority      : priority value of rule
# actionstate   : state to make true when rule is triggered
class SSRule(Rule):
    triggers = models.ManyToManyField(Trigger)
    priority = models.IntegerField()
    action = models.ForeignKey('Action',on_delete = models.CASCADE,related_name='SSactionstate')

################################
# [SPM] Safety Property Models #
################################

class SafetyProp(models.Model):
    owner = models.ForeignKey(User_ICSE19,on_delete = models.CASCADE)
    task = models.IntegerField()
    lastedit = models.DateTimeField(auto_now = True)
    type = models.IntegerField(choices=[(1,'1'),(2,'2'),(3,'3')])
    always = models.BooleanField()

class SP1(SafetyProp):
    triggers = models.ManyToManyField(Trigger)

class SP2(SafetyProp):
    state = models.ForeignKey(Trigger,on_delete = models.CASCADE,related_name='sp2_state')
    comp = models.TextField(choices=[('=','='),('!=','!='),('>','>'),('<','<')],null=True)
    time = models.IntegerField(null=True)
    conds = models.ManyToManyField(Trigger,related_name='sp2_conds')

class SP3(SafetyProp):
    event = models.ForeignKey(Trigger,on_delete = models.CASCADE,related_name='sp3_event')
    comp = models.TextField(choices=[('=','='),('!=','!='),('>','>'),('<','<')],null=True)
    occurrences = models.IntegerField(null=True)
    conds = models.ManyToManyField(Trigger,related_name='sp3_conds')
    time = models.IntegerField(null=True)
    timecomp = models.TextField(choices=[('=','='),('!=','!='),('>','>'),('<','<')],null=True)


################################
# [HCM] History Channel Models #
################################

class StateLog(models.Model):
    '''
    STATELOG
        timestamp           : (auto-added) datetime at which entry was added
        status              : the status of the log (i.e. happend, current, to_occur)
        cap                 : the capability to be logged
        dev                 : the device to be logged
        param               : the parameter to be logged
        value               : the value of the to-be-logged parameter
        value_type          : the type of the parameter's value
        is_superifttt       : whether the event is issued by superifttt
    '''
    # choices for value type
    STRING = 'string'
    NUMBER = 'number'
    VECTOR3 = 'vector3'
    ENUM = 'enum'
    DYNAMIC_ENUM = 'dynamic_enum'
    COLOR_MAP = 'color_map'
    JSON = 'json_object'
    DATE = 'date'
    VALUE_TYPE_CHOICES = [
        (STRING, 'string'),
        (NUMBER, 'number'),
        (VECTOR3, 'vector3'),
        (ENUM, 'enum'),
        (DYNAMIC_ENUM, 'dynamic_enum'),
        (COLOR_MAP, 'color_map'),
        (JSON, 'json_object'),
        (DATE, 'date'),
    ]
    # choices for status
    HAPPENED = 1
    CURRENT = 2
    TO_OCCUR = 3
    STATUS_CHOICES = [
        (HAPPENED, 'happend'),
        (CURRENT, 'current'),
        (TO_OCCUR, 'to_occur')
    ]

    timestamp = models.DateTimeField(auto_now_add=True)
    status = models.PositiveSmallIntegerField(choices=STATUS_CHOICES, default=HAPPENED)
    cap = models.ForeignKey(Capability,on_delete = models.CASCADE,related_name='logcap', blank=True)
    dev = models.ForeignKey(Device,on_delete = models.CASCADE,related_name='logdev', blank=True)
    param = models.ForeignKey(Parameter,on_delete = models.CASCADE,related_name='logparam', blank=True)
    loc = models.ForeignKey(Location, on_delete=models.CASCADE, related_name='logloc', blank=True, null=True)
    value = models.TextField()
    value_type = models.CharField(max_length=13, choices=VALUE_TYPE_CHOICES, default=STRING)
    is_superifttt = models.BooleanField(default=False)

    def is_current(self):
        return self.status == self.CURRENT
    
    class Meta:
        ordering = ["-timestamp"]


############
# Recorder #
############
class Record(models.Model):
    timestamp = models.DateTimeField(auto_now_add=True)
    request = models.TextField(blank=True)
    response = models.TextField(blank=True)
    location = models.ForeignKey(Location, on_delete=models.CASCADE, blank=True, null=True)
    typ = models.TextField(choices=[('syn_first',"First Time Synthesize"),
                                    ('syn_followup',"Following-Up Synthesize"),
                                    ('debug_first',"First Time Debug"),
                                    ('debug_followup',"Following-Up Debug"),
                                    ('edit_rule',"Edit Rule")])
    
###########
# Helpers #
###########

class ErrorLog(models.Model):
    function = models.CharField(max_length=64, default="", blank=True, null=True)
    err = models.TextField(default="", blank=True, null=True)
    created = models.DateTimeField(auto_now=True, null=True)
