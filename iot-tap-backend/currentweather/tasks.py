from __future__ import absolute_import, unicode_literals
from celery import task
from currentweather.util import get_current_weather, get_current_weather_by_coords, checkCurrentWeather
from currentweather.models import WeatherLog
from backend.models import StateLog, Location, Device, LocationVirtualDevices, ErrorLog
from backend.util import vd_process_update
from django.conf import settings

# from currentweather.util import record_weather (Not fully implemented)

# These use a temporary class, WeatherLog
# Soon, this will be switched to StateLog in the backend

@task()
def record_current_weather():
    '''
    Get Current weather in specified city,
    instantiate model instance
    and save to database
    '''

    # For now, all locations are Chicago, so this is called outside the location loop
    # FUTURE: 1. switch to get_current_weather_by_coords
    #         2. put call to this function in for-loop below
    #         3. Make call with each lat, lon stored in each Location object

    # For now, weather data is stored in a WeatherLog in database. Will be refactored
    # once StateLog function works for virtual devices
    if Location.objects.all().exists():
        for loc in Location.objects.all():
            try:
                loc_vd = LocationVirtualDevices.objects.get(location=loc)
                weather_dev = loc_vd.weather_dev
            except LocationVirtualDevices.DoesNotExist as e:
                ErrorLog.objects.create(err="could not find virtual device profile for location %s" % str(loc))
                raise e
    
            dct = get_current_weather_by_coords(lat=loc.lat, lon=loc.lon)
            last_weather = checkCurrentWeather(loc)
    
            humidity = dct['main']['humidity']
            if humidity != last_weather['Relative Humidity Measurement']['humidity']:
                kwargs = {'st_installed_app_id': loc.st_installed_app_id,
                          'capid': 'Relative Humidity Measurement',
                          'deviceid': weather_dev.id,
                          'values': {'humidity': humidity}}
                vd_process_update(kwargs)
    
            temperature = dct['main']['temp']
            if temperature != last_weather['Current Temperature']['temperature']:
                kwargs = {'st_installed_app_id': loc.st_installed_app_id,
                          'capid': 'Current Temperature',
                          'deviceid': weather_dev.id,
                          'values': {'temperature': temperature}}
                vd_process_update(kwargs)
    
            weather = dct['weather'][0]['main']
            if weather != last_weather['Weather Sensor']['weather']:
                kwargs = {'st_installed_app_id': loc.st_installed_app_id,
                          'capid': 'Weather Sensor',
                          'deviceid': weather_dev.id,
                          'values': {'weather': weather}}
                vd_process_update(kwargs)
    
            w = WeatherLog.objects.create_log(dct)

