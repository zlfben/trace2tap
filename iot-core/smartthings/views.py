from django.http import JsonResponse
from django.conf import settings

from rest_framework import generics, viewsets, permissions, status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes, throttle_classes
from rest_framework.throttling import AnonRateThrottle

from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.utils.datastructures import MultiValueDictKeyError
from django.views.decorators.csrf import csrf_exempt, ensure_csrf_cookie
from django.shortcuts import get_object_or_404

from oauth2_provider.contrib.rest_framework import TokenHasScope

from smartthings.models import STAppInstance, Capability, Device, STApp, Location, ErrorLog
from smartthings.serializers import STAppSerializer, STAppInstanceSerializer, \
                                    CapabilitySerializer, DeviceSerializer, \
                                    DeviceSummarySerializer, LocationSerializer, \
                                    DeviceIdMappingSerializer, DeviceSubscriptionSerializer
from smartthings.util import get_latest_capabilities, exec_proj_cmd_on_st, get_devices, add_subscriptions, \
                             delete_subscriptions, get_device_status

import random, string, json, traceback

# custom throttling
class RegisterAnonThrottle(AnonRateThrottle):
    rate = '20/day'

# Create your views here.

### Function-based API Views
@api_view(['GET'])
@permission_classes((permissions.AllowAny, ))
@ensure_csrf_cookie
def getCookie(request):
    return JsonResponse({})

@api_view(['POST'])
@permission_classes((permissions.AllowAny, ))
@throttle_classes([RegisterAnonThrottle])
def userRegister(request):
    try:
        # user creation
        username = request.POST['username']
        password = request.POST['password']
        if len(User.objects.filter(username=username)) > 0:
            return JsonResponse({"msg": "Username already exists!"}, status=409)
        user = User.objects.create_user(username=username, password=password)
        user.save()
        stapp = STApp.objects.create(app_id="superifttt-{}".format(username))
        stapp.users.add(user)
        stapp.save()
        login(request, user, backend='django.contrib.auth.backends.ModelBackend')
        return JsonResponse({"userid": user.id}, status=200)
    except MultiValueDictKeyError:
        return JsonResponse({"msg": "Username or password cannot be none!"}, status=500)
    except Exception as e:
        return JsonResponse({"msg": repr(e)}, status=500)

@api_view(['POST'])
@login_required()
def commandExecute(request, installed_appid):
    '''
    Function:   receive commands from projects
    URL:        not decided
    Status:     construction
    '''
    # need to be changed (if needed)
    if request.method == 'POST':
        data = request.data
        ErrorLog.objects.create(err="vd_action_data: " + str(data))
        status, msg = exec_proj_cmd_on_st(installed_appid, data)
        return JsonResponse(msg, status = status)


@api_view(['GET'])
@login_required()
def getLocations(request, appid):
    '''
    Get all the locations that the user has registered and the assoicated stapp instance
    Input:
        - appid: the STApp ID (e.g. superifttt-hewj)
    Output:
        - {
            "locations": [
                {"name": "xxx", "locid": "xxxx", "st_installed_app_id": "xxxx"},
                ...
            ]
        }
    URL: 
    '''
    stapp_instances = STAppInstance.objects.filter(
        st_app__users=request.user, 
        st_app__app_id=appid
    )
    location_list = []
    for instance in stapp_instances:
        location = instance.location
        location_list.append({
            "name": location.name,
            "locid": location.st_id,
            "st_installed_app_id": instance.st_installed_app_id
        })

