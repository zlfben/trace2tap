from django.http import JsonResponse
from django.conf import settings
from django.utils import timezone
from rest_framework import status

from smartthings.models import STAppInstance, Device, Capability, Command, ErrorLog

from bs4 import BeautifulSoup
from datetime import datetime, timedelta
import urllib3, certifi, json, re, requests, traceback


### Capability update
def get_latest_capabilities():
    """
    Get the latest capabilities from Samsung SmartThings's website
    Output: dictionary - {"<cap_name>": {
                            "attributes": [<attr_name>, ...],
                            "commands": {
                                "<comm_name>": [<args_name>, ...]
                            }
                         }}
    """
    http = urllib3.PoolManager(cert_reqs='CERT_REQUIRED', ca_certs=certifi.where())
    resp = http.request('GET', 'https://smartthings.developer.samsung.com/docs/api-ref/capabilities.html')
    soup = BeautifulSoup(resp.data, features="html.parser")
    caps_list = []

    last_cap_html = soup.find('div', class_="docs-cnt").find('h2')
    # iterate over all capabilities
    while not last_cap_html is None:
        # get the name of the capability
        cap_name = last_cap_html.string
        cap_id = cap_name_to_id(cap_name)
        # set up related dictionary
        cap_dict = {
            "st_id": cap_id,
            "name": cap_name,
            "attributes": [], # [{"name": <attr_name>}]
            "commands": [] # [{"name": <comm_name>, "arguments": [{"name": <arg_name>}, ...]}]
        }

        # get all attributes of the capability
        last_line = last_cap_html.find_next_sibling('h3').find_next_sibling('h3')

        # iterate over every line within one capability
        while not last_line.next_sibling is None and last_line.next_sibling.name != 'h3':
            last_line = last_line.next_sibling
            new_attr = {
                "name": "",
                "data_type": "",
                "required": True
            }
            if last_line.name == 'h4':
                new_attr["name"] = last_line.string
                last_line = last_line.find_next_sibling("p")
                num_attempt = 0
                while num_attempt < 10:
                    num_attempt += 1
                    last_line_content = [c.string for c in last_line.contents]
                    if len(last_line_content) == 5 and 'Type: *' == last_line_content[1] and 'Required: *' == last_line_content[3]:
                        data_type = last_line_content[2].split('\n')[0]  # trim \n*
                        required = last_line_content[4]
                        break
                    else:
                        last_line = last_line.find_next_sibling("p")
                new_attr["data_type"] = data_type
                new_attr["required"] = required == 'Yes'
                cap_dict["attributes"].append(new_attr)

        # get all commands of the capability
        last_line = last_line.find_next_sibling('h3')
        while not last_line.next_sibling is None and last_line.next_sibling.name != 'h2':
            last_line = last_line.next_sibling
            if last_line.name == 'h4':
                comm = last_line.string
                comm_name = comm[:comm.index('(')]
                # get all arguments if exist
                args_list = []
                if comm[-2] != '(':
                    last_line = last_line.find_next_sibling('ul')
                    i = 0
                    arg_dict = {}
                    for arg in last_line.children:
                        if arg.string is None:
                            i += 1
                            continue
                        if not re.match(r"^\s*$", arg.string) is None:
                            continue
                        if i % 4 == 0:
                            arg_dict["name"] = arg.string
                        elif i % 4 == 1:
                            reg_result = re.match(r"(Type: )(.*)", arg.string)
                            arg_dict["data_type"] = reg_result.group(2)
                        elif i % 4 == 2:
                            reg_result = re.match(r"(Required: )(Yes|No)", arg.string)
                            arg_dict["required"] = reg_result.group(2) == 'Yes'
                            args_list.append(arg_dict)
                        i += 1
                    
                cap_dict["commands"].append({"name": comm_name, 
                                             "arguments": args_list})
        # save cap_dict to cap_list
        caps_list.append(cap_dict)
        # go to next capability
        last_cap_html = last_line.find_next_sibling("h2")
    return caps_list

