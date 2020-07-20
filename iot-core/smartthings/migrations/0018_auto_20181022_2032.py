# Generated by Django 2.0.8 on 2018-10-22 20:32

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('smartthings', '0017_merge_20181019_2006'),
    ]

    operations = [
        migrations.AddField(
            model_name='device',
            name='component_id',
            field=models.CharField(default='main', max_length=36),
        ),
        migrations.AddField(
            model_name='stapp',
            name='client_id',
            field=models.CharField(default=None, max_length=36, unique=True),
        ),
        migrations.AddField(
            model_name='stapp',
            name='client_secrete',
            field=models.CharField(default=None, max_length=36, unique=True),
        ),
    ]
