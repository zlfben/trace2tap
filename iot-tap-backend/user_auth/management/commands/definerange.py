from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from django.conf import settings
from backend import models as m
from autotap.variable import initialize_range_sep_for_dev, update_separation_count


class Command(BaseCommand):
    def handle(self, *args, **options):
        """
        This is used to add range separations (manually)
        should handle light brightness, light color and light color temperature
        """
        state_logs = list(m.StateLog.objects.all())

        for dev in m.Device.objects.all():
            initialize_range_sep_for_dev(dev)
        
        num = 0
        total = len(state_logs)
        for state_log in state_logs:
            update_separation_count(state_log)
            num += 1
            if num % 1000 == 0:
                print('%d/%d finished' % (num, total))
