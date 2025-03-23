from channels.routing import ProtocolTypeRouter, URLRouter
from channels.auth import AuthMiddlewareStack
from django.contrib import admin
from django.urls import path, include
import chat.routing

application = ProtocolTypeRouter({
    "http": URLRouter([
        path('admin/', admin.site.urls),  # Ensure admin panel works over ASGI
        path('chat/', include('chat.urls')),  # Include HTTP chat views
    ]),
    "websocket": AuthMiddlewareStack(
        URLRouter(chat.routing.websocket_urlpatterns)  # Load WebSocket URLs from chat app
    ),
})
