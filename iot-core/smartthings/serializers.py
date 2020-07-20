from django.contrib.auth.models import User
from django.db import IntegrityError
from django.http import JsonResponse

from rest_framework import serializers
from rest_framework.validators import UniqueValidator

from smartthings.util import cap_id_to_name

from .models import *
import json, traceback

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('username')

class LocationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Location
        fields = ('st_id', 'name', 'latitude', 'longitude')
    
    # def to_representation(self, instance):
    #     ret = super().to_representation(instance)
    #     return {"locations": ret}

class ArgumentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Argument
        fields = ('name', 'data_type', 'required')

class CommandSerializer(serializers.ModelSerializer):
    arguments = ArgumentSerializer(many = True, required = False, source = 'argument_set')

    class Meta:
        model = Command
        fields = ('name', 'arguments')

    def create(self, validated_data):
        args_data = validated_data.pop("argument_set")
        comm = Command.objects.create(**validated_data)
        for arg_data in args_data:
            Argument.objects.create(command=comm, **arg_data)
        return comm

class AttributeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Attribute
        fields = ('name', 'data_type', 'required', 'value')

class CapabilitySerializer(serializers.ModelSerializer):
    attributes = AttributeSerializer(many = True, required = False, source = 'attribute_set')
    commands = CommandSerializer(many = True, required = False, source = 'command_set')

    class Meta:
        model = Capability
        fields = ('name', "st_id", 'attributes', 'commands')

    def create(self, validated_data):
        attrs_data = validated_data.pop('attribute_set')
        comms_data = validated_data.pop('command_set')
        cap = Capability.objects.create(**validated_data)
        if len(attrs_data) != 0:
            for attr_data in attrs_data:
                Attribute.objects.create(capability=cap, **attr_data)
        if len(comms_data) != 0:
            for comm_data in comms_data:
                args_data = comm_data.pop('argument_set')
                comm = Command.objects.create(capability=cap, **comm_data)
                if len(args_data) != 0:
                    for arg_data in args_data:
                        Argument.objects.create(command=comm, **arg_data)
        return cap

    def update(self, instance, validated_data):
        attrs_data = validated_data.pop('attribute_set')
        comms_data = validated_data.pop('command_set')

        instance.name = validated_data.get('name', instance.name)
        instance.st_id = validated_data.get('st_id', instance.st_id)
        instance.save()
        
        if len(attrs_data) != 0:
            for attr_data in attrs_data:
                try:
                    attr = instance.attribute_set.get(name=attr_data['name'])
                    attr.data_type = attr_data.get('data_type', attr.data_type)
                    attr.required = attr_data.get('required', attr.required)
                    attr.value = attr_data.get('value', attr.value)
                    attr.save()
                except Attribute.DoesNotExist:
                    Attribute.objects.create(capability=instance, **attr_data)

        if len(comms_data) != 0:
            for comm_data in comms_data:
                args_data = comm_data.pop('argument_set')
                comm, comm_created = Command.objects.get_or_create(capability=instance, name=comm_data['name'])
                if len(args_data) != 0:
                    for arg_data in args_data:
                        if comm_created:
                            Argument.objects.create(command=comm, **arg_data)
                        else:
                            try:
                                arg = comm.argument_set.get(name=arg_data['name'])
                                arg.data_type = arg_data.get('data_type', arg.data_type)
                                arg.required = arg_data.get('required', arg.required)
                                arg.save()
                            except Argument.DoesNotExist:
                                Argument.objects.create(command=comm, **arg_data)

        return instance

class CapabilityRelatedField(serializers.RelatedField):
    queryset = Capability.objects.all()

    def to_representation(self, value):
        return '%s' % (value.st_id)

    def to_internal_value(self, data):
        try:
            return Capability.objects.get(st_id=data)
        except Capability.DoesNotExist:
            raise serializers.ValidationError('Capability does not exist.')

# src: https://stackoverflow.com/a/28011896
class CapabilityCreatableSlugRelatedField(serializers.SlugRelatedField):
    def to_internal_value(self, data):
        if not isinstance(data, str):
            self.fail('invalid data')
        try:
            cap = self.get_queryset().get_or_create(
                st_id = data,
                name = cap_id_to_name(data)
            )[0]
            return cap
        except Capability.MultipleObjectsReturned:
            self.fail('unique constrain violated')

class DeviceSerializer(serializers.ModelSerializer):
    capabilities = CapabilityCreatableSlugRelatedField(
        many=True, 
        queryset=Capability.objects.all(), 
        slug_field="st_id"
    )
    component_id = serializers.CharField(required=False)
    proj_device_id = serializers.CharField(required=False)

    class Meta:
        model = Device
        fields = ('st_device_id', 'proj_device_id', 'name', 'label', 'component_id', 'capabilities')
    
    def create(self, validated_data):
        try:
            capabilities = validated_data.pop('capabilities')
        except Exception as e:
            err_msg = "{}: {}\n{}\nData: {}".format(
                "DeviceSerializer-create",
                repr(e),
                traceback.format_exc(),
                str(validated_data)
            )
            ErrorLog.objects.create(err=err_msg)
            raise e
        device = Device.objects.create(**validated_data)
        try:
            for cap in capabilities:
                device.capabilities.add(cap)
        except Exception as e:
            ErrorLog.objects.create(err="DeviceSerializer: failed to add capabilities - {}".format(cap))
        device.save()
        return device

class DeviceSummarySerializer(serializers.ModelSerializer):
    capabilities = CapabilitySerializer(many=True)

    class Meta:
        model = Device
        fields = ('st_device_id', 'proj_device_id', 'name', 'label', 'is_subscribed', 'capabilities')

class DeviceIdMappingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Device
        fields = ('st_device_id', 'proj_device_id')
        read_only_fields = ('st_device_id',)

    def create(self, validated_data):
        # not allowed to create device from here
        return None
    
    def update(self, instance, validated_data):
        instance.proj_device_id = validated_data.get('proj_device_id', instance.proj_device_id)
        instance.save()
        return instance

class DeviceSubscriptionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Device
        fields = ('proj_device_id', 'is_subscribed', 'subscription')

class STAppInstanceSerializer(serializers.ModelSerializer):
    # @TODO: find a better way to decide when to send back refresh token
    st_location_id = serializers.SlugRelatedField(source="location", read_only=True, slug_field="st_id")
    class Meta:
        model = STAppInstance
        fields = ('st_installed_app_id', 'st_location_id')

class STAppPermissionSerializer(serializers.ModelSerializer):
    class Meta:
        model = STAppPermission
        fields = ('scope',)
        read_only_fields = ('scope',)

class STAppPermissionRelatedField(serializers.RelatedField):
    queryset = STAppPermission.objects.all()

    def to_representation(self, value):
        return '%s' % (value.scope)

    def to_internal_value(self, data):
        try:
            return STAppPermission.objects.get(scope=data)
        except STAppPermission.DoesNotExist:
            raise serializers.ValidationError('Permission does not exist.')


class STAppConfSectionDeviceSettingSerializer(serializers.ModelSerializer):
    id = serializers.CharField(source = "setting_id")
    permissions = STAppPermissionRelatedField(many = True)
    capabilities = CapabilityRelatedField(many = True)
    type = serializers.CharField(source = "setting_type")

    class Meta:
        model = STAppConfSectionDeviceSetting
        fields = ('id', 'name', 'description', 'type', 'required', 'multiple', 
                  'capabilities', 'permissions')

class STAppConfSectionParagraphSettingSerializer(serializers.ModelSerializer):
    id = serializers.CharField(source = "setting_id")
    type = serializers.CharField(source = "setting_type")
    defaultValue = serializers.CharField(source = "default_value")

    class Meta:
        model = STAppConfSectionParagraphSetting
        fields = ('id', 'name', 'description', 'type', 'defaultValue')

class STAppConfSectionSettingRelatedField(serializers.RelatedField):
    """
    A custom field for different section settings
    """
    def to_representation(self, value):
        if isinstance(value, STAppConfSectionDeviceSetting):
            serializer = STAppConfSectionDeviceSettingSerializer(value)
        elif isinstance(value, STAppConfSectionParagraphSetting):
            serializer = STAppConfSectionParagraphSettingSerializer(value)
        else:
            raise Exception('Unexpected type of tagged object')

        return serializer.data

class STAppConfSectionSerializer(serializers.ModelSerializer):
    # @TODO: Support more types of settings in a more general way
    settings = STAppConfSectionParagraphSettingSerializer(many=True, source="paragraph_settings")

    class Meta:
        model = STAppConfSection
        fields = ('name', 'settings')

    def create(self, validated_data):
        settings_data = validated_data.pop('settings')
        stapp_section = STAppConfSection.objects.create(**validated_data)
        if len(settings_data) != 0:
            for setting in settings_data:
                # @TODO: Support more types of settings
                STAppConfSectionParagraphSetting.objects.create(section = stapp_section, **setting)
                # STAppConfSectionDeviceSetting.objects.create(section = stapp_section, **setting)
        return stapp_section


class STAppConfPageSerializer(serializers.ModelSerializer):
    id = serializers.CharField(source = 'pageId')
    sections = STAppConfSectionSerializer(many = True)

    class Meta:
        model = STAppConfPage
        fields = ('id', 'name', 'nextPageId', 'previousPageId', 'complete', 'sections')

    def create(self, validated_data):
        sections_data = validated_data.pop('sections')
        stapp_conf_page = STAppConfPage.objects.create(**validated_data)
        if len(sections_data) != 0:
            for section_data in sections_data:
                STAppConfSection.objects.create(page = stapp_conf_page, **section_data)
        return stapp_conf_page

class STAppSerializer(serializers.ModelSerializer):
    id = serializers.CharField(source = 'app_id')
    permissions = STAppPermissionRelatedField(many = True)
    pages = STAppConfPageSerializer(many = True)
    client_secret = serializers.CharField(write_only = True)

    class Meta:
        model = STApp
        fields = ('name', 'id', 'description', 'permissions', 'pages', 'prod_endpoint', 
                  'debug_endpoint', 'docker_endpoint', 'client_id', 'client_secret')

    def create(self, validated_data):
        pages_data = validated_data.pop('pages')
        perms_data = validated_data.pop('permissions')
        try:
            request = self.context.get("request")
            if STApp.objects.filter(client_id=validated_data.get("client_id"), client_secret=validated_data.get("client_secret")).exists():
                stapp = STApp.objects.get(client_id=validated_data.get("client_id"))
            else:
                # if the stapp has never been created before
                stapp = STApp.objects.get(app_id="superifttt-{}".format(request.user.username))
                stapp.name = validated_data.get("name")
                stapp.description = validated_data.get("description")
                stapp.prod_endpoint = validated_data.get("prod_endpoint")
                stapp.debug_endpoint = validated_data.get("debug_endpoint")
                stapp.docker_endpoint = validated_data.get("docker_endpoint")
                stapp.client_id = validated_data.get("client_id")
                stapp.client_secret = validated_data.get("client_secret")
            stapp.users.add(request.user)
            stapp.save()
        except IntegrityError:
            ErrorLog.objects.create(err="STAppSerializer: {}\n{}".format(repr(IntegrityError), traceback.format_exc()))
            return None
        except STApp.DoesNotExist:
            ErrorLog.objects.create(err="STAppSerializer: STApp.DoesNotExist\n{}\napp_id={}".format(traceback.format_exc(), "superifttt-{}".format(request.user.username)))
            return None
        except Exception as e:
            ErrorLog.objects.create(err="STAppSerializer: {}\n{}\napp_id={}".format(repr(e), traceback.format_exc(), "superifttt-{}".format(request.user.username)))
            return None
        
        if len(pages_data) != 0:
            for page_data in pages_data:
                secs_data = page_data.pop('sections')
                page = STAppConfPage.objects.create(st_app = stapp, **page_data)
                if len(secs_data) != 0:
                    for sec_data in secs_data:
                        try:
                            # @TODO: Support more types of settings in a more general way
                            settings_data = sec_data.pop('paragraph_settings')
                        except Exception as e:
                            err_msg = "STAppSerializer: {}\n{}\n{}".format(repr(e), traceback.format_exc(), str(sec_data))
                            ErrorLog.objects.create(err=err_msg)
                            raise e
                        section = STAppConfSection.objects.create(page = page, **sec_data)
                        if len(settings_data) != 0:
                            for setting_data in settings_data:
                                caps = setting_data.pop('capabilities') if 'capabilities' in setting_data else []
                                perms = setting_data.pop('permissions') if 'permissions' in setting_data else []
                                # @TODO: Support more types of settings
                                setting_type = setting_data.get("setting_type", "DEVICE")
                                try:
                                    if setting_type == "PARAGRAPH":
                                        setting = STAppConfSectionParagraphSetting.objects.create(section=section, **setting_data)
                                    elif setting_type == "DEVICE":
                                        setting = STAppConfSectionDeviceSetting.objects.create(section=section, **setting_data)
                                        if len(caps) != 0:
                                            for cap in caps:
                                                setting.capabilities.add(cap)
                                        if len(perms) != 0:
                                            for perm in perms:
                                                setting.permissions.add(perm)
                                except Exception as e:
                                    ErrorLog.objects.create(err="STAppSerializer: {}\n{}\n{}".format(repr(e), traceback.format_exc(), str(setting_data)))
                                    return None
        if len(perms_data) != 0:
            for perm_data in perms_data:
                stapp.permissions.add(perm_data)
        return stapp

