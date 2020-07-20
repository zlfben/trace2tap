from django.conf import settings
from django.http import JsonResponse
from django.urls import reverse
from django.core.exceptions import ObjectDoesNotExist
from django.utils import timezone
from backend.models import Device, Location, ErrorLog, State, StateLog, ParVal, ParValMapping, \
                           Parameter, Capability, LocationVirtualDevices
import backend.capmap as capmap
from backend.virtualdevs import create_virtual_devices
from autotap.util import initialize_trace_for_location
from datetime import datetime, timedelta
import requests, traceback, time, json

def get_installed_apps():
    url = settings.IOTCORE_URL + 'st/apps/' + settings.PROJECT_NAME + '/instances/'
    resp = requests.get(url)
    return resp.json()

def create_app(access_token, data):
    """
    Create a SmartApp in IoTCore
    Input:  data: configurations for a smart App
    Output: 
        - 200: {}
    """
    url = settings.IOTCORE_URL + 'st/apps/create'
    headers = {
        "Authorization": "Bearer {}".format(access_token),
        "Content-Type": "application/json"
    }
    try:
        resp = requests.post(url, json=data, headers=headers)
        return JsonResponse(resp.json(), status=resp.status_code)
    except Exception as e:
        return JsonResponse({"msg": repr(e)}, status=500)

def create_user_account(username, password):
    '''
    Register a user in IoTCore
    Input:  username, password
    Output: user id
    '''
    try:
        cookie_url = settings.IOTCORE_URL + 'st/get_cookie/'
        url = settings.IOTCORE_URL + 'st/user/register/'
        payload = {
            "username": username,
            "password": password
        }
        with requests.Session() as s:
            s = requests.Session()
            s.get(cookie_url)
            resp = s.post(url, data=payload)
        return resp.json(), resp.status_code
    except requests.ConnectionError as e:
        return {"msg": repr(e), "url": url}, 503
    except requests.Timeout:
        return {"msg": "Request times out. Please check your network connection"}, 408

def get_access_token(user):
    try:
        user_profile = user.userprofile
        expired_time = user_profile.access_token_expired_at
        if get_now() >= expired_time:
            refresh_token = user_profile.refresh_token
            url = settings.IOTCORE_URL + 'o/token/'
            data = {
                "grant_type": "refresh_token",
                "client_id": settings.CLIENT_ID,
                "client_secret": settings.CLIENT_SECRET,
                "refresh_token": refresh_token
            }
            resp = requests.post(url, data=data).json()
            user_profile.access_token = resp.get("access_token", None)
            user_profile.access_token_expired_at = get_now() + timedelta(seconds=resp.get("expires_in", 0))
            user_profile.refresh_token = resp.get("refresh_token", None)
            user_profile.save()
            return user_profile.access_token
        else:
            return user_profile.access_token
    except ObjectDoesNotExist:
        # @TODO: although I think this error should never happens, 
        #        we still need a better way to handle it
        return None
    except requests.ConnectionError:
        return None

def get_locations_from_st(user):
    """
    Initial get of locations from SmartThings
    Input:
        - user
    Output:
        - success: [location1, location2, ...] (a list of location instances)
        - fail: []
    """
    url = settings.IOTCORE_URL + 'st/apps/{}/locations/'.format(user.userprofile.stapp_id)
    resp = send_get_request_to_core(user, url)

    if resp.status_code != 200:
        return []
    
    # locations = [{"st_id": "xxxx", "name": "xxxx", "latitude": x.xxx, "longitude": x.xxx}]
    received_locs_list = json.loads(resp.content.decode('utf-8'))
    locations = []
    for loc_dict in received_locs_list:
        try:
            # Is this user already associated with the location?:
            loc = Location.objects.get(
                st_loc_id = loc_dict.get("st_id", ""),
                name = loc_dict.get("name", ""),
                users = user
                )
        except Location.DoesNotExist:
            if  Location.objects.filter(st_loc_id = loc_dict.get("st_id", "")).exists():
                try:
                    loc = Location.objects.get(st_loc_id = loc_dict.get("st_id", ""))
                except Location.MultipleObjectsReturned:
                    # Consolidation -- only one location object should exist for each
                    # literal location. (that is, st_loc_id should be a unique field)
                    query = Location.objects.filter(st_loc_id = loc_dict.get("st_id", ""))
                    loc = Location.objects.create(
                        st_loc_id = loc_dict.get("st_id", ""),
                        name = loc_dict.get("name", "")
                        )
                    for duplicate in query.all():
                        for existing_user in duplicate.users:
                            loc.users.add(existing_user)
                        loc.save()
                        duplicate.delete()
            else:
                # Copy loc info into objects that associate the loc info with the user
                loc = Location.objects.create(
                    st_loc_id = loc_dict.get("st_id", ""),
                    name = loc_dict.get("name", ""),
                    lat = loc_dict.get("latitude", None),
                    lon = loc_dict.get("longitude", None)
                )
            # For all of the cases in the Location.DoesNotExist logic, add the new user to the location:
            loc.users.add(user)
            loc.save()
        # if location is created for the first time, add virtual devices to it
        add_virtual_devs_to_loc(loc)
        locations.append(loc)
    return locations

