from . import views as v

# {reqname : func}
reqmap = {
        'get_chans' : v.fe_all_chans,
        'get_devs_and_chans' : v.fe_all_devs_and_chans,
        'get_devs_with_chan' : v.fe_devs_with_chan,
        'get_chans_with_dev' : v.fe_chans_with_dev,
        'get_caps' : v.fe_get_valid_caps,
        'get_params' : v.fe_get_params,
        'make_esrule' : v.fe_create_esrule,
        'view_device_status' : v.fe_current_device_status,
        'view_device_history' : v.fe_device_history
        }

def urlmap(request,**kwargs):
    f = reqmap[kwargs['reqname']]
    return f(request,kwargs)
