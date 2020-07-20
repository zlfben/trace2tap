from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from django.conf import settings
from django.core.cache import caches

from autotapta.input.IoTCore import inputTraceFromList, updateTraceFromList
from backend import models as m
from autotap.util import generate_dict_from_state_log, initialize_trace_for_location
from autotap.translator import generate_all_device_templates, generate_boolean_map


class Command(BaseCommand):
    def handle(self, *args, **options):
        """
        This is used to add the location field in all existing state logs
        """
        for loc in m.Location.objects.all():
            print('====== Initializing trace for location %s ======' % loc.name)
            initialize_trace_for_location(loc)
