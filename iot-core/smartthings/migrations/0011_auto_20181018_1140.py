# Generated by Django 2.0.8 on 2018-10-18 16:40

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('smartthings', '0010_auto_20181016_1058'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='device',
            name='label',
        ),
        migrations.RemoveField(
            model_name='device',
            name='name',
        ),
        migrations.AddField(
            model_name='device',
            name='setting',
            field=models.OneToOneField(default=None, on_delete=django.db.models.deletion.CASCADE, to='smartthings.STAppConfSectionSetting'),
        ),
        migrations.AddField(
            model_name='device',
            name='st_app_instance',
            field=models.ForeignKey(default=None, on_delete=django.db.models.deletion.CASCADE, to='smartthings.STAppInstance'),
        ),
        migrations.AddField(
            model_name='stappconfsection',
            name='st_app_id',
            field=models.CharField(blank=True, max_length=128, null=True),
        ),
        migrations.AddField(
            model_name='stappconfsectionsetting',
            name='st_app_id',
            field=models.CharField(blank=True, max_length=128, null=True),
        ),
        migrations.AlterField(
            model_name='stappconfpage',
            name='nextPageId',
            field=models.CharField(default=None, max_length=64, null=True),
        ),
        migrations.AlterField(
            model_name='stappconfpage',
            name='pageId',
            field=models.CharField(max_length=64),
        ),
        migrations.AlterField(
            model_name='stappconfpage',
            name='previousPageId',
            field=models.CharField(default=None, max_length=64, null=True),
        ),
    ]
