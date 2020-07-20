from django.core.management.base import BaseCommand
from backend.views import fe_all_rules_helper
from backend.util import record_request, record_response
from backend import models as m


class Command(BaseCommand):
    def handle(self, *args, **options):
        """
        This is used to add the location field in all existing state logs
        """
        for loc in m.Location.objects.all():
            record_response(fe_all_rules_helper(loc.id), 'edit_rule', loc)
