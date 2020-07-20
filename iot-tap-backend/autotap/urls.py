from django.urls import path

from . import views

urlpatterns = [
    path('', views.test, name='test'),
    path('fix/', views.fix, name='fix'),
    path('reproduce/', views.reproduce, name='reproduce'),
    path('synthesize/', views.synthesize, name='synthesize'),
    path('multisp/', views.multisp, name='multisp'),
    path('debug/', views.debug, name='debug'),
    path('suggestadd/', views.suggestadd, name='suggestadd'),
    path('suggestdebug/', views.suggestdebug, name='suggestdebug'),
    path('getepisode/', views.getepisode, name='getepisode'),
    path('getepisodedebug/', views.getepisode_debug, name='getepisodedebug'),
    path('revert/loc/', views.get_revert_for_location, name="getrevertforloc"),
    path('revert/action/', views.get_revert_action, name="getrevertaction"),
    path('manual/', views.get_manual_changes, name="getmanualchange"),
    path('debugpage/', views.get_debug_pages, name="getdebugpages")
    # path('getcache/', views.getcache, name='getcache')
    # path('trace/', views.trace, name='trace'),
    # path('revert/', views.revert, name='revert'),
    # path('gettrace/', views.gettrace, name='gettrace')
]
