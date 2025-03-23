import json
from channels.generic.websocket import AsyncWebsocketConsumer
from .models import Message

class ChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        """Connects a user to the WebSocket with their username."""
        self.username = self.scope['url_route']['kwargs']['username']  # Get the username from the URL
        self.user_channel_name = f"user_{self.username}"  # Unique channel name for the user

        # Add user to their own channel
        await self.channel_layer.group_add(self.user_channel_name, self.channel_name)
        await self.accept()

    async def disconnect(self, close_code):
        """Removes the user from their own channel on disconnect."""
        await self.channel_layer.group_discard(self.user_channel_name, self.channel_name)

    async def receive(self, text_data):
        """Receives a message and sends it to the recipient if online."""
        data = json.loads(text_data)
        sender = data['sender']
        receiver = data['receiver']
        text = data['text']

        # Save message to the database
        message = Message(sender=sender, receiver=receiver, text=text)
        await message.asave()  # Save asynchronously

        # Send message to the recipient if they are online
        receiver_channel_name = f"user_{receiver}"  # Unique channel for the recipient
        await self.channel_layer.group_send(
            receiver_channel_name,
            {
                'type': 'chat_message',
                'sender': sender,
                'text': text,
                'timestamp': str(message.timestamp),
            }
        )

    async def chat_message(self, event):
        """Sends a message to the connected user."""
        await self.send(text_data=json.dumps(event))
