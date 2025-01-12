from django.urls import path
from .views import CheckConnection

urlpatterns = [
    path('check/',CheckConnection.as_view(),name='project-status' ),
]