from rest_framework import viewsets
from django.http import HttpResponse


def helloWorld(request):
    return HttpResponse("Hello World!")


class UserViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows users to be viewed or edited.
    """
    pass
