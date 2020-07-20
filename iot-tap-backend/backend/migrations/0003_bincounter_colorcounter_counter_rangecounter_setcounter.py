# Generated by Django 2.2 on 2019-12-06 16:35

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('backend', '0002_auto_20191101_2113'),
    ]

    operations = [
        migrations.CreateModel(
            name='Counter',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('typ', models.TextField(choices=[('set', 'Set'), ('range', 'Range'), ('bin', 'Binary'), ('color', 'Color')])),
                ('count', models.IntegerField(default=0)),
                ('automated_count', models.IntegerField(default=0)),
                ('cap', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='backend.Capability')),
                ('dev', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='backend.Device')),
                ('param', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='backend.Parameter')),
            ],
        ),
        migrations.CreateModel(
            name='BinCounter',
            fields=[
                ('counter_ptr', models.OneToOneField(auto_created=True, on_delete=django.db.models.deletion.CASCADE, parent_link=True, primary_key=True, serialize=False, to='backend.Counter')),
                ('val', models.TextField(blank=True)),
            ],
            bases=('backend.counter',),
        ),
        migrations.CreateModel(
            name='ColorCounter',
            fields=[
                ('counter_ptr', models.OneToOneField(auto_created=True, on_delete=django.db.models.deletion.CASCADE, parent_link=True, primary_key=True, serialize=False, to='backend.Counter')),
                ('name', models.TextField(blank=True)),
                ('rgb', models.TextField(blank=True)),
            ],
            bases=('backend.counter',),
        ),
        migrations.CreateModel(
            name='RangeCounter',
            fields=[
                ('counter_ptr', models.OneToOneField(auto_created=True, on_delete=django.db.models.deletion.CASCADE, parent_link=True, primary_key=True, serialize=False, to='backend.Counter')),
                ('min', models.FloatField(default=float("-inf"))),
                ('max', models.FloatField(default=float("inf"))),
                ('representative', models.FloatField()),
            ],
            bases=('backend.counter',),
        ),
        migrations.CreateModel(
            name='SetCounter',
            fields=[
                ('counter_ptr', models.OneToOneField(auto_created=True, on_delete=django.db.models.deletion.CASCADE, parent_link=True, primary_key=True, serialize=False, to='backend.Counter')),
                ('val', models.TextField(blank=True)),
            ],
            bases=('backend.counter',),
        ),
    ]
