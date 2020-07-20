from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from django.conf import settings
from backend import models as m

class Command(BaseCommand):
    def handle(self, *args, **options):
        """
        This is used to add the location field in all existing state logs
        """
        state_logs = list(m.StateLog.objects.filter(loc=None))
        total = len(state_logs)
        num = 0
        for sl in state_logs:
            sl.loc = sl.dev.location
            sl.status = m.StateLog.HAPPENED
            sl.save()
            num += 1
            if num % 1000 == 0:
                print('%d/%d finished' % (num, total))