def dump_caps():
    caps_list = get_latest_capabilities()
    file_path = "../fixtures/st_caps.json"
    with open(file_path, 'w') as f:
        json.dump(caps_list, f)

def cap_name_to_id(name):
    try:
        word_list = name.split()
        word_list[0] = word_list[0].lower()
        return "".join(word_list)
    except Exception as e:
        ErrorLog.objects.create(err='Error: {}, name: {}'.format(repr(e), name))

def cap_id_to_name(cap_id):
    try:
        cap_id = cap_id[0].upper() + cap_id[1:]
        word_list = re.findall('[A-Z][a-z]*', cap_id)
        return " ".join(word_list)
    except Exception as e:
        ErrorLog.objects.create(err='cap_id_to_name: {}, cap_id: {}'.format(repr(e), cap_id))

### st-end

def exec_proj_cmd_on_st(st_installed_app_id, actions):
    '''
    Executes ifttt cmd on SmartThings (i.e. can be used for commandExecute() in views.py)
    Input:
        st_installed_app_id: (str) installed app id in the SmartThings
        actions: (list)
            [{
                "capability": (str) capability id in SmartThings
                "command": (str) command name in SmartThings,
                "devid": (str) device id in project,
                "values": { "<st_param_id>": "<parval_value>", ...}
            }, ...]
    Output:
        stauts_code:
        resp: {}
    '''
    st_cmd_lst = translate_proj_cmd_to_st(actions)
    resp_status_code = 200
    with requests.Session() as s:
        access_token = get_latest_access_token(st_installed_app_id)
        
        if access_token is None:
            ErrorLog.objects.create(err="exec_proj_cmd_on_st: Cannot retrieve the correct access_token.")
            return 403, {"error": {"message": "Cannot retrieve the correct access_token."}}

        commands = {}
        for st_cmd in st_cmd_lst:
            try:
                st_device_id = st_cmd['st_device_id'] # for the url of the request to st
                cmd = st_cmd['st_cmd'] # actual body of the request to st
            except KeyError:
                ErrorLog.objects.create(err="exec_proj_cmd_on_st: Malformatted request - {}\n{}".format(st_cmd, traceback.format_exc()))
                return 400, {}
            except Exception as e:
                ErrorLog.objects.create(err="exec_proj_cmd_on_st: {}\n{}".format(repr(e), traceback.format_exc()))
                return 400, {}

            if st_device_id in commands:
                commands[st_device_id].append(cmd)
            else:
                commands[st_device_id] = [cmd]
        
        for dev_id in commands:
            api_url = settings.ST_API_BASEURL + 'devices/{}/commands'.format(dev_id)

            headers = {'Authorization': 'Bearer {}'.format(access_token)}
            body = {"commands": commands[dev_id]}
            resp = s.post(api_url, headers=headers, json=body)
            if resp.status_code != 200:
                resp_status_code = resp.status_code
                err_detail = "{} - Response: {}\nRequest: {}".format(resp.status_code, resp.text, body)
                ErrorLog.objects.create(err="exec_proj_cmd_on_st: {}".format(err_detail))
            
    return resp_status_code, {}

def get_device_caps(st_installed_app_id, dev_id):
    api_url = '{}devices/{}'.format(settings.ST_API_BASEURL, dev_id)
    data = send_get_req_to_st(api_url, st_installed_app_id)
    if data:
        cap_list = []
        for component in data:
            for cap in component["capabilities"]:
                cap_list.append(cap["id"])
        return cap_list
    else:
        return None

def get_locations(st_installed_app_id):
    """
    Get all the locations associated with a location
    - Input:
        - st_installed_app_id: the id of the installed app (set by smartthings)
    - Output: List
        - [
            {"locationId": "xxxxxxxx", "name": "xxxxx"},
            ...
        ]
    """
    url = settings.ST_API_BASEURL + 'locations'
    resp = send_get_req_to_st(url, st_installed_app_id)
    return resp.get("items", None) if resp else None