@api_view(['GET'])
@login_required()
def getDevices(request, installed_appid):
    '''
    Get devices that associated with a smartthings app instance.
    Input: 
        - installed_appid:  (str) the id of the installed SmartThings app
    Output:
        - {"devices": [
            {
                'st_device_id': 'xxx', 
                'proj_device_id': 'xxx', 
                'name': 'xxx', 
                'is_subscribed': false},
            ...
        ]}
    '''
    try:
        stapp_instance = STAppInstance.objects.get(
            st_app__users=request.user, 
            st_installed_app_id=installed_appid
        )
    except STAppInstance.DoesNotExist:
        return JsonResponse({"msg": "Cannot find the ST app instance."}, status=404)

    try:
        # get the latest list of devices from ST (dev_instances is a list of dict)
        dev_instances = get_devices(installed_appid)
        if not isinstance(dev_instances, list):
            # if dev_instances is not a list, it means something went wrong
            # therefore just return the error message
            return dev_instances
    except Exception as e:
        ErrorLog.objects.create(err="getDevices:\n{}\n".format(type(dev_instances)))
        return JsonResponse({"error": "getDevices: get devices from st failed.\nError:\n{}".format(repr(e))}, status=500)
    dev_list = []
    try:
        for dev in dev_instances:
            if not Device.objects.filter(st_device_id = dev.get("st_device_id")).exists():
                # if the device hasn't been created
                dev_serializer = DeviceSerializer(data=dev)
                if dev_serializer.is_valid():
                    dev_instance = dev_serializer.save()
                    dev_instance.st_app_instance = stapp_instance
                    dev_instance.save()
            else:
                dev_instance = Device.objects.get(st_device_id = dev.get("st_device_id"))
                incoming_label = dev.get('label', '')
                if incoming_label != '' and dev_instance.label != incoming_label:
                    dev_instance.label = incoming_label
                    dev_instance.save()
            dev_summary = DeviceSummarySerializer(dev_instance).data
            caps_status = get_device_status(installed_appid, dev_summary["st_device_id"])
            for cap in dev_summary.get("capabilities", []):
                cap_id = cap["st_id"]
                for attr in cap.get("attributes", []):
                    attr_id = attr["name"]
                    attr["value"] = caps_status[cap_id][attr_id]["value"]
            dev_list.append(dev_summary)
        return JsonResponse({"devices": dev_list})
    except Exception as e:
        ErrorLog.objects.create(err="getDevices > deserializing devices:\n{}\n".format(repr(e)))
        return JsonResponse({"error": "Can't store devices."}, status=500)

@api_view(['POST'])
@login_required()
def updateDevicesMapping(request, installed_appid):
    '''
    Input:
        - {
            "st_installed_app_id": "xxx"
            "dev_map": [
                {"st_device_id": "xxxxx", "proj_device_id": "xxxxxx"},
                ...
        ]}
    '''
    mappings = request.data['dev_map']
    stapp_instance = STAppInstance.objects.filter(
        st_app__users=request.user, 
        st_installed_app_id=installed_appid
    )
    if len(stapp_instance) == 0:
        err_msg = "Cannot find corresponding STApp Instance. Please install the SmartThings App to the location first."
        ErrorLog.objects.create(err="updateDeviceMapping - {}".format(err_msg))
        return JsonResponse({"msg": err_msg}, status=404)

    devices_queryset = stapp_instance[0].devices
    for dev_map in mappings:
        try:
            dev = devices_queryset.get(st_device_id=dev_map.get("st_device_id"))
        except Device.DoesNotExist:
            return JsonResponse({"msg": "Cannot find the device."}, status=404)
        
        mapping_serializer = DeviceIdMappingSerializer(dev, data=dev_map)
        if mapping_serializer.is_valid(raise_exception=True):
            mapping_serializer.save()
    return JsonResponse({})

@api_view(['POST'])
@login_required()
def addSubscription(request):
    '''
    Add subscription for one specific device
    '''
    pass

@api_view(['POST'])
@login_required()
def hasSTApp(request):
    if not "client_id" in request.data or not "client_secret" in request.data:
        return JsonResponse({}, status=400)
    
    try:
        stapp = STApp.objects.get(
            client_id=request.data["client_id"], 
            client_secret=request.data["client_secret"]
        )
        stapp.users.add(request.user)
        stapp.save()
        return JsonResponse({"stapp_id": stapp.app_id}, status=200)
    except STApp.DoesNotExist:
        return JsonResponse({}, status=404)
    except Exception as e:
        ErrorLog.objects.create(err="hasSTApp: {}\n{}".format(repr(e), traceback.format_exc()))
        return JsonResponse({}, status=500)

### Class-based API Views

