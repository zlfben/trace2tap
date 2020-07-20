from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from django.conf import settings
from backend import models as m

class Command(BaseCommand):
    def handle(self, *args, **options):
        User = get_user_model()
        if not User.objects.filter(username="admin").exists() and settings.DEBUG:
            admin_name = "admin"
            admin_email = "admin@example.com"
            admin_password = "password"
            admin = User.objects.create_superuser(admin_name, admin_email, admin_password)
            user_profile = m.UserProfile(user=admin)
            user_profile.save()
            admin.userprofile = user_profile
            admin.save()
            self.stdout.write(self.style.SUCCESS('Successfully create superuser "%s"' % admin_name))
        elif not settings.DEBUG:
            admin_name = self.__get_secrets("admin_name")
            if not admin_name is None:
                if not User.objects.filter(username=admin_name).exists():
                    admin_email = self.__get_secrets("admin_email")
                    admin_password = self.__get_secrets("back_admin_password")
                    admin = User.objects.create_superuser(admin_name, admin_email, admin_password)
                    user_profile = m.UserProfile(user=admin)
                    user_profile.save()
                    admin.userprofile = user_profile
                    admin.save()
                    self.stdout.write(self.style.SUCCESS('Successfully create superuser.'))
                else:
                    print('Admin already exists.')
            else:
                print('Admin has not been defined yet!')
        else:
            print('Admin already exists.')

    def __get_secrets(self, secret_name):
        try:
            with open('/run/secrets/{}'.format(secret_name), 'r') as secret_file:
                return secret_file.read().strip(' \n')
        except IOError:
            return None
