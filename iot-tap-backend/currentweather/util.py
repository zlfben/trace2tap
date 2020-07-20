from currentweather.models import WeatherLog
from backend.models import StateLog, LocationVirtualDevices, State, ParVal, Parameter
import urllib3, json

# This key is for testing ONLY since it is not secret
# It can be called up to 60 times/min
# @TODO: make API key a secret (will replace with a newly generated one)

# See tasks.py for functions to make periodic calls to get weather + store to database
API_KEY = "deaa29e9003cbdee9c7e92b3e9e0a443"

WEATHER_LINK = "http://api.openweathermap.org/data/2.5/weather?"
UNITS = "&units=imperial"
URL_ENDING = UNITS + "&APPID=" + API_KEY

# ----------------------- Various calls to get Weather -------------------------------
def get_current_weather(city):
    '''
    Get current weather in specified city from weather API,
    (currently using OpenWeatherAPI) and return it,
    but do not save the info anywhere
    '''
    link = WEATHER_LINK + "q=" +  city + URL_ENDING
    dict = fetch_weather_by_link(link)
    return dict

def get_current_weather_by_coords(lat, lon):
    '''
    Get current weather by latitude and longitude
    And return it, but do not save info anywhere
    '''
    link = WEATHER_LINK + "lat=" + str(lat) + "&lon=" + str(lon) + URL_ENDING
    dict = fetch_weather_by_link(link)
    return dict

def get_current_weather_by_zip(zip):
    '''
    Get current weather by zip code
    and return it, but do not save info anywhere
    '''
    link = WEATHER_LINK + "zip=" + str(zip) + URL_ENDING
    dict = fetch_weather_by_link(link)
    return dict

# @TODO: Add try-except in case GET fails
def fetch_weather_by_link(link):
    '''
    Given complete link by one of the functions above, 
    fetch the weather and return in dictionary format
    '''
    http = urllib3.PoolManager()
    resp = http.request('GET', link)
    # resp.data holds JSON response
    dict = json.loads(resp.data.decode('utf-8'))

    print(dict)
    return dict
# -----------------------------------------------------------------------------------

def record_weather(dict, dev):
    pass
'''
    not supported yet:
    Will replace create_log in WeatherLogManager if WeatherLog support is removed
    Input:
    - dictionary created by fetch_weather_by_link
    - virtual Weather device for particular location

    Conditions and codes as per
    https://openweathermap.org/weather-conditions
    Thunderstorm - 2xx     Drizzle - 3xx    Rain - 5xx
    Snow - 6xx             Mist - 701       Fog  - 741
    Tornado - 781          Clear - 800      Clouds - 80x
    + a few other rare ones (7xxs)
    
    cityname = dict['name']    # probably not needed
    latitude = dict['coord']['lat'],
    longitude = dict['coord']['lon'],
    temp = dict['main']['temp'],
    humidity = dict['main']['humidity'],
    condition = dict['weather'][0]['main'],
    cond_code = dict['weather'][0]['id'],
    long_desc = dict['weather'][0]['description'],
    
    if(200 <= cond_code <= 701):
        is_raining = True
    else:
        is_raining = False
    
    # Not needed at this time -- could support in future:
    # sunrise = dict['sys']['sunrise'] + dict['timezone'],     
    # sunset = dict['sys']['sunset'] + dict['timezone'],
    
    for cap in (capabilities):
    vd_update_log(...)
'''

def checkCurrentWeather(loc):
    try:
        loc_vd = LocationVirtualDevices.objects.get(location=loc)
        weather_dev = loc_vd.weather_dev
    except LocationVirtualDevices.DoesNotExist as e:
        ErrorLog.objects.create(err="could not find virtual device profile for location %s" % str(loc))
        raise e
    
    result_dict = dict()

    for cap in weather_dev.caps.all():
        cap_dict = dict()
        try:
            state = State.objects.get(cap=cap, dev=weather_dev)
            for parval in ParVal.objects.filter(state=state):
                param = parval.par
                value = parval.val
                cap_dict[param.name] = value

        except State.DoesNotExist:
            # first weather update hasn't arrived
            for param in Parameter.objects.filter(cap=cap):
                cap_dict[param.name] = None
        result_dict[cap.name] = cap_dict

    return result_dict
