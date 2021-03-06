# Generated by Django 2.2 on 2019-06-22 04:17

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('contenttypes', '0002_remove_content_type_name'),
        ('smartthings', '0031_auto_20190607_0338'),
    ]

    operations = [
        migrations.CreateModel(
            name='STAppConfSectionDeviceSetting',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('st_app_id', models.CharField(blank=True, max_length=128, null=True)),
                ('setting_id', models.CharField(default=None, max_length=36)),
                ('name', models.TextField(default='')),
                ('description', models.TextField(default='')),
                ('setting_type', models.CharField(default='DEVICE', max_length=36)),
                ('required', models.BooleanField(default=True)),
                ('multiple', models.BooleanField(default=False)),
                ('capabilities', models.ManyToManyField(to='smartthings.Capability')),
                ('permissions', models.ManyToManyField(to='smartthings.STAppPermission')),
                ('section', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='device_settings', to='smartthings.STAppConfSection')),
            ],
        ),
        migrations.CreateModel(
            name='STAppConfSectionParagraphSetting',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('st_app_id', models.CharField(blank=True, max_length=128, null=True)),
                ('setting_id', models.CharField(default=None, max_length=36)),
                ('name', models.TextField(default='')),
                ('description', models.TextField(default='')),
                ('setting_type', models.CharField(default='PARAGRAPH', max_length=36)),
                ('default_value', models.TextField(default='')),
                ('section', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='paragraph_settings', to='smartthings.STAppConfSection')),
            ],
        ),
        migrations.RemoveField(
            model_name='stappinstancesetting',
            name='device',
        ),
        migrations.RemoveField(
            model_name='stappinstancesetting',
            name='setting',
        ),
        migrations.AddField(
            model_name='device',
            name='st_app_instance',
            field=models.ForeignKey(blank=True, default=None, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='devices', to='smartthings.STAppInstance'),
        ),
        migrations.AddField(
            model_name='device',
            name='st_app_instance_setting',
            field=models.ForeignKey(blank=True, default=None, null=True, on_delete=django.db.models.deletion.CASCADE, to='smartthings.STAppInstanceSetting'),
        ),
        migrations.AddField(
            model_name='stappinstance',
            name='access_token',
            field=models.CharField(default=None, max_length=40, null=True),
        ),
        migrations.AddField(
            model_name='stappinstance',
            name='access_token_expired_at',
            field=models.DateTimeField(blank=True, default=None, null=True),
        ),
        migrations.AddField(
            model_name='stappinstancesetting',
            name='content_type',
            field=models.ForeignKey(default=None, null=True, on_delete=django.db.models.deletion.CASCADE, to='contenttypes.ContentType'),
        ),
        migrations.AddField(
            model_name='stappinstancesetting',
            name='object_id',
            field=models.PositiveIntegerField(default=None, null=True),
        ),
        migrations.AlterField(
            model_name='stapp',
            name='owner',
            field=models.ForeignKey(default=None, null=True, on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL),
        ),
        migrations.AlterField(
            model_name='stappinstance',
            name='refresh_token',
            field=models.CharField(default=None, max_length=40, null=True),
        ),
        migrations.DeleteModel(
            name='STAppConfSectionSetting',
        ),
    ]