def get_location_detail(st_installed_app_id, st_loc_id):
    """
    Get details about a location
    Input:
        - st_installed_app_id: the id of the installed app (set by smartthings)
        - st_loc_id: the SmartThings id of the location
    Output: Dict
        - {
            "locationId": "6b3d1909-1e1c-43ec-adc2-5f941de4fbf9",
            "name": "Home",
            "countryCode": "USA",
            "latitude": 45.00708112,
            "longitude": -93.11223629,
            "regionRadius": 150,
            "temperatureScale": "F",
            "timeZoneId": "America/Chicago",
            "locale": "en"
        }
    Source:
        - https://smartthings.developer.samsung.com/docs/api-ref/st-api.html#operation/getLocation
    """
    url = settings.ST_API_BASEURL + 'locations/{}'.format(st_loc_id)
    return send_get_req_to_st(url, st_installed_app_id)

def translate_proj_cmd_to_st(proj_cmd):
    '''
    Extracts info from proj_cmd for the request to SmartThings API\n
    Input: 
        - proj_cmd: [{
            "devid": (int) device id in that project,
            "capability": (str) capability id in SmartThings,
            "command": (str) command name in SmartThings,
            "values": {
                <arg name>: <arg value>,
                ...
            }
        }, ...]
    Output: 
        - Success: [{
            "st_device_id": <SmartThings device id>,
            "st_cmd": {
                    "component": "main",
                    "capability": (str)<capability id in SmartThings>,
                    "command": <command name>,
                    "arguments": [<arg values>, ...]
                }
        }]
        - Failure: []
    '''
    resp = []
    for cmd in proj_cmd:
        st_action = {}
        proj_device_id = cmd['devid'] # int
        st_device_id = translate_proj_device_id_to_st(proj_device_id)
        if st_device_id is None:
            # error has already been logged
            continue
        st_action["st_device_id"] = st_device_id
        
        # get command
        try:
            capability = Capability.objects.get(st_id=cmd['capability'])
            command = Command.objects.get(capability=capability, name=cmd['command'])
        except Capability.DoesNotExist:
            # err_detail = "translate_proj_cmd_to_st: Cannot find capability: {}".format(cmd['capability'])
            # ErrorLog.objects.create(err = err_detail)
            continue
        except Command.DoesNotExist:
            err_detail = "translate_proj_cmd_to_st: Cannot find command: {}".format(cmd['command'])
            ErrorLog.objects.create(err = err_detail)
            continue

        arguments = []
        for argname in cmd['values']:
            if is_int(cmd['values'][argname]):
                cmd['values'][argname] = int(cmd['values'][argname])
            arguments.append(cmd['values'][argname])
        
        st_cmd = {"component": "main",
                "capability": capability.st_id,
                "command": command.name,
                "arguments": arguments}
        st_action['st_cmd'] = st_cmd
        resp.append(st_action)

    return resp
    
def translate_proj_device_id_to_st(incoming_proj_device_id):
    ''' 
    To convert the given proj_device_id to its equivalent st_device_id;\n
    Input: 
        incoming_proj_device_id : (int) a proj_device_id
    Output:
        Success: (str) an st_device_id
        Failure: None
    '''
    real_device = None
    try:
        real_device = Device.objects.get(proj_device_id=incoming_proj_device_id)
    except Device.DoesNotExist:
        err_detail = "translate_proj_device_id_to_st: device with proj_device_id {} does not exist in database".format(incoming_proj_device_id)
        ErrorLog.objects.create(err=err_detail)
        return None
    except Device.MultipleObjectsReturned:
        err_detail = "translate_proj_device_id_to_st: there are multiple devices with proj_device_id {} in the database:".format(incoming_proj_device_id)
        ErrorLog.objects.create(err=err_detail)
        return None
    return real_device.st_device_id

