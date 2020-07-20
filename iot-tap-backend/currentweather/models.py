from django.db import models
from datetime import datetime, timedelta
from django.utils import timezone

# This class is for testing purposes
# Create your models here.
# Call using WeatherLog.objects.create_log(dict)

class WeatherLogManager(models.Manager):
    def create_log(self, dict):
        '''
        Given weather info in dictionary,
        instantiate model instance and
        save to database.
        NOTE: Assumes dictionary has been converted the from
        JSON format returned by Open Weather API
        '''
        instance = self.create(
            cityname = dict['name'],
            latitude = dict['coord']['lat'],
            longitude = dict['coord']['lon'],
            temp = dict['main']['temp'],
            humidity = dict['main']['humidity'],
            condition = dict['weather'][0]['main'],
            cond_code = dict['weather'][0]['id'],
            long_desc = dict['weather'][0]['description'],
            # Not needed at this time -- could support in future:
            # sunrise = dict['sys']['sunrise'] + dict['timezone'],
            # sunset = dict['sys']['sunset'] + dict['timezone'],
            )
        
        return instance

# This class is for testing purposes
# Relevant info will soon be moved to StateLog
class WeatherLog(models.Model):
    '''
    Conditions and codes as per 
    https://openweathermap.org/weather-conditions
    Thunderstorm - 2xx     Drizzle - 3xx    Rain - 5xx
    Snow - 6xx             Mist - 701       Fog  - 741 
    Tornado - 781          Clear - 800      Clouds - 80x

    + a few other rare ones (7xx's)
    Check long_desc for more detail
    '''
    created = models.DateTimeField(auto_now_add=True)
    cityname = models.CharField(max_length=50, default='unlisted')
    latitude = models.IntegerField()
    longitude = models.IntegerField()
    temp = models.IntegerField()    # in F
    humidity = models.IntegerField(null=True)    # in %
    condition = models.CharField(max_length=50, default='no condition listed')
    cond_code = models.IntegerField()
    long_desc = models.CharField(max_length=80, default='no long description given')
    sunrise = models.IntegerField(null=True) # in unix, UTC time
    sunset = models.IntegerField(null=True) # in unix, UTC time
    
    objects = WeatherLogManager()

    class Meta:
        ordering = ('created',)
             
    def __str__(self):
        return self.cityname + " on " + str(self.created)
        
    # Currently counting things like Thunderstorms and Mists as rain
    def is_raining(self):
        return 200 <= self.cond_code <= 701
        
    def is_snowing(self):
        return self.condition == 'Snow'
