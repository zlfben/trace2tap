# Generated by Django 2.0.8 on 2018-10-18 21:51

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('smartthings', '0013_auto_20181018_1144'),
    ]

    operations = [
        migrations.AlterField(
            model_name='stappconfsectionsetting',
            name='setting_id',
            field=models.CharField(blank=True, max_length=36, null=True),
        ),
    ]