def get_devices(st_installed_app_id):
    """
    Get all the devices associated with the installed app
    - Input:
        - st_installed_app_id: the id of the installed app (set by smartthings)
    - Output: List
        - [
            {
                "name": "xxxxx", 
                "label": "xxxxx",
                "st_device_id": "xxxxxx",
                "component_id": "xxxx",
                "capabilities": ["<cap_st_id>", ...]
            },
            ...
        ]
    """
    try:
        url = settings.ST_API_BASEURL + 'devices'
        data = send_get_req_to_st(url, st_installed_app_id)
        if data:
            dev_list = []
            for dev in data["items"]:
                filtered_dev = {
                    "name": dev["name"],
                    "label": dev["label"],
                    "st_device_id": dev["deviceId"],
                    "component_id": "main",
                }
                caps = []
                for component in dev["components"]:
                    if component["id"] == "main":
                        for cap in component["capabilities"]:
                            caps.append(cap["id"])
                filtered_dev["capabilities"] = caps
                dev_list.append(filtered_dev)
            return dev_list
        else:
            return []
    except Exception as e:
        err_msg = "{}: {}\n{}\nData: {}".format("get_devices", repr(e), traceback.format_exc(), str(data))
        ErrorLog.objects.create(err=err_msg) 
        return JsonResponse({"msg": err_msg}, status=500)

def get_device_status(st_installed_app_id, device_id):
    """
    Get the status of a device\n
    Input:
        st_installed_app_id: the id in SmartThings of an installed app instance
        device_id: the SmartThings id of a device
    Output:
        success:    
        {
            cap_name: {
                attr_name: {"value": value}
            }, 
            ...
        }
        fail: {}
    """
    try:
        url = settings.ST_API_BASEURL + 'devices/{}/status'.format(device_id)
        data = send_get_req_to_st(url, st_installed_app_id)

        if data is None:
            err_msg = "get_device_status: send_get_req_to_st() failed\nURL: {}".format(url)
            ErrorLog.objects.create(err=err_msg)
            return {}
        
        # if receive resp from st successfully
        return data.get("components", {}).get("main", {})
        
    except Exception as e:
        err_msg = "get_device_status: {}".format(repr(e))
        ErrorLog.objects.create(err=err_msg)
        return {}

def send_get_req_to_st(url, st_installed_app_id):
    """
    Send GET request to SmartThings
    Input:
        - url: the target url
        - st_installed_app_id: the STapp instance's id
    Output:
        - success: the original response from SmartThings
        - failure: None
    """
    access_token = get_latest_access_token(st_installed_app_id)

    try:
        if not access_token is None:
            headers = {'Authorization': 'Bearer {}'.format(access_token)}
            resp = requests.get(url, headers=headers)
            return resp.json()
        else:
            return None
    except Exception as e:
        ErrorLog.objects.create(err="send_get_req_to_st: {}".format(repr(e)))
        return None

def send_delete_req_to_st(url, st_installed_app_id):
    """
    Send DELETE request to SmartThings
    Input:
        - url: the target url
        - st_installed_app_id: the STapp instance's id
    Output:
        - (response from `requests`) the original response from ST
    """
    access_token = get_latest_access_token(st_installed_app_id)
    ErrorLog.objects.create(err="send_delete_req_to_st: access_token={}".format(access_token))

    if not access_token is None:
        headers = {'Authorization': 'Bearer {}'.format(access_token)}
        resp = requests.delete(url, headers=headers)
        ErrorLog.objects.create(err="send_delete_req_to_st: resp.text={}".format(resp.text))
        return resp
    else:
        return None

