from django.core.management.base import BaseCommand
from smartthings.util import get_latest_capabilities
from smartthings.models import Capability
from smartthings.serializers import CapabilitySerializer
from django.conf import settings

class Command(BaseCommand):
    def handle(self, *args, **options):
        caps_list = get_latest_capabilities()
        # Capability.objects.all().delete()
        for cap in caps_list:
            if Capability.objects.filter(st_id=cap["st_id"]).count() == 0:
                cap_serializer = CapabilitySerializer(data=cap)
                if cap_serializer.is_valid():
                    cap_serializer.save()
                else:
                    raise Exception('Fetch latest capabilities failed.')
            else:
                cap_instance = Capability.objects.get(st_id=cap["st_id"])
                cap_serializer = CapabilitySerializer(cap_instance, data = cap)
                if cap_serializer.is_valid():
                    cap_serializer.save()
                else:
                    raise Exception('Fetch latest capabilities failed.')
