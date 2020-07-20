from django.db import models
from django.conf import settings
from django.db.models.signals import post_save
from django.dispatch import receiver
from django.contrib.auth.models import User
from django.contrib.contenttypes.fields import GenericForeignKey
from django.contrib.contenttypes.models import ContentType
from django.contrib.contenttypes.fields import GenericRelation

from rest_framework.authtoken.models import Token
from oauth2_provider.models import Application

import json
from datetime import timedelta, datetime

### For TokenAuthentication
# @receiver(post_save, sender=settings.AUTH_USER_MODEL)
# def create_auth_token(sender, instance=None, created=False, **kwargs):
#     if created:
#         Token.objects.create(user=instance)

### Real models
'''
Contents:
    - Project
    - UserProfile
    - Location
    - Capabilities-related
        - Capability
        - Attribute
        - Command
        - Argument
    - Devices-related
        - DeviceManager
        - Device
    - STApps-related
        - STAppPermission
        - STApp
        - STAppInstance
'''

### Project
# class Project(models.Model):
#     """
#     Info about an IoT Project. Used to support multiple projects.
#     Currently (May 1, 2019) needs to be created manually
#     Input:
#         - name: the name of the project
#     """
#     name = models.CharField(max_length = 128)

#     def __str__(self):
#         return self.name

### User-related
# class UserProfile(models.Model):
#     """
#     To specify which project this user belong. 
#     Currently (May 1, 2019), one user can only be used for one project. 
#     Input:
#         - user: the instance is associated with one user
#         - proj: the project that this instance is in
#     """
#     user = models.OneToOneField(User, on_delete=models.CASCADE)
#     proj = models.ManyToManyField(Application)

#     def __str__(self):
#         return self.user.username

### Location
class Location(models.Model):
    st_id = models.CharField(max_length = 36)
    name = models.CharField(max_length = 128)
    latitude = models.FloatField(null=True, blank=True, default=None)
    longitude = models.FloatField(null=True, blank=True, default=None)

    def __str__(self):
        return self.name


### Capabilities-related

class Capability(models.Model):
    """
    Info about Capability
    Input:
        name:   string, the readable name of the capability
        st_id:  string, the unique name of the capability
    """
    name = models.CharField(max_length = 128, default = "")     # e.g. Acceleration Sensor
    st_id = models.CharField(max_length = 128, default = "", unique=True)    # e.g. accelerationSensor

    def __str__(self):
        return "%s (%s)" % (self.name, self.st_id) # just for clarity

class Attribute(models.Model):
    """
    Attribute - Attribute belongs to a capability.
    Input:
        capability: foreign key, an instance of Capability
        name:       string, the name of the attribute
        value:     string,  a serialized json object
    """
    capability = models.ForeignKey(Capability, on_delete=models.CASCADE)
    name = models.CharField(max_length = 128)
    data_type = models.CharField(max_length = 64, null=True)
    required = models.BooleanField(default=True)
    value = models.TextField(default = None, null = True)

    def __str__(self):
        return self.name

class Command(models.Model):
    """
    """
    capability = models.ForeignKey(Capability, on_delete=models.CASCADE)
    name = models.CharField(max_length = 128)

    def __str__(self):
        return "%s (%s)" % (self.name, self.capability.name)

class Argument(models.Model):
    """
    """
    command = models.ForeignKey(Command, on_delete=models.CASCADE)
    name = models.CharField(max_length = 128)
    data_type = models.CharField(max_length = 64, null=True)
    required = models.BooleanField(default=True)

    def __str__(self):
        return "%s (%s)" % (self.name, self.command)



### STApps-related

class STAppPermission(models.Model):
    '''
    A table of permissions that a smartthings app that can have access to.
    NOTE: This list should be read-only unless ST updates its permission list.
    Input:
        scope:  the name of the permission scope
    '''
    scope = models.CharField(max_length = 36, unique = True)

    def __unicode__(self):
        return '%s' % (self.scope)

    def __str__(self):
        return self.scope

