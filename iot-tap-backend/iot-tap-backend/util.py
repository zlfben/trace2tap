def get_secrets(secret_name):
        try:
            with open('/run/secrets/{}'.format(secret_name), 'r') as secret_file:
                return secret_file.read().strip(' \n')
        except IOError:
            return None