# Devices
# class DeviceList(generics.ListAPIView):
#     '''
#     Function:   list all the devices
#     URL:        st/devices/
#     Status:     construction
#     '''
#     queryset = Device.objects.all()
#     serializer_class = DeviceSerializer

# class DeviceDetail(generics.RetrieveUpdateAPIView):
#     '''
#     Function:   (GET) list one device by id
#                 (POST) update one specific device
#     URL:        not decided
#     Status:     construction
#     '''
#     queryset = Device.objects.all()
#     serializer_class = DeviceSerializer

# STApp
class STAppInstanceDetail(generics.RetrieveAPIView):
    '''
    Function:   retrieve STAppInstance details
    URL:        installed-apps/<installed_appid>/
    Status:     unfinished
    '''
    permission_classes = (permissions.IsAuthenticated,)
    serializer_class = STAppInstanceSerializer

    def get_object(self):
        queryset = self.get_queryset()
        stapp_instance = get_object_or_404(
            queryset,
            st_installed_app_id=self.kwargs['installed_appid']
        )
        return stapp_instance

    def get_queryset(self, installed_appid):
        return STAppInstance.objects.filter(
            st_app__users = self.request.user
        )

class STAppInstanceDetailFromLocation(generics.RetrieveAPIView):
    '''
    Function:   retrieve STAppInstance details by location and stapp
    URL:        installed-apps/app/<slug:stapp_id>/loc/<slug:st_loc_id>/
    '''
    permission_classes = (permissions.IsAuthenticated,)
    serializer_class = STAppInstanceSerializer
    multiple_lookup_fields = ('stapp_id', 'st_loc_id')

    def get_object(self):
        queryset = self.get_queryset()
        stapp_instance = get_object_or_404(
            queryset, 
            st_app__app_id=self.kwargs['stapp_id'],
            location__st_id=self.kwargs['st_loc_id']
        )
        return stapp_instance
    
    def get_queryset(self):
        return STAppInstance.objects.filter(
            st_app__users = self.request.user
        )

class STAppCreate(generics.CreateAPIView):
    '''
    Function:   create one smarthings apps
    URL:        st/apps/create
    Status:     construction
    '''
    queryset = STApp.objects.all()
    serializer_class = STAppSerializer
    
    # def get_serializer_context(self):
    #     return {'request': self.request}

class STAppList(generics.ListAPIView):
    '''
    Function:   create one smarthings apps
    URL:        st/apps/create
    Status:     construction
    '''
    queryset = STApp.objects.all()
    serializer_class = STAppSerializer

# Capabilities
class CapabilityList(generics.ListAPIView):
    '''
    Function:   list all the capabilities
    URL:        st/capabilities/
    Status:     finished
    '''
    queryset = Capability.objects.all()
    serializer_class = CapabilitySerializer

class CapabilityUpdate(APIView):
    '''
    Function:   update the capabilities based on smarthings' website
    URL:        st/capabilities/update
    Status:     finished
    '''
    permission_classes = (permissions.IsAdminUser,)
    queryset = Capability.objects.all()

    ### only add new capabilities
    ### new data
    def get(self, request, format=None):
        caps_list = get_latest_capabilities()
        # Capability.objects.all().delete()
        for cap in caps_list:
            if Capability.objects.filter(st_id=cap["st_id"]).count() == 0:
                cap_serializer = CapabilitySerializer(data=cap)
                if cap_serializer.is_valid():
                    cap_serializer.save()
                else:
                    return JsonResponse(cap_serializer.errors, status=400)
            else:
                cap_instance = Capability.objects.get(st_id=cap["st_id"])
                cap_serializer = CapabilitySerializer(cap_instance, data = cap)
                if cap_serializer.is_valid():
                    cap_serializer.save()
                else:
                    return JsonResponse(cap_serializer.errors, status=400)
        return JsonResponse({'msg':'Success'}, status=200)

