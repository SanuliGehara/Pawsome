from django.http import JsonResponse
from .models import Message

def get_chat_history(request, sender, receiver):
    messages = Message.objects.filter(sender=sender, receiver=receiver) | \
               Message.objects.filter(sender=receiver, receiver=sender)
    messages = messages.order_by("timestamp")  # Order by time

    return JsonResponse({"messages": list(messages.values())})
