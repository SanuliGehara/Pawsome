from django.urls import path
from .views import get_chat_history

urlpatterns = [
    path('chat/history/<str:sender>/<str:receiver>/', get_chat_history),
]