def add_virtual_devs_to_loc(loc):
    # Add user to Virtual Devices associated with this location or create if not yet created
    # (Logic below assumes virtual devices are *only* created in this area of the code)
    virtual_devs = settings.VIRTUAL_DEVS

    try:
        loc_vd = LocationVirtualDevices.objects.get(location=loc)
        # need to update the user list
        for user in loc.users.all():
            if user not in loc_vd.weather_dev.users.all():
                loc_vd.weather_dev.users.add(user)
        loc_vd.save()
    except LocationVirtualDevices.DoesNotExist:
        weather_dev = create_virtual_devices(loc, ['Weather'])[0]  # should return only one device
        clock_dev = create_virtual_devices(loc, ['Clock'])[0]  # should return only one device
        loc_vd= LocationVirtualDevices.objects.create(location=loc, weather_dev=weather_dev, clock_dev=clock_dev)
        loc_vd.save()
    
    
    # for name in virtual_devs:
    #     try:
    #         virtual_dev = Device.objects.get(location=loc, dev_type=Device.VIRTUALDEV, name=name)
    #         if not user in virtual_dev.users.all():
    #             virtual_dev.users.add(user)
    #             virtual_dev.save()
    #     except Device.DoesNotExist:
    #         create_virtual_devices(loc)

    
def get_installed_app_detail(user, st_loc_id):
    url = settings.IOTCORE_URL + \
            'st/installed-apps/app/{}/loc/{}/'.format(user.userprofile.stapp_id, st_loc_id)
    return send_get_request_to_core(user, url)

def get_installed_app_id(user, st_loc_id):
    '''
    Get installed STApp's id through user and location.\n
    Input:
        user
        st_loc_id
    Output:
        Success: installed_appid
        Faile:   None
    '''
    try:
        # get the st_installed_app_id
        installed_app_detail = get_installed_app_detail(user, st_loc_id)
        if installed_app_detail.status_code != 200:
            return None
           
        installed_appid = json.loads(installed_app_detail.content.decode('utf-8')).get("st_installed_app_id")
        return installed_appid
    except Exception as e:
        err_msg = "get_installed_app_id: {}\n{}".format(repr(e), traceback.format_exc())
        ErrorLog.objects.create(err=err_msg)
        return None