class STApp(models.Model):
    '''
    Smartthings apps that we created for one specific person
    Input:
        name:           string, the readable name of the STApp
        app_id:         string, the unique name of the STApp
        description:    text, the description of the STApp
        permissions:    list, the list of permissions that the STApp required
    '''
    # owner = models.ForeignKey(User, on_delete=models.CASCADE, null=True, default=None)
    users = models.ManyToManyField(User)
    name = models.CharField(max_length = 128, default = "")
    app_id = models.CharField(max_length = 128, default = "", unique = True)
    prod_endpoint = models.URLField(default = settings.GLOBAL_SETTINGS["PROD_ENDPOINT"], blank=True, null=True)
    debug_endpoint = models.URLField(default = None, blank=True, null=True)
    docker_endpoint = models.CharField(max_length = 256, default = "", blank=True, null=True)
    description = models.TextField(default = "", blank=True)
    permissions = models.ManyToManyField(STAppPermission, related_name = 'permissions')
    client_id = models.CharField(max_length = 36, unique = True, default=None, null=True)
    client_secret = models.CharField(max_length = 36, unique = True, default=None, null=True)

    def __str__(self):
        return self.name

class STAppConfPage(models.Model):
    '''
    Configuration pages for an STApp.
    Input:
        page_id:
        complete:
    '''
    st_app = models.ForeignKey(STApp, on_delete=models.CASCADE, related_name = 'pages')
    pageId = models.CharField(max_length = 64)
    name = models.CharField(max_length = 128)
    nextPageId = models.CharField(max_length = 64, default=None, blank=True, null=True)
    previousPageId = models.CharField(max_length = 64, default=None, blank=True, null=True)
    complete = models.BooleanField()

    def __str__(self):
        return self.name

class STAppConfSection(models.Model):
    '''
    The sections in a configuration page for an STApp.
    Input:
        page:   the page that this section belongs to
        name:   the text that shows up at the beginning of a section
    '''

    page = models.ForeignKey(STAppConfPage, 
                             on_delete = models.CASCADE,
                             related_name = 'sections')
    st_app_id = models.CharField(max_length = 128, blank=True, null=True)
    name = models.TextField(default = "")

    def save(self, *args, **kwargs):
        if (not self.page is None) and (not self.st_app_id):
            # when page is set but not st_app_id
            self.st_app_id = self.page.st_app.app_id

        super(STAppConfSection, self).save(*args, **kwargs)

    def __str__(self):
        return self.name

class STAppConfSectionDeviceSetting(models.Model):
    '''
    The settings in a configuration section for an STApp.
    Input:
        section:
        setting_id:
        name:
        description:
        setting_type:
        required:
        multiple:
        capabilities:
        permissions:
    '''
    section = models.ForeignKey(STAppConfSection, 
                                on_delete = models.CASCADE, 
                                related_name = 'device_settings')
    st_app_id = models.CharField(max_length = 128, blank=True, null=True)
    setting_id = models.CharField(max_length = 36, default=None)
    name = models.TextField(default = "")
    description = models.TextField(default = "")
    setting_type = models.CharField(max_length = 36, default="DEVICE")
    required = models.BooleanField(default = True)
    multiple = models.BooleanField(default = False)
    capabilities = models.ManyToManyField(Capability)
    permissions = models.ManyToManyField(STAppPermission)
    

    def save(self, *args, **kwargs):
        if (not self.section is None) and (not self.st_app_id):
            # when section is set but not st_app_id
            self.st_app_id = self.section.st_app_id

        super(STAppConfSectionDeviceSetting, self).save(*args, **kwargs)

    def __str__(self):
        return self.name

class STAppConfSectionParagraphSetting(models.Model):
    '''
    The settings in a configuration section for an STApp.
    Input:
        section:
        setting_id:
        name:
        description:
        setting_type:
        default_value:
    '''
    # @TODO: related_name need to be changed, need to support more types of settings
    section = models.ForeignKey(STAppConfSection, 
                                on_delete = models.CASCADE, 
                                related_name = 'paragraph_settings')
    st_app_id = models.CharField(max_length = 128, blank=True, null=True)
    setting_id = models.CharField(max_length = 36, default=None)
    name = models.TextField(default = "")
    description = models.TextField(default = "")
    setting_type = models.CharField(max_length = 36, default="PARAGRAPH")
    default_value = models.TextField(default = "")
    
    def save(self, *args, **kwargs):
        if (not self.section is None) and (not self.st_app_id):
            # when section is set but not st_app_id
            self.st_app_id = self.section.st_app_id

        super(STAppConfSectionParagraphSetting, self).save(*args, **kwargs)

    def __str__(self):
        return self.name

