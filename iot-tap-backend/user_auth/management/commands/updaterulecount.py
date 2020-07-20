from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from django.conf import settings
from backend import models as m
from backend.rulecount import update_rule_count

class Command(BaseCommand):
    def handle(self, *args, **options):
        """
        This is to update the rule count (in how many cases it cover the manual action)
        This should happen after trace is inited
        """
        locations = m.Location.objects.all()
        
        for location in locations:
            rules = m.ESRule.objects.filter(st_installed_app_id=location.st_installed_app_id)
            for rule in rules:
                update_rule_count(rule, location)