def get_devices_from_st(user, st_loc_id):
    """
    Initial get of devices from SmartThings
    Input:
        - user
        - st_loc_id
    Output:
        - success: [device1, device2, ...] (a list of device instances)
        - fail: []
    """
    try:
        # get location first
        loc = Location.objects.get(st_loc_id=st_loc_id, users=user)
        if loc.st_installed_app_id is None or loc.st_installed_app_id == "":
            st_installed_app_id = get_installed_app_id(user, st_loc_id)
            if st_installed_app_id:
                loc.st_installed_app_id = st_installed_app_id
                loc.save()
        # get all the devices from a st_installed_app
        url = settings.IOTCORE_URL + 'st/installed-apps/{}/devices/'.format(loc.st_installed_app_id)
        resp = send_get_request_to_core(user, url)
    except Exception as e:
        err_msg = "get_devices_from_st: {}\n{}".format(repr(e), traceback.format_exc())
        ErrorLog.objects.create(err=err_msg)
        return []

    if resp.status_code != 200:
        err_msg = "get_devices_from_st: iotcore's response is {}\nContent: {}".format(resp.status_code, resp.content)
        ErrorLog.objects.create(err=err_msg)
        return []
    
    try:
        # devices : 
        # {"device": [
        #   {
        #       "st_device_id": "xxx", 
        #       "proj_device_id": -1, 
        #       "name": "xxx",
        #       "label": "xxx",
        #       "is_subscribed": True,
        #       "capabilities": []
        #   }, ...]}
        devices = json.loads(resp.content.decode('utf-8')).get("devices", [])
        # for updating the id mapping
        devmap = {"dev_map": []}
        # for return
        dev_list = []
        for dev in devices:
            proj_dev_id = dev.get("proj_device_id", -1)
            try:
                proj_dev = Device.objects.get(
                    id=proj_dev_id,
                    users=user,
                    location=loc
                )
            except Device.DoesNotExist:
                if Device.objects.filter(id=proj_dev_id, location=loc).exists():
                    # if it's just the user doesn't match
                    if user in loc.users.all():
                        # but user is in the location, then give access to the device
                        proj_dev = Device.objects.get(id=proj_dev_id, location=loc)
                        proj_dev.users.add(user)
                        proj_dev.save()
                    else:
                        # otherwise skip this device
                        continue
                else:
                    # if device hasn't been created
                    proj_dev = Device.objects.create(
                        name=dev.get("name", ""),
                        label = dev.get("label", ""),
                        location=loc,
                        public=False,
                        dev_type=Device.SMARTTHINGS
                    )
                    # adding all the users from this location to the device
                    for u in loc.users.all():
                        proj_dev.users.add(u)
                    proj_dev.save()

                    caps = dev.get("capabilities")
                    for cap in caps:
                        st_id = cap.get("st_id")
                        proj_caps = capmap.lookup(st_id, 'st')
                        # @TODO: The following code assumes there is only one proj_caps
                        # if a ST Capability maps to multiple project capabilities, extra steps need to be taken
                        for proj_cap in proj_caps:
                            proj_dev.caps.add(proj_cap)
                            for attr in cap.get("attributes", []):
                                if st_id == "colorControl":
                                    if attr["name"] == "color":
                                        param = Parameter.objects.get(sysname=attr["name"])
                                        value = "{},{}".format(cap["attributes"][1]["value"], cap["attributes"][2]["value"])
                                else:
                                    param = Parameter.objects.get(sysname=attr["name"])
                                    value = stval_to_val(param, attr["value"])
                                create_initial_log(proj_dev, proj_cap, param, value)
                    proj_dev.save()
                    devmap["dev_map"].append({
                        "st_device_id": dev.get("st_device_id"),
                        "proj_device_id": proj_dev.id
                    })
            proj_dev.is_subscribed = dev.get("is_subscribed")
            proj_dev.save()
            dev_list.append(proj_dev)

        # Add User to all VIRTUAL DEVICES associated with the location
        virtualdevices = Device.objects.filter(location=loc,
                                               dev_type=Device.VIRTUALDEV,
                                               )
        for vdev in virtualdevices:
            if not user in vdev.users.all():
                vdev.users.add(user)
                vdev.save()
            dev_list.append(vdev)
            # QUESTION: Does the devmap need the virtual devices? Probably not, since
            # virtual devices are not yet stored in the core...or is this used elsewhere?

        # send request back to iotcore to update the proj_device_id
        mapping_resp = update_device_mapping(user, devmap, loc.st_installed_app_id)
        return dev_list
    except Location.DoesNotExist:
        return_error_msg("get_devices_from_st", repr(Location.DoesNotExist))
        return []
    except Exception as e:
        return_error_msg("get_devices_from_st", repr(e))
        return []

def update_device_mapping(user, dev_map, st_installed_app_id):
    url = settings.IOTCORE_URL + 'st/installed-apps/{}/devices/update/'.format(st_installed_app_id)
    resp = send_post_request_to_core(user, url, body=dev_map, req_json=True)
    return resp

