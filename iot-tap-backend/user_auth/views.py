from django.shortcuts import render
from django.contrib.auth.models import User
from django.contrib.auth import authenticate

# Create your views here.
def new_user(request,**kwargs):
    user = User.objects.create_user(
            username=kwargs['username'],
            email=kwargs['email'],
            password=kwargs['password'],
            first_name=kwargs['fname'] if kwargs['fname'] else "",
            last_name=kwargs['lname'] if kwargs['lname'] else "")
    user.save()
    html = "<html><body><h1>Welcome, %s!</h1></body></html>" % kwargs['username']
    return HttpResponse(html)

def try_login(request,**kwargs):
    user = authenticate(username=kwargs['username'],password=kwargs['password'])
    if user is not None:
        html = "<html><body><p>Login Successful</p></body></html>"
        return HttpResponse(html)
    else:
        html = "<html><body><p>Login Failed</p></body></html>"
        return HttpResponse(html)
