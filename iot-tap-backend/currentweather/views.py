from django.shortcuts import render
from django.http import HttpResponse, Http404
from time import gmtime, ctime
import datetime
from currentweather.models import WeatherLog

#from currentweather.formatting import convertDatetimeToString

# Create your views here.

# These views are meant to be used with the WeatherLog objects and are
# for testing only. They will be removed soon

'''
def logspage(request):
    html = ""
    for log in WeatherLog.objects.all():
        html = html + pagedetail(log)
    return HttpResponse("<html>" + html + "</html>")

def homepage(request):
    return HttpResponse("Welcome to Current Weather demo")

def detail(request, id):
    try:
        log = WeatherLog.objects.get(pk=id)
    except WeatherLog.DoesNotExist:
        raise Http404("Log does not exist")
    return HttpResponse("<html>" + pagedetail(log) + "<h3>ID %d</h3>" % id + "</html>")

def pagedetail(log):
    title = "<h1>Weather for Lat: %d and Lon: %d</h1>" %(log.latitude, log.longitude)
    city = "<h2> City: %s</h2>" % log.cityname
    temp = "<h3>Temperature is <strong>%d degrees F</strong></h3>" % log.temp
    time = "<body><p>Sunset is at <em>%s</em> at your local time</p>" % ctime(log.sunset) 
    time_created = "<p>Recorded at %s UTC</p></body>" % convertDatetimeToString(log.created)
    return title + city + temp + time + time_created

def most_recent(request):
    log = WeatherLog.objects.latest('created')
    return detail(request, log.pk)
'''
