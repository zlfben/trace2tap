from backend import models as m
from backend import views as v

# check that there is an intersection between dev channels
# and cap channels for all dev caps
def no_hidden_caps():
    for d in m.Device.objects.all():
        for c in d.caps.all():
            x = c.channels.all().intersection(d.chans.all())
            if not x:
                return False
            else:
                print(d.name,c.name,[y.name for y in x])
    return True

# check that all users have at least one device with a readable
# cap and one device with a writeable cap
def users_can_create():
    for u in m.User.objects.all():
        userdevs = v.user_devs(u)
        if (any(map(lambda x : any(map(lambda y : y.readable,x.caps.all())),userdevs)) and
                any(map(lambda x : any(map(lambda y : y.writeable,x.caps.all())),userdevs))):
            return True
        else:
            return False


def main():
    r = {}
    r['no hidden caps'] = no_hidden_caps()
    r['users can create'] = users_can_create()
    if all(r.values()):
        print('all tests passed!')
    else:
        for val in r:
            if not r[val]:
                print(val,'failed')

    return

if __name__ == "__main__":
    main()
