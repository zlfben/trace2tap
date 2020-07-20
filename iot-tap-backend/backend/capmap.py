from . import models as m

ST_CAPMAP = {
        # 'switch' : [m.Capability.objects.get(id=2)],
        # 'switchLevel' : [m.Capability.objects.get(id=3)],
        # 'colorControl': [m.Capability.objects.get(id=6)],
        # 'audioVolume': [m.Capability.objects.get(id=8)],
        # 'motionSensor': [m.Capability.objects.get(id=15)],
        # 'tvChannel': [m.Capability.objects.get(id=36)],
        # 'smokeDetector': [m.Capability.objects.get(id=59)]
        # ... #
    }



VD_CAPMAP = {
        # 'weatherSense' : [m.Capability.objects.get(id=18),
        #                   m.Capability.objects.get(id=19),
        #                   m.Capability.objects.get(id=20)]
    }

def lookup(capname,group):
    if group == 'st':
        try:
            return list(m.STCapability.objects.get(name=capname).capabilities.all())
        except m.STCapability.DoesNotExist:
            return list()
    elif group == 'vd':
        try:
            return list(m.Capability.objects.filter(name=capname).all())
        except m.Capability.DoesNotExist:
            return list()


# INEFFICIENT; NEEDS IMPROVEMENT
def reverse_lookup(cap,group):
    if group == 'st':
        for k in m.STCapability.objects.all():
            if cap in k.capabilities.all():
                return k
        # no hits
        return None
    elif group == 'vd':
        return cap
