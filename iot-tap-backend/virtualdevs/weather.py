#######################################################################
# NOTE: This file contains some work with the weather and pyOMW       #
#       done by Jesse! Retired for now but may be incorporated into   #
#       the current weather module                                    #
#######################################################################



import os,sys

sys.path.insert(1, os.path.abspath(os.path.join(sys.path[0], '..')))

from backend import models as m

import pyowm
from pyowm.exceptions.api_response_error import NotFoundError
import operator as op
import time

owm = pyowm.OWM('dfb30179d06cc549111a9b520870afae')

def get_comparator(string):
    if string == 'gt':
        return op.gt
    elif string == 'lt':
        return op.lt
    elif string == 'eq':
        return op.eq
    elif string == 'neq':
        return op.neq

def map_request(args,mode='is_it_raining'):
    try:
        loc = args['loc']
        obs = owm.weather_at_place(loc)
    except NotFoundError:
        return None

    if mode == 'is_it_raining':
        return is_it_raining(obs)
    elif mode == 'match_weather':
        return match_weather(obs,args['weather'])
    elif mode == 'comp_temp':
        return comp_temp(obs,args['temp'],get_comparator(args['comp']))
    else:
        return None

def is_it_raining(loc):
    obs = owm.weather_at_place(loc)
    w = obs.get_weather()
    if w.get_rain():
        return True
    else:
        return False

def match_weather(obs,weather):
    w = obs.get_weather()
    status = w.get_status().lower()
    if status in ['rain','heavy rain']:
        return (weather == 'rain')
    elif status in ['haze','clouds','partly cloudy']:
        return (weather == 'cloudy')
    else:
        return (status == weather)

def comp_temp(obs,temp,comp):
    w = obs.get_weather()
    t = w.get_temperature(unit='fahrenheit')
    temp2 = t['temp']
    return comp(temp2,temp)

### "GET" FUNCTIONS ###

def get_rain(obs):
    return obs.get_weather().get_rain()

def get_status(obs):
    return obs.get_weather().get_status()

def get_temp(obs):
    return obs.get_weather().get_temperature(unit='fahrenheit')['temp']

### VDEV MANAGEMENT ###

def init_vdev():
    deviceid = m.Device.objects.get(name='VD_Weather').id
    triggers = m.Trigger.objects.filter(dev_id=deviceid)
    locs = set([])
    for t in triggers:
        #par = m.Parameter.objects.get(trigger=t,name='location')
        tlocs = set([cond.val for cond in m.Condition.objects.filter(trigger=t) if cond.par.name == 'location'])
        locs = locs | tlocs

    return locs

def run_vdev():
    locs = init_vdev()
    print('Tracking weather at:',locs)

    states = {}
    for loc in locs:
        obs = owm.weather_at_place(loc)
        states[loc] = [get_rain(obs),get_status(obs),get_temp(obs)]
        print('Current state at %s:' % loc,states[loc])

    while True:
        for loc in locs:
            change = False

            obs = owm.weather_at_place(loc)
            rain = get_rain(obs)
            if states[loc][0] != rain:
                change = True
                print('rain at %s is now %s' % (loc,rain))
                states[loc][0] = rain

            status = get_status(obs)
            if states[loc][1] != status:
                change = True
                print('status at %s is now %s' % (loc,status))
                states[loc][1] = status

            temp = get_temp(obs)
            if states[loc][2] != temp:
                change = True
                print('status at %s is now %s' % (loc,temp))

            if not change:
                print('no change in %s' % loc)

        time.sleep(60)

def main():
    run_vdev()

if __name__ == '__main__':
    main()
