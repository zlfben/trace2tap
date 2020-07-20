from django.urls import path
from . import views

urlpatterns = [
    path('get_cookie/', views.getCookie),
    path('installed-apps/<slug:installed_appid>/command/', views.commandExecute),
]