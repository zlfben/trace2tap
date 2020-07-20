from django.contrib import admin
import smartthings.models as m

# Register your models here.
admin.site.register(m.STApp)
admin.site.register(m.Capability)
admin.site.register(m.Attribute)
admin.site.register(m.Command)
admin.site.register(m.Argument)
admin.site.register(m.Device)
admin.site.register(m.Location)
admin.site.register(m.STAppPermission)
admin.site.register(m.STAppConfPage)
admin.site.register(m.STAppConfSection)
admin.site.register(m.STAppConfSectionDeviceSetting)
admin.site.register(m.STAppConfSectionParagraphSetting)
admin.site.register(m.STAppInstance)
admin.site.register(m.STAppInstanceSetting)
admin.site.register(m.ErrorLog)
