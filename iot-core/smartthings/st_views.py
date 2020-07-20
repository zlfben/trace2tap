from django.http import JsonResponse, Http404, HttpResponse
from django.core.exceptions import PermissionDenied
from django.conf import settings

from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny

from smartthings.models import STApp, STAppConfPage, STAppInstance, Device, Location, \
                               STAppConfSectionDeviceSetting, STAppInstanceSetting, \
                               STAppConfSectionParagraphSetting, Capability, ErrorLog
from smartthings.serializers import STAppConfSectionSerializer, DeviceSerializer, LocationSerializer
from smartthings.util import st_event_to_proj, get_device_caps, add_devices_to_proj, \
                             add_subscriptions, get_location_detail, get_devices, \
                             return_error_msg, cap_id_to_name, get_device_status
from httpsig.verify import HeaderVerifier, Verifier

import json


### Callback Request Process
@api_view(['POST'])
@permission_classes((AllowAny, ))
def callback(request, proj):
    if request.method == 'POST':
        try:
            stapp = STApp.objects.get(app_id = proj)
            lifecycle = request.data.get("lifecycle")
            # @TODO: fix the signature verification
            #if lifecycle != 'PING':
                #hv = HeaderVerifier(headers=request.META, secret=get_public_key(), method='POST', path='/st/apps/{}/callback/'.format(stapp.app_id))
                #try:
                #    if hv.verify():
                #        return callback_process(request, stapp)
                #    else:
                #        raise PermissionDenied
                #except Exception as e:
                #    raise PermissionDenied 
            return callback_process(request, stapp)
        except STApp.DoesNotExist:
            raise Http404("SmartThings App does not exist")
        except Exception as e:
            ErrorLog.objects.create(err="{}".format(e))
            return JsonResponse({"msg": repr(e)}, status = 500)



### Internal Functions

def callback_process(request, stapp):
    '''
    Process the request that SmartThings sent to callback
    Input:
        request:    the request that ST sent
        stapp:      the related STApp
    '''
    if request.method == 'POST':
        lifecycle = request.data.get("lifecycle")
        response = None
        if lifecycle == 'PING': 
            return JsonResponse(ping_callback(request.data.get("pingData")), status = 200)

        elif lifecycle == 'CONFIGURATION':
            data = request.data.get("configurationData")
            # st_installed_app_id = data.get("installedAppId")
            phase = data.get("phase")
            if phase == "INITIALIZE":
                return JsonResponse(conf_init_callback(stapp, data), status = 200)
            elif phase == "PAGE":
                page_id = data["pageId"]
                return JsonResponse(conf_page_callback(stapp, page_id, data), status = 200)
        elif lifecycle == 'INSTALL':
            data = request.data.get("installData")
            settings = request.data.get("settings")
            # @TODO: This is written for testing, not sure how smart things are going to handle our error msg,
            # probably have a better way to handle it
            return install_callback(stapp, data, settings)
        elif lifecycle == 'UPDATE':
            data = request.data.get("updateData")
            settings = request.data.get("settings")
            # @TODO: This is written for testing, not sure how smart things are going to handle our error msg,
            # probably have a better way to handle it
            resp = update_callback(stapp, data, settings)
            if resp['status'] == 200:
                return JsonResponse(resp['response'], status = 200)
            elif resp['status'] == 400:
                raise Http404(resp['response'])
            else:
                return JsonResponse(resp['response'],status = resp['status'])
        elif lifecycle == 'EVENT':
            data = request.data.get("eventData")
            installed_id = data["installedApp"]["installedAppId"]
            # return JsonResponse(
            #     event_callback(stapp, data),
            #     status = 200
            # )
            return event_callback(stapp, installed_id, data)
        elif lifecycle == 'OAUTH_CALLBACK':
            data = request.data.get("oAuthCallbackData")
            return JsonResponse(oauth_callback(stapp, data), status = 200)
        elif lifecycle == 'UNINSTALL':
            data = request.data.get("uninstallData")
            return JsonResponse(uninstall_callback(stapp, data), status = 200)
        else:
            pass

def ping_callback(data):
    return {
        "pingData": {
            "challenge": data.get("challenge")
        }
    }

def conf_init_callback(stapp, data):
    '''
    @TODO: needs to be serialized
    '''
    stapp_perms = []
    for perm in stapp.permissions.all():
        stapp_perms.append(perm.scope)
    return {
        "configurationData": {
            "initialize": {
                "name": stapp.name,
                "description": stapp.description,
                "id": stapp.app_id,
                "permissions": stapp_perms,
                "firstPageId": "{}_page_1".format(stapp.app_id).replace('-', '_')
            }
        }
    }