def subscribe_device(user, dev_id):
    '''
    Subscribe a device so that the project can listen to the events happend on that device.\n
    Input:
        user    : the user who issue the request
        dev_id  : the id of the device in this project
        st_installed_app_id : the id in SmartThings of this installed app
    Output:
        {
            "status_code": (int) status code,
            "msg": (str) the error message
        }
    '''
    # get the st_installed_app_id
    try:
        dev = Device.objects.get(id=dev_id).select_related('location')
    except Device.DoesNotExist:
        return {"status_code": 404, "msg": "Cannot find the device."}
    st_loc_id = dev.location.st_loc_id
    installed_app_detail = get_installed_app_detail(user, st_loc_id)
    if installed_app_detail.status_code == 200:
        try:
            st_installed_app_id = json.loads(installed_app_detail.content.decode('utf-8'))\
                                      .get("st_installed_app_id")
        except Exception as e:
            err_detail = "{}\n{}".format(repr(e), installed_app_detail)
            return_error_msg("subscribe_device", err_detail)
            return {"status_code": 500, "msg": "Error happens when processing the details of the installed app."}
    else:
        return {"status_code": installed_app_detail.status_code, "msg": installed_app_detail.content}
    url = '{}st/installed-apps/{}/subscription/'.format(
        settings.IOTCORE_URL,
        st_installed_app_id
    )
    body = {"dev_id": dev.id}
    resp = send_post_request_to_core(user, url, body=body, req_json=True)
    return {"status_code": resp.status_code, "msg": resp.content}


def get_now():
    if settings.USE_TZ:
        return timezone.now()
    else:
        return datetime.now()

def send_get_request_to_core(user, url):
    access_token = get_access_token(user)

    if not access_token is None:
        headers = {'Authorization': 'Bearer {}'.format(access_token)}
        resp = requests.get(url, headers=headers)
        
        if resp.status_code == 200:
            return JsonResponse(resp.json(), safe=False)
        else:
            try:
                err_msg = "Url: {}\nResponse: {}".format(url, str(resp.json()))
            except json.decoder.JSONDecodeError:
                err_msg = "Url: {}\nResponse: {}".format(url, resp.text)
            return return_error_msg("send_get_request_to_core", err_msg, status=resp.status_code)
    else:
        err_msg = "Cannot find access token."
        return return_error_msg("send_get_request_to_core", err_msg, status=403)

def send_post_request_to_core(user, url, body, req_json=False):
    access_token = get_access_token(user)

    if not access_token is None:
        headers = {'Authorization': 'Bearer {}'.format(access_token)}
        if req_json:
            resp = requests.post(url, json=body, headers=headers)
        else:
            resp = requests.post(url, data=body, headers=headers)
        
        if resp.status_code == 200:
            return JsonResponse(resp.json(), safe=False)
        else:
            try:
                err_msg = "Url: {}\nResponse: {}".format(url, str(resp.json()))
            except json.decoder.JSONDecodeError:
                err_msg = "Url: {}\nResponse: {}".format(url, resp.text)
            return return_error_msg("send_post_request_to_core", err_msg, status=resp.status_code)
    else:
        err_msg = "Cannot find access token."
        return return_error_msg("send_post_request_to_core", err_msg, status=403)


def execute_commands_on_core_vd(location, req):
    '''
    Sending command to iotcore for excusion, triggered by virtual devs
    Input:
        location: (Location) the location where the command should take place
        req:      (dict)
            {
                'actions': [{...}]
            }
    '''
    return execute_commands_on_core(location, req, settings.IOTCORE_VD_URL)

def execute_commands_on_core_st(user, location, req):
    '''
    Sending command to iotcore for excusion\n
    Input:
        location: (Location) the location where the command should take place
        req:      (list) 
                  [{
                        'capability': 'xxxx', 
                        'devid': 'xxx', 
                        'command': 'xxx',
                        'values': {'st_param_id': 'parval_value'}
                   }]
    '''
    api_base_url = "{}{}".format(settings.IOTCORE_URL, 'st/')
    access_token = get_access_token(user)
    return execute_commands_on_core(location, req, api_base_url, access_token=access_token)