class LocationList(generics.ListAPIView):

    permission_classes = (permissions.IsAuthenticated, TokenHasScope)
    serializer_class = LocationSerializer
    required_scopes = ["read"]

    def get_queryset(self):
        return Location.objects.filter(
            stappinstance__st_app__app_id=str(self.kwargs["stapp_id"]),
            stappinstance__st_app__users=self.request.user
        )
    
    def to_representation(self, instance):
        ret = super().to_representation(instance)
        try:
            stapp_instance = STAppInstance.objects.get(
                st_app__app_id=self.kwargs['stapp_id'],
                location__st_id=self.kwargs['st_loc_id']
            )
            ret["st_installed_app_id"] = stapp_instance.st_installed_app_id
        except STAppInstance.DoesNotExist:
            ret["st_installed_app_id"] = stapp_instance.st_installed_app_id
        return ret
        

class DeviceCreate(generics.CreateAPIView):
    queryset = Device.objects.all()
    serializer_class = DeviceSerializer


# class DeviceMappingUpdate(generics.UpdateAPIView):
#     permission_classes = (permissions.IsAuthenticated, TokenHasScope)
#     serializer_class = DeviceIdMappingSerializer
#     required_scopes = ["write"]
#     lookup_field = "st_app_instance__st_installed_app_id"
#     lookup_url_kwarg = "installed_appid"

#     def update(request, *args, **kwargs):
#         devices = self.get_queryset().all()
#         request_data = request.data
#         # for dev in devices:
#         #     st_dev_id = dev[""]

#     def get_object(self, st_dev_id):
#         queryset = self.get_queryset()
#         filter_kwargs = {"st_device_id": st_dev_id}
#         obj = get_object_or_404(queryset, **filter_kwargs)
#         self.check_object_permissions(self.request, obj)
#         return obj

#     def get_queryset(self):
#         return Device.objects.filter(
#             st_app_instance__st_installed_app_id=self.kwargs["installed_appid"],
#             st_app_instance__st_app__users=self.request.user
#         )

class SubscriptionViewSet(viewsets.ViewSet):
    '''
    A ViewSet for subscriptions to device
    '''
    def retrieve(self, request, installed_appid, proj_dev_id):
        '''
        Retrieve a device's subscription status
        '''
        try:
            dev = Device.objects.get(
                st_app_instance__st_installed_app_id = installed_appid,
                proj_device_id=proj_dev_id
            )
        except Device.DoesNotExist:
            ErrorLog.objects.create(
                err="SubscriptionViewSet.retrieve(): Cannot find device.\n Device id: {}".format(proj_dev_id)
            )
            return JsonResponse({}, status=status.HTTP_404_NOT_FOUND)
        
        resp = DeviceSubscriptionSerializer(dev).data

        return JsonResponse(resp)

    def create(self, request, installed_appid):
        '''
        Create a subscription for a device\n
        Request Input:
            dev_id : the id of the device in the project
        '''
        try:
            proj_dev_id = request.data.get("dev_id", "")
            dev = Device.objects.get(
                st_app_instance__st_installed_app_id = installed_appid,
                proj_device_id=proj_dev_id
            )
        except Device.DoesNotExist:
            ErrorLog.objects.create(
                err="SubscriptionViewSet.create(): Cannot find device.\n Device id: {}".format(proj_dev_id)
            )
            return JsonResponse({}, status=status.HTTP_404_NOT_FOUND)

        if dev.is_subscribed:
            return JsonResponse({}, status=status.HTTP_200_OK)

        status_code = add_subscriptions(installed_appid, [dev])
        return JsonResponse({}, status=status_code)

    
    def destroy(self, request, installed_appid, proj_dev_id):
        '''
        Delete a subscription for a device
        '''
        try:
            dev = Device.objects.get(
                st_app_instance__st_installed_app_id = installed_appid,
                proj_device_id=proj_dev_id
            )
        except Device.DoesNotExist:
            ErrorLog.objects.create(
                err="SubscriptionViewSet.destroy(): Cannot find device.\n Device id: {}".format(proj_dev_id)
            )
            return JsonResponse({}, status=status.HTTP_404_NOT_FOUND)
        
        if not dev.is_subscribed:
            return JsonResponse({}, status=status.HTTP_200_OK)
        
        status_code = delete_subscriptions(installed_appid, [dev])
        return JsonResponse({}, status=status_code)