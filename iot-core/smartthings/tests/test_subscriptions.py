from django.test import TestCase
from smartthings.models import Device

class SubscriptionTestCase(TestCase):
    def setUp(self):
        Device.objects.create(name = "Test")