# Generated by Django 2.0.8 on 2018-10-13 04:33

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('smartthings', '0007_auto_20181012_2245'),
    ]

    operations = [
        migrations.AlterField(
            model_name='stapppermission',
            name='scope',
            field=models.CharField(max_length=36, unique=True),
        ),
    ]
