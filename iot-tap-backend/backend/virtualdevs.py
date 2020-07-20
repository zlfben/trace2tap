from django.conf import settings
from backend.models import Device, Location, Capability, ErrorLog
from django.core.exceptions import ObjectDoesNotExist
from django.utils import timezone
# from datetime import datetime, timedelta


def create_virtual_capability(capname):
    # @TODO: statelabel? commandlabel? (See models.py)
    #        These can be added below
    cap = Capability.objects.create(name=capname,
                                    writeable=False
                                    )
    # Not sure if it is better practice to return the whole object or
    # just the primary key
    return cap.pk

def create_virtual_device(name, loc, capnames):
    '''
    Initialize Virtual Device associated with all users in the Location
    Input:
     - name: standardized name of device (same across locations. i.e. "Weather")
     - loc: Location
     - capnames: List of *all* capabilites associated with the virtual device
    
     Usage: Called by create_virtual_devices function below
    '''
    #@TODO -- Need to set public=False ?
    dev = Device.objects.create(name=name,
                          location=loc, 
                          dev_type=Device.VIRTUALDEV,
                          public=False
                          )
    # All users in a location share that location's virtual device
    # Maybe can do this in one step?
    for user in loc.users.all():
        if not user in dev.users.all():
            dev.users.add(user)
            dev.save()
    
    for capname in capnames:
        try:
            cap = Capability.objects.get(name=capname)
        except Capability.DoesNotExist:
            cap_pk = create_virtual_capability(capname)
            cap = Capability.objects.get(pk=cap_pk)
        dev.caps.add(cap)
        dev.save()
    
    return dev
    

def create_virtual_devices(loc, virtual_devs=None):
    '''
    For a specified location, creates the virtual devices associated with that loc\n
    Inputs:
     - loc: (Location) the location object
     - virtual_devs: (optional) (list) The list of standardized names of all virtual 
                     devices across locations. Default to `None`, which means adding 
                     all the virtual devices to the location.

    Standardized names are currently created when locations are imported in backend/st_util

    The Capability Names for all Virtual Device capabilities are set in `settings`.
    '''
    device_list = list()
    if virtual_devs is None:
        for name in settings.VIRTUAL_DEVS:
            device_list.append(create_virtual_device(name, loc, settings.VIRTUAL_DEVS[name]))
    else:
        for name in virtual_devs:
            if name in settings.VIRTUAL_DEVS:
                device_list.append(create_virtual_device(name, loc, settings.VIRTUAL_DEVS[name]))
    
    return device_list