def get_latest_access_token(st_installed_app_id):
    try:
        stapp_instance = STAppInstance.objects.get(st_installed_app_id=st_installed_app_id)
            
        # if access_token is set and not expired, then get the access token directly from database
        if stapp_instance.access_token_expired_at:
            if get_now() < stapp_instance.access_token_expired_at:
                return stapp_instance.access_token

        # otherwise we have to refresh the token
        # get client_id and client_secret of the installed_app
        stapp = stapp_instance.st_app
        client_id = stapp.client_id
        client_secret = stapp.client_secret
        refresh_token = stapp_instance.refresh_token

        # @TODO: Error handling...should be in except
        if client_id is None or client_secret is None:
            ErrorLog.objects.create(
                err="get_latest_access_token: STApp's credentials are missing."
            )
            return None

        if refresh_token is None or refresh_token == "":
            ErrorLog.objects.create(
                err="get_latest_access_token: STApp's refresh token is missing."
            )
            return None

        api_url = settings.ST_API_AUTHURL + "oauth/token"
        fields = {
            'grant_type': 'refresh_token', 
            'client_id': client_id,
            'client_secret': client_secret,
            'refresh_token': refresh_token
        }
        auth = requests.auth.HTTPBasicAuth(client_id, client_secret)
        r = requests.post(url=api_url, data=fields, auth=auth)
        resp = r.json()
        if r.status_code == status.HTTP_200_OK:
            ErrorLog.objects.create(err="get_latest_access_token: 200 - resp={}".format(resp))
            stapp_instance.refresh_token = resp["refresh_token"]
            stapp_instance.access_token = resp["access_token"]
            stapp_instance.access_token_expired_at = get_now() + timedelta(seconds=resp.get("expires_in", 0)-3600)
            stapp_instance.save()
            return resp["access_token"]
        else:
            ErrorLog.objects.create(err="get_latest_access_token: {}\nfields={}\nst_installed_app_id={}".format(str(resp), fields, st_installed_app_id))
            return None
                
    except STAppInstance.DoesNotExist:
        ErrorLog.objects.create(
            err="get_latest_access_token - Error: {}".format(repr(STAppInstance.DoesNotExist))
        )
        return None
    except Exception as e:
        ErrorLog.objects.create(
            err="get_latest_access_token - Error: {}".format(repr(e))
        )
        return None

### project-end
def get_proj_endpoint(stapp):
    if settings.DOCKER:
        return stapp.docker_endpoint
    elif not settings.DEBUG:
        return stapp.prod_endpoint
    else:
        return stapp.debug_endpoint

def get_proj_csrf_cookie(stapp):
    if not settings.DEBUG:
        http = urllib3.PoolManager(cert_reqs='CERT_REQUIRED', ca_certs=certifi.where())
    else:
        http = urllib3.PoolManager()

    api_url = get_proj_endpoint(stapp) + "user/get_cookie/"
    try:
        resp = http.request('GET', api_url)
        if "Set-Cookie" in resp.headers:
            match = re.search(r"csrftoken=(.*?);", resp.headers["Set-Cookie"])
            if match:
                return match.group(1)
            else:
                return None
        else:
            return {"error":{"message": "Backend doens't put Set-Cookie in the response's headers."}}
    except urllib3.exceptions.MaxRetryError:
        return {"error":{"message": "Backend is not responding."}}
    except urllib3.exceptions.NewConnectionError:
        return {"error":{"message": "Backend is not responding."}}

def get_csrf_header(stapp, json=False):
    csrftoken = get_proj_csrf_cookie(stapp)

    if csrftoken is None:
        return 401, {"error": {"message": "CSRF Token is empty."}}
    elif type(csrftoken) == dict:
        # if an error message is returned
        return 401, csrftoken

    headers = {
        'X-CSRFToken': csrftoken,
        'Cookie': 'csrftoken=' + csrftoken
    }

    if json:
        headers['Content-Type'] = 'application/json'

    return status.HTTP_200_OK, {'headers': headers}

