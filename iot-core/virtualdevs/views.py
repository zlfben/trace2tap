from django.shortcuts import render
from django.http import JsonResponse
from django.views.decorators.csrf import ensure_csrf_cookie

from rest_framework import permissions
from rest_framework.decorators import api_view, permission_classes, throttle_classes
from rest_framework.throttling import AnonRateThrottle

from smartthings.util import exec_proj_cmd_on_st
from virtualdevs.models import ErrorLog

# Create your views here.

@api_view(['GET'])
@permission_classes((permissions.AllowAny, ))
@ensure_csrf_cookie
def getCookie(request):
    return JsonResponse({})


@api_view(['POST'])
@permission_classes((permissions.AllowAny, ))
def commandExecute(request, installed_appid):
    '''
    Function:   receive commands from virtual devices
    URL:        not decided
    Status:     construction
    '''
    # need to be changed (if needed)
    if request.method == 'POST':
        data = request.data
        status, msg = exec_proj_cmd_on_st(installed_appid, data)
        return JsonResponse(msg, status = status)