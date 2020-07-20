from django.core.management.base import BaseCommand
from oauth2_provider.models import get_application_model
from django.conf import settings

class Command(BaseCommand):
    def handle(self, *args, **options):
        Application = get_application_model()
        if not Application.objects.filter(name="superifttt").exists():
            if settings.DEBUG:
                name = "superifttt"
                client_id = "application_1"
                client_secret = "application_secret"
                client_type = "confidential"
                authorization_grant_type = "password"
                app = Application.objects.create(name=name, client_id=client_id, client_secret=client_secret, 
                                                client_type=client_type, authorization_grant_type=authorization_grant_type)
                app.save()
                self.stdout.write(self.style.SUCCESS('Successfully create application "%s"' % name))
            else:
                client_id = self.__get_secrets("client_id")
                if not client_id is None:
                    name = "superifttt"
                    client_secret = self.__get_secrets("client_secret")
                    client_type = "confidential"
                    authorization_grant_type = "password"
                    app = Application.objects.create(name=name, client_id=client_id, client_secret=client_secret, 
                                                    client_type=client_type, authorization_grant_type=authorization_grant_type)
                    app.save()
                    self.stdout.write(self.style.SUCCESS('Successfully create application "%s"' % name))
                else:
                    print('Application has not been defined yet!')
        else:
            print('Application already exists')


    def __get_secrets(self, secret_name):
        try:
            with open('/run/secrets/{}'.format(secret_name), 'r') as secret_file:
                return secret_file.read().strip(' \n')
        except IOError:
            return None
