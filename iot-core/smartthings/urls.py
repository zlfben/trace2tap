from django.urls import path
from . import views, st_views

urlpatterns = [
    # path('apps/<stapp_id>/instances/', views.STAppInstanceList.as_view()),
    path('apps/', views.STAppList.as_view()),
    path('apps/create', views.STAppCreate.as_view(), name = 'stapp_create'),
    path('apps/exists/', views.hasSTApp),
    path('apps/<slug:stapp_id>/locations/', views.LocationList.as_view()),
    path('installed-apps/<slug:installed_appid>/', views.STAppInstanceDetail.as_view()),
    path('installed-apps/app/<slug:stapp_id>/loc/<slug:st_loc_id>/', views.STAppInstanceDetailFromLocation.as_view()),
    path('installed-apps/<slug:installed_appid>/devices/', views.getDevices),
    path('installed-apps/<slug:installed_appid>/devices/update/', views.updateDevicesMapping),
    path(
        'installed-apps/<slug:installed_appid>/devices/<int:proj_dev_id>/subscription/', 
        views.SubscriptionViewSet.as_view({'get': 'retrieve', 'delete': 'destroy'})
    ),
    path('installed-apps/<slug:installed_appid>/subscription/', views.SubscriptionViewSet.as_view({'post': 'create'})),
    path('installed-apps/<slug:installed_appid>/command/', views.commandExecute),
    path('capabilities/', views.CapabilityList.as_view()),
    path('capabilities/update', views.CapabilityUpdate.as_view()),
    # path('devices/', views.DeviceList.as_view()),
    path('apps/<slug:proj>/callback/', st_views.callback, name= 'stapp_callback'),
    path('user/register/', views.userRegister),
    path('get_cookie/', views.getCookie),
    path('test/', views.DeviceCreate.as_view())
]