def conf_page_callback(stapp, page_id, data):
    '''
    @TODO: needs to be serialized
    '''
    page = STAppConfPage.objects.get(st_app=stapp, pageId=page_id)
    
    section_list = []
    for section in page.sections.all():
        section_serializer = STAppConfSectionSerializer(section)
        section_list.append(section_serializer.data)
    
    return {
        "configurationData": {
            "page": {
                "pageId": page_id,
                "name": page.name,
                "nextPageId": page.nextPageId,
                "previousPageId": page.previousPageId,
                "complete": page.complete,
                "sections": section_list
            }
        }
    }

def install_callback(stapp, data, settings):
    try:
        ErrorLog.objects.create(err="install_callback: {}".format(data))
        # need to figure out how to use settings here
        app_data = data["installedApp"]
        st_installed_app_id = app_data["installedAppId"]
        stapp_instance, instance_created = STAppInstance.objects.get_or_create(
            st_app = stapp,
            st_installed_app_id = st_installed_app_id
        )
        if stapp_instance.refresh_token is None or stapp_instance.refresh_token == "":
            # initialization of the refresh token
            # for future updating, it should happen in get_latest_access_token instead of here
            stapp_instance.refresh_token = data["refreshToken"]
        stapp_instance.save()
        location = get_or_create_location(
            st_installed_app_id=st_installed_app_id,
            st_loc_id = app_data["locationId"]
        )
        stapp_instance = STAppInstance.objects.get(st_installed_app_id=st_installed_app_id)
        stapp_instance.location = location
        stapp_instance.save()

        config_data = app_data["config"]
        perm_data = app_data.pop("permissions")

        related_devices = []
        for setting_name, setting_items in config_data.items():
            # one setting
            for item in setting_items:
                # one device / parameter / paragraph (display only)
                item_type = item.get("valueType", None)

                if item_type is None:
                    err_msg = "Invalid device data - {}".format(str(dev))
                    return return_error_msg("install_callback", err_msg, status=400)

                if item_type == "DEVICE":
                    setting = STAppConfSectionDeviceSetting.objects.get(
                        st_app_id=stapp.app_id,
                        setting_id=setting_name
                    )
                    dev = get_or_create_device(
                        # the name is only for now...should have a better default name
                        dev_name="{}_{}".format(setting_name, setting_items.index(item)),
                        st_dev_id=item["deviceConfig"]["deviceId"],
                        st_installed_app_id = st_installed_app_id
                    )
                    stapp_instance_setting = STAppInstanceSetting.objects.create(
                        setting = setting,
                        st_app_instance = stapp_instance
                    )
                    stapp_instance_setting.device_set.add(dev)
                    related_devices.append(dev)
                    # the deivce still need to be updated: capabilities
                    
                elif item_type == "STRING" and len(setting_items) == 1 and len(config_data) == 1:
                    setting = STAppConfSectionParagraphSetting.objects.get(
                        st_app_id=stapp.app_id,
                        setting_id=setting_name
                    )
                    devs = []
                    for perm in perm_data:
                        if perm.endswith("devices:*"):
                            devs = get_devices(st_installed_app_id)
                            break
                    
                    for dev in devs:
                        try:
                            dev_instance = Device.objects.get(st_device_id = dev.get("st_device_id"))
                        except Device.DoesNotExist:
                            dev_serializer = DeviceSerializer(data=dev)
                            if dev_serializer.is_valid():
                                dev_instance = dev_serializer.save()
                                dev_instance.st_app_instance = stapp_instance
                                dev_instance.save()
                            else:
                                err_msg = "Invalid device data - {}".format(str(dev))
                                return return_error_msg("install_callback", err_msg, status=400)
                        if not dev_instance.is_subscribed:
                            add_subscriptions(st_installed_app_id, [dev_instance])

                # @TODO: Add more possible types of settings

        return JsonResponse({"installData": {}})
    
    except STAppConfSectionDeviceSetting.DoesNotExist:
        err_msg = "The requested STApp instance does not contain {} in its settings.".format(setting_name)
        return return_error_msg("install_callback", err_msg, status=404)
    except STAppConfSectionParagraphSetting.DoesNotExist:
        err_msg = "The requested STApp instance does not contain {} in its settings.".format(setting_name)
        return return_error_msg("install_callback", err_msg, status=404)
    except Exception as e:
        return return_error_msg("install_callback", repr(e))