class STAppInstance(models.Model):
    '''
    Installed instances of a smartthings app (i.e. stapp installed to a location)
    Input:
        st_app:                 model, which STApp this instance is
        st_installed_app_id:    string, the id issued by ST for an installed app instance
        location:               model, where the instance is installed to
        refresh_token:          string, the token that used to get access token
    '''
    st_app = models.ForeignKey(STApp, on_delete=models.CASCADE)
    st_installed_app_id = models.CharField(max_length = 36, unique=True)
    location = models.ForeignKey(Location, on_delete=models.CASCADE, default=None, blank=True, null=True)
    access_token = models.CharField(max_length = 40, null=True, default=None)
    access_token_expired_at = models.DateTimeField(default=None, blank=True, null=True)
    refresh_token = models.CharField(max_length = 40, null=True, default=None)

    def __str__(self):
        return self.st_app.name


class STAppInstanceSetting(models.Model):
    '''
    The mapping of one STApp instance's settings and corresponding real devices.
    Each instance setting should have its own device.
    A real device can be used by multiple instances.
    setting:            The setting that belongs to this STApp instance (i.e. required device).
    device:             The real device that is represented by this setting.
    st_app_instance:    The related STApp instance. Each instance has its own mappings.
    '''

    # generic foreign key, so that setting can be any kind of setting
    # src: https://docs.djangoproject.com/en/2.2/ref/contrib/contenttypes/#generic-relations
    content_type = models.ForeignKey(ContentType, on_delete=models.CASCADE, default=None, null=True)
    object_id = models.PositiveIntegerField(default=None, null=True)
    setting = GenericForeignKey('content_type', 'object_id')
    # setting = models.ForeignKey(STAppConfSectionDeviceSetting, 
    #                             on_delete=models.CASCADE)
    # device = models.ForeignKey(Device, 
    #                            on_delete=models.SET_NULL,
    #                            blank=True,
    #                            null=True)
    st_app_instance = models.ForeignKey(STAppInstance, 
                                        on_delete=models.CASCADE,
                                        related_name = 'instance_settings')

    # def __str__(self):
    #     return "{} ({})".format(self.content_type.name, self.st_app_instance.st_app.name)

class Device(models.Model):
    """
    Info about an independent device\n
    NOTE: One actual device can have multiple instance of Device here, \n
    if they are used in multiple projects\n
    Fields
        name:           the name of the device
        st_device_id:   the device id in SmartThings
        proj_device_id: the device id in the project
        component_id:   the component id in SmartThings
        capabilities:   the capabilities that the device has
        st_app_instance_setting:    the setting in STApp instance that the device belongs
        st_app_instance:    
        is_subscribed:  (bool) whether the device is subscribed by the STApp Instance
        subscription:   the subscription id of the device if it is subscribed
    """
    # @TODO: need to maintain the state of devices
    # setting = models.OneToOneField(STAppConfSectionSetting, on_delete=models.CASCADE, default=None)
    name = models.CharField(max_length=128, default="", blank=True)
    label = models.CharField(max_length=256, default="", blank=True)
    st_device_id = models.CharField(max_length = 36)
    proj_device_id = models.IntegerField(default=-1)
    component_id = models.CharField(max_length = 36, default="main")
    # owner = models.ManyToManyField(settings.AUTH_USER_MODEL)
    capabilities = models.ManyToManyField(Capability)
    # objects = DeviceManager()
    st_app_instance_setting = models.ForeignKey(STAppInstanceSetting,
                                                on_delete=models.CASCADE,
                                                blank=True,
                                                null=True,
                                                default=None)
    st_app_instance = models.ForeignKey(STAppInstance, 
                                        related_name="devices",
                                        on_delete=models.CASCADE, 
                                        blank=True,
                                        null=True,
                                        default=None)
    is_subscribed = models.BooleanField(default=False)
    subscription = models.SlugField(max_length=36, default="", blank=True)

    def __str__(self):
        return "{} ({}, {})".format(self.name, self.st_device_id, self.proj_device_id)

class ErrorLog(models.Model):
    '''
    Logging the exceptions
        err : the error message
    '''
    err = models.TextField(default="", blank=True, null=True)
