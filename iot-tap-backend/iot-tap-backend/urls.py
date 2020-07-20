"""backend URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from django.conf import settings

if settings.CSRF_ENABLE:
    import backend.views as v
else:
    import backend.views_no_csrf as v


urlpatterns = [
    path('backend/admin/',admin.site.urls),
    path('backend/user/register/', v.um_register),
    path('backend/user/login/', v.um_login),
    path('backend/user/logout/', v.um_logout),
    path('backend/user/get_name/', v.um_get_name),
    path('backend/user/check_name/', v.um_check_username),
    path('backend/user/get/',v.fe_get_user),
    path('backend/user/loc/<int:loc_id>/rules/',v.fe_all_rules),
    path('backend/user/chans/',v.fe_all_chans),
    path('backend/user/chans/devs/',v.fe_devs_with_chan),
    path('backend/user/chans/devs/caps/',v.fe_get_valid_caps),
    path('backend/user/chans/devs/caps/params/',v.fe_get_params),
    path('backend/user/loc/devs/', v.fe_devs_with_loc),
    path('backend/user/loc/devs/caps/', v.fe_get_valid_caps_with_loc),
    path('backend/user/rules/new/',v.fe_create_esrule),
    path('backend/user/rules/newbatch/', v.fe_create_esrules),
    path('backend/user/rules/changebatch/', v.fe_change_esrules),
    path('backend/user/rules/delete/',v.fe_delete_rule),
    path('backend/user/rules/get/',v.fe_get_full_rule),
    path('backend/user/sps/',v.fe_all_sps),
    path('backend/user/sp1/new/',v.fe_create_sp1),
    path('backend/user/sp2/new/',v.fe_create_sp2),
    path('backend/user/sp3/new/',v.fe_create_sp3),
    path('backend/user/sps/delete/',v.fe_delete_sp),
    path('backend/user/sps/get/',v.fe_get_full_sp),
    path('backend/user/sp1/get/',v.fe_get_full_sp1),
    path('backend/user/sp2/get/',v.fe_get_full_sp2),
    path('backend/user/sp3/get/',v.fe_get_full_sp3),
    path('backend/user/get_cookie/', v.fe_get_cookie),
    path('backend/autotap/', include('autotap.urls')),
    path('st/update/', v.dm_manage),
    path('backend/st/devices/add/', v.dm_create_device),
    path('backend/st/installed_apps/', v.stm_get_installed_apps),
    path('backend/st/installed_apps/register/', v.stm_register_app),
    path('backend/st/device/subscrib/', v.dm_add_subscription),
    path('backend/st/installed_apps/command/', v.dm_execute_command),
    # path('st/oauth2/callback/', v.stm_oauth2_token, name='oauth_callback'),
    path('backend/user/devices/', v.dm_get_devices),
    path('backend/user/locations/', v.lm_get_locs),
    path('backend/celeryupdate/', v.celery_force_update) # Bo Wang. for debugging celery.
    ]
'''
    #path('user/new/<str:username>/<str:pass>/',views.new_user),
    path('ch<int:channelid>/devices/',views.devs_with_chan),
    path('dev<int:deviceid>/channels/',views.chans_with_dev),
    #path('user/login/<str:username>/<str:pass>/',views.try_login),
    path('rule/<str:temp>/<int:ruleid>/',views.view_rule),
    #path('rule/new/<str:temp>/<str:field1>/<str:field2>/',views.create_rule),
    path('rule/<str:temp>/<int:field2>/<str:triggerids>/<int:actionid>/',views.create_rule),
    path('dev<int:deviceid>/ch<int:channelid>/',views.get_all_caps),
    path('ch<int:channelid>/dev<int:deviceid>/',views.get_all_caps),
    path('dev<int:deviceid>/cap<int:capid>/<str:value>/log/',views.update_state),
    path('dev<int:deviceid>/status/',views.current_device_status),
    path('dev<int:deviceid>/history/',views.device_history),
    path('dev<int:deviceid>/history/<int:timedelta>/',views.historical_device_status),
    path('rule/es/<int:triggerid>/triggers/',views.es_rules_triggered),
    path('update/<int:capid>/<int:deviceid>/<int:paramid>/<str:value>/',views.process_st_update)
]
'''