def update_callback(stapp, data, settings):
    response = {'status':200, 'response':{"updateData": {}}}

    app_data = data["installedApp"]
    refresh_token = data["refreshToken"]
    config_data = app_data["config"]
    try:
        stapp_instance = STAppInstance.objects.get(
            st_installed_app_id = app_data["installedAppId"]
        )
        stapp_instance.refresh_token = refresh_token
        stapp_instance.save()
        instance_settings = stapp_instance.instance_settings.all()
        for instance_setting in instance_settings:
            # @TODO: multiple devices for a single setting?
            setting_id = instance_setting.setting.setting_id
            st_dev_id = instance_setting.device.st_device_id
            for prop in config_data[setting_id]:
                if prop["valueType"] == "DEVICE":
                    if prop["deviceConfig"]["deviceId"] != st_dev_id:
                        # usually it's just users who wants to assign a new device to this setting
                        dev, created = Device.objects.get_or_create(
                            st_device_id=prop["deviceConfig"]["deviceId"]
                        )
                        # @TODO: what about name and labels?
                        if created:
                            # request capabilities that the device has
                            caps_id = get_device_caps(app_data["installedAppId"], 
                                                      prop["deviceConfig"]["deviceId"])
                            for cap_id in caps_id:
                                try:
                                    cap = Capability.objects.get(st_id = cap_id)
                                    dev.capabilities.add(cap)
                                except Capability.DoesNotExist:
                                    response['status'] = 500
                                    response['response'] = {
                                        'msg': "It seems Samsung SmartThings has updated their capabilities, \
                                        please contact admin to keep everything updated."
                                    }
                        instance_setting.device = dev
                        instance_setting.save()
    except STAppInstance.DoesNotExist:
        response['status'] = 404
        response['response'] = {
            'msg': "The requested STApp instance does not exist."
        }

    return response

def event_callback(stapp, st_installed_app_id, data):
    status, resp = st_event_to_proj(stapp, st_installed_app_id, data)
    return JsonResponse({"eventData": {}}, status=status)

def oauth_callback(stapp, data):
    return {"oAuthCallbackData": {}}

def uninstall_callback(stapp, data):
    st_installed_app_id = data.get("installedApp").get("installedAppId")
    STAppInstance.objects.filter(st_installed_app_id=st_installed_app_id).delete()
    return {"uninstallData": {}}



def get_public_key():
    try:
        with open('/run/secrets/st_public_key', 'r') as f:
            return f.read()
    except Exception as e:
        ErrorLog.objects.create(err="{}".format(e))
        raise Http404("{}".format(e))

def get_or_create_location(st_installed_app_id, st_loc_id):
    try:
        loc = Location.objects.get(st_id = st_loc_id)
        return loc
    except Location.DoesNotExist:
        loc_detail = get_location_detail(st_installed_app_id, st_loc_id)
        ErrorLog.objects.create(err="get_or_create_location: {}".format(loc_detail))
        if loc_detail:
            loc = Location.objects.create(
                st_id = st_loc_id,
                name = loc_detail.get("name", st_loc_id),
                latitude = loc_detail.get("latitude", None),
                longitude = loc_detail.get("longitude", None)
            )
        else:
            loc = Location.objects.create(
                st_id = st_loc_id,
                name = st_loc_id
            )
        return loc

def get_or_create_device(dev_name, st_dev_id, st_installed_app_id):
    try:
        dev, created = Device.objects.get_or_create(
            st_device_id = st_dev_id
        )
        if created:
            # @TODO: add support for labels
            dev.name = dev_name
            dev.label = dev_name
            # request capabilities that the device has
            caps_id = get_device_caps(st_installed_app_id, st_dev_id)
            for cap_id in caps_id:
                try:
                    cap = Capability.objects.get(st_id = cap_id)
                    dev.capabilities.add(cap)
                except Capability.DoesNotExist:
                    cap = Capability.objects.create(st_id = cap_id, name = cap_id_to_name(cap_id))
                    dev.capability.add(cap)
            
            dev.save()

            sub_resp_status = add_subscriptions(st_installed_app_id, [dev])
            if sub_resp_status != 200:
                ErrorLog.objects.create(err="Creating subscrition for {} failed.".format(dev.name))
                
        return dev

    except Capability.DoesNotExist:
        err_msg = "Cannot find {}. It seems Samsung SmartThings has updated their capabilities, \
                   please contact admin to keep everything updated.".format(cap_id)
        ErrorLog.objects.create(err=err_msg) 
        return None
    except Exception as e:
        ErrorLog.objects.create(err=repr(e)) 
        return None

