from channels.generic.websocket import AsyncWebsocketConsumer
import json
import google.generativeai as genai


class ChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        print("connect")

        self.room_name = self.scope['url_route']['kwargs']['room_name']
        self.room_group_name = f'chat_{self.room_name}'

        await self.accept()

        await self.send(text_data=json.dumps({
            'message': 'Hello, WebSocket!'
        }))

        # Join room group
        await self.channel_layer.group_add(
            self.room_group_name,
            self.channel_name
        )

        await self.channel_layer.group_send(
            self.room_group_name,
            {
                'type': 'chat_message',
                'message': 'Connection established'
            }
        )

    async def chat_message(self, event):
        message = event['message']

        # Send message to WebSocket
        await self.send(text_data=json.dumps({
            'message': message
        }))

    async def receive(self, text_data):
        data = json.loads(text_data)
        user_message = data['message']

        # Generate response from Gemini AI
        ai_response = await self.get_gemini_ai_response(user_message)

        # Broadcast user message
        await self.channel_layer.group_send(
            self.room_group_name,
            {
                'type': 'chat_message',
                'message': user_message
            }
        )

        # Broadcast AI response
        await self.channel_layer.group_send(
            self.room_group_name,
            {
                'type': 'chat_message',
                'message': ai_response
            }
        )

    async def disconnect(self, close_code):
        print("disconnect")

        # Leave room group
        await self.channel_layer.group_discard(
            self.room_group_name,
            self.channel_name
        )

    async def get_gemini_ai_response(self, message):
        api_key = "AIzaSyAUwy7cyVdTHtx8xN6vFx9ocaKTUkzxjh0"  # Replace with actual API key
        genai.configure(api_key=api_key)

        model = genai.GenerativeModel(model_name="gemini-2.0-flash")

        try:
            response = model.generate_content(message)
            return response.text  # Return the generated response text
        except Exception as e:
            return f"Error generating response: {str(e)}"