def execute_commands_on_core(location, req, api_base_url, access_token=None):
    '''
    Sending command to iotcore for excusion\n
    Input:
        location: (Location) the location where the command should take place
        req:      (list) 
                  [{
                        'capability': 'xxxx', 
                        'devid': 'xxx', 
                        'command': 'xxx',
                        'values': {'st_param_id': 'parval_value'}
                   }]
    '''
    st_installed_app_id = location.st_installed_app_id
    url = api_base_url + 'installed-apps/%s/command/' % st_installed_app_id
    
    cookie_url = api_base_url + 'get_cookie/'
    with requests.Session() as s:
        s = requests.Session()
        s.get(cookie_url)
        if isinstance(req, dict):
            # for handling legacy code
            req = req['actions']
        ErrorLog.objects.create(err="execute_commands_on_core: req={}".format(req))
        if access_token:
            headers = {'Authorization': 'Bearer {}'.format(access_token)}
            resp = s.post(url, json=req, headers=headers)
        else:
            resp = s.post(url, json=req)
    if resp.status_code == 200:
        return JsonResponse(resp.json(), safe=False)
    else:
        try:
            err_msg = "Url: {}\nResponse: {}".format(url, str(resp.json()))
        except json.decoder.JSONDecodeError:
            err_msg = "Url: {}\nResponse: {}".format(url, resp.text)
        return return_error_msg("execute_commands_on_core", err_msg, status=resp.status_code)


def return_error_msg(func_name, err, status=500):
    # err_msg = "{}: {}\n{}".format(func_name, err, traceback.format_exc())
    ErrorLog.objects.create(
        function=func_name,
        err="{}\n{}".format(err, traceback.format_exc())
    )
    return JsonResponse({}, status=status)

# @TODO: this is copied from util.py, need to find a way to avoid duplicated code
def stval_to_val(param: Parameter, st_val):
    if param.type in ('bin', 'set'):
        try:
            return ParValMapping.objects.get(param=param, st_val=st_val).val
        except ParValMapping.DoesNotExist:
            err_msg = "cannot find error mapping for %s of parameter %s" % (st_val, param.name)
            ErrorLog.objects.create(err=err_msg)
            raise Exception(err_msg)
    elif param.type in ('range', 'color'):
        return st_val
    else:
        err_msg = "param type %s not supported yet" % param.type
        ErrorLog.objects.create(err=err_msg)
        raise Exception(err_msg)

def create_initial_log(dev: Device, cap: Capability, param: Parameter, value):
    state, created = State.objects.get_or_create(cap=cap, dev=dev, action=False)
    state.text = "{}".format(value)
    state.save()
    parval, created = ParVal.objects.get_or_create(state=state, par=param, val=str(value))
    StateLog.objects.create(
        status=StateLog.CURRENT,
        cap=cap,
        dev=dev,
        param=parval.par,
        value=parval.val,
        is_superifttt=False,
        loc=dev.location
    )

def stapp_exists(user, client_id, client_secret):
    url = '{}st/apps/exists/'.format(settings.IOTCORE_URL)
    body = {"client_id": client_id, "client_secret": client_secret}
    return send_post_request_to_core(user, url, body, req_json=True)

# emumeric type, command names are same as option names
def st_action_handler_enum_type_1(pvs):
    if len(pvs.items()) != 1:
        err_msg = "type 1 caps should only have one attribute"
        ErrorLog.objects.create(err=err_msg)
        raise Exception(err_msg)
    
    _, value = list(pvs.items())[0]
    value_dict = {}
    command_name = value
    return {"command": command_name, "values": value_dict}

# enumeric type command is "set[AttributeName]"
def st_action_handler_enum_type_2(pvs):
    if len(pvs.items()) != 1:
        err_msg = "type 2 caps should only have one attribute"
        ErrorLog.objects.create(err=err_msg)
        raise Exception(err_msg)
    
    argument_name, value = list(pvs.items())[0]
    value_dict = {argument_name: value}
    command_name = 'set' + argument_name.capitalize()
    return {"command": command_name, "values": value_dict}

# color type command "setColor"
def st_action_handler_color_type(pvs):
    if len(pvs.items()) != 1:
        err_msg = "type color caps should only have one attribute"
        ErrorLog.objects.create(err=err_msg)
        raise Exception(err_msg)
    
    _, value = list(pvs.items())[0]
    hue, saturation = value.split(',')
    hue = int(hue)
    saturation = int(saturation)
    value_dict = {'color': {'hue': hue, 'saturation': saturation}}
    command_name = 'setColor'
    return {"command": command_name, "values": value_dict}

st_action_handler = {
    "enum_type_1": st_action_handler_enum_type_1,
    "enum_type_2": st_action_handler_enum_type_2,
    "color_type": st_action_handler_color_type
}