def send_proj_json_post_request(stapp, api_url, body={}):
    '''
    Send a POST request to the project by using JSON. \n
    Input:
        stapp   : (STApp object) the target project
        api_url : (str) the target URL
        body    : (dict) the data that need to be sent. `{}` will be used if nothing provided.
    Output:
        status_code : the status code of the response
        resp.json() : (dict) the dictionary of the JSON response
    '''
    with requests.Session() as s:
        s = requests.Session()
        # get the csrf cookie first
        s.get("{}{}".format(get_proj_endpoint(stapp), "backend/user/get_cookie/"))
        csrftoken = s.cookies.get('csrftoken')
        headers = {'X-CSRFToken': csrftoken}
        resp = s.post(api_url, json=body, headers=headers)
    if resp.status_code != status.HTTP_200_OK:
        ErrorLog.objects.create(
            err="send_proj_json_post_request: {} - {}\nRequest Headers:{}".format(resp.status_code, resp.text, resp.request.headers)
        )
        return resp.status_code, {}
    else:
        return resp.status_code, resp.json()

def add_devices_to_proj(st_installed_app_id):
    try:
        stapp_instance = STAppInstance.objects.get(st_installed_app_id=st_installed_app_id)
        stapp_instance_settings = stapp_instance.instance_settings.all()
        api_url = get_proj_endpoint(stapp_instance.st_app) + "st/devices/add/"

        created_devs = []
        for instance_setting in stapp_instance_settings:
            devices = instance_setting.device_set
            for dev in devices:
                body = {
                    "name": dev.name,
                    "capabilities": [{"id": cap.st_id} for cap in dev.capabilities.all()]
                }
                # send the needs-to-be-added device to backend
                status, resp_data = send_proj_json_post_request(stapp_instance.st_app, api_url, body)

                if status != status.HTTP_200_OK:
                    err_msg = "send_proj_json_post_request() failed for device {}. \n Status: {}. \n\
                            Response: {} \n Request: {}".format(body["name"], status, resp_data, str(body))
                    return return_error_msg("add_devices_to_proj", err_msg, status=status)
                else:
                    created_devs.append({dev.st_device_id: resp_data["devid"]})
                    dev.proj_device_id = resp_data["devid"]
                    dev.save()

        return JsonResponse({"msg": "Success!", "created_devs": created_devs}, status=status.HTTP_200_OK)

    except STAppInstance.DoesNotExist:
        err_msg = "The required stapp instance doesn't exist."
        ErrorLog.objects.create(err=err_msg)
        return 404, {"msg": err_msg}
    except Exception as e:
        ErrorLog.objects.create(err="add_devices_to_proj: {}".format(repr(e)))
        return 500, {"msg": repr(e)}
    
def add_subscriptions(st_installed_app_id, devices):
    '''
    Add subscriptions for devices\n
    Input:
        st_installed_app_id:    (str) the id of the installed app in SmartThings
        devices:                (list) a list of device instances
    Output:
        status_code:    the status code of the response
    '''
    try:
        api_url = "{}installedapps/{}/subscriptions".format(settings.ST_API_BASEURL, st_installed_app_id)
        for dev in devices:
            dev_body = {
                "sourceType": "DEVICE",
                "device": {
                    "deviceId": dev.st_device_id,
                    "componentId": "main",
                    "capability": "*",
                    "attribute": "*",
                    "value": "*"
                }
            }
            access_token = get_latest_access_token(st_installed_app_id)
            if not access_token is None: 
                headers = {'Authorization': 'Bearer {}'.format(access_token)}
                resp = requests.post(api_url, json=dev_body, headers=headers)
                if resp.status_code != status.HTTP_200_OK:
                    ErrorLog.objects.create(err="add_subscriptions: Failed: {} - {}".format(resp.status_code, resp.text))
                    return resp.status_code
                else:
                    dev.is_subscribed = True
                    dev.subscription = resp.json().get("id", "")
                    dev.save()
            else:
                ErrorLog.objects.create(err="add_subscriptions: Cannot get access token.")
                return status.HTTP_500_INTERNAL_SERVER_ERROR
        return status.HTTP_200_OK
    except Exception as e:
        ErrorLog.objects.create(err="add_subscriptions: Error: {}".format(e))
        return status.HTTP_500_INTERNAL_SERVER_ERROR

def delete_subscriptions(st_installed_app_id, devices):
    '''
    Delete subscriptions for devices\n
    Input:
        st_installed_app_id:    (str) the id of the installed app in SmartThings
        devices:                (list) a list of device instances
    Output:
        status_code:    the status code of the response
    '''
    for dev in devices:
        api_url = "{}installedapps/{}/subscriptions/{}".format(
            settings.ST_API_BASEURL, 
            st_installed_app_id, 
            dev.subscription
        )
        resp = send_delete_req_to_st(api_url, st_installed_app_id)
        if resp.status_code != status.HTTP_200_OK:
            ErrorLog.objects.create(err="delete_subscriptions: {}\nDevice: {}".format(resp.json(), dev.name))
            return resp.status_code
        else:
            dev.is_subscribed = False
            dev.subscription = ""
            dev.save()
    return status.HTTP_200_OK

def st_event_to_proj(stapp, st_installed_app_id, data):
    '''
    Send the event (from ST) to related project and waiting for actions response
    Input:
        stapp - Indicate which stapp this data should goes to
        st_installed_app_id - The id of the installed SmartThings app instance
        data - the event data that ST send to our callback endpoint
    Output:
        status - an integer
                 200 means everything is successful
                 500 means something goes wrong along the process
        resp - a dict
               if everything goes with the plan (i.e. status == 200):
               {
                    "msg": "Success!"
               }
               if something goes wrong (i.e. status == 500):
               {
                    "msg": "x events failed to be sent",
                    "errors": [...]
               }
    '''
    api_url = get_proj_endpoint(stapp) + "st/update/"
    events = data["events"]
    st_status = 0
    
    error_list = []
    response = {}
    for event in events:
        if event["eventType"] == "DEVICE_EVENT":
            event_data = event["deviceEvent"]
            try:
                dev = Device.objects.get(st_device_id=event_data["deviceId"])
                body = {
                    "st_installed_app_id": st_installed_app_id,
                    "capid": event_data["capability"],
                    "deviceid": dev.proj_device_id,
                    "values": {
                        event_data["attribute"]: event_data["value"]
                    }
                }

                status, resp_data = send_proj_json_post_request(stapp, api_url, body)

                if status == 200:
                    # resp_data: {
                    #     "actions": [{
                    #             "capability": "<commandname>",
                    #             "devid": "<device proj id>",
                    #             "values": { "<st_param_id>": "<parval_value>", ...}
                    #         }, ...],
                    #     "errors": [{"msg": "<error_details>"}, ...]
                    # }
                    if resp_data:
                        st_status, response = exec_proj_cmd_on_st(st_installed_app_id, resp_data)
                    else:
                        response = resp_data
                else:
                    error_list.append({
                        "msg": "The event is failed to be sent.",
                        "data": body,
                        "response": resp_data
                    })

            except Device.DoesNotExist:
                error_list.append({
                    "msg": "Cannot find device '{}'.".format(event_data["deviceId"]),
                    "data": "",
                    "response": ""
                })
    if len(error_list) == 0:
        if st_status == 0 or st_status == 200:
            # st_status == 0 means that no action needs to be taken
            return 200, response
        else:
            return st_status, response
    else:
        return 500, {
            "msg": "%d events failed to be sent." % (len(error_list)),
            "errors": error_list
        }


### Helpers

def get_now():
    if settings.USE_TZ:
        return timezone.now()
    else:
        return datetime.now()

def return_error_msg(func_name, err, status=500):
    err_msg = "{}: {}\n{}".format(func_name, err, traceback.format_exc())
    ErrorLog.objects.create(err=err_msg)
    return JsonResponse({"msg": err_msg}, status=status)

def is_int(s):
    try:
        int(s)
        return True
    except (ValueError, TypeError) as e:
        return False
