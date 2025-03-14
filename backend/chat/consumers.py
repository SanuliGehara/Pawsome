from channels.generic.websocket import AsyncWebsocketConsumer
import json
import google.generativeai as genai
import sqlite3


class ChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        print("connect")

        self.room_name = self.scope['url_route']['kwargs']['room_name']
        self.room_group_name = f'chat_{self.room_name}'
        self.pet_type = None  # Store pet type (dog or cat)

        await self.accept()

        # Custom welcome message
        await self.send(text_data=json.dumps({
            'message': '👋 Welcome to Pawsome Chat! How can I assist you today?'
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
                'message': '🔗 You are now connected to the chatbot!'
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
        user_message = data['message'].lower().strip()  # Convert to lowercase & strip spaces

        response = None  # Default response

        # If user asks about food for their pet
        if any(word in user_message for word in ["food", "give", "eat"]) and "pet" in user_message:
            response = "🐾 Is your pet a dog or a cat?"

        # If user specifies "dog" or "cat", store it and provide food suggestions
        elif user_message in ["dog", "cat"]:
            self.pet_type = user_message
            response = self.get_pet_food_suggestions(self.pet_type)

        # If pet type is already known and user asks about food
        elif self.pet_type and any(word in user_message for word in ["food", "give", "eat"]):
            response = self.get_pet_food_suggestions(self.pet_type)

        # If no special handling, get AI response
        if not response:
            response = await self.get_gemini_ai_response(user_message)

        # Broadcast user message
        # await self.channel_layer.group_send(
        #     self.room_group_name,
        #     {
        #         'type': 'chat_message',
        #         'message': f'👤 User: {data["message"]}'
        #     }
        # )

        # Broadcast AI response
        await self.channel_layer.group_send(
            self.room_group_name,
            {
                'type': 'chat_message',
                'message': f'🤖 : {response}'
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
            return response.text if response else "Sorry, I couldn't generate a response."
        except Exception as e:
            return f"⚠️ Error generating response: {str(e)}"

    def get_pet_food_suggestions(self, pet_type):

        conn = sqlite3.connect("pawsome_DB.db")  # Replace with your actual database file
        cursor = conn.cursor()

        query = 'SELECT name, brand, description, price FROM "cat food products" WHERE description LIKE ?'
        cursor.execute(query, (f"%{pet_type}%",))

        food_items = cursor.fetchall()

        conn.close()

        """Return food recommendations based on pet type."""
        if pet_type == "dog":
            if food_items:
                food_list = "\n".join([
                    f"🍖 {name} ({brand}) - {description} | 💰 {price} LKR | 🖼 Image: {image if image else 'No image available'}"
                    for name, brand, description, price, image in food_items
                ])
                return f"🐾 Recommended {pet_type} food:\n{food_list}"
            else:
                return f"Sorry, I couldn't find food recommendations for {pet_type}s."

        elif pet_type == "cat":

            def get_pet_food_brands():
                conn = sqlite3.connect("pawsome_DB.db")  # Replace with your actual DB file
                cursor = conn.cursor()

                query = 'SELECT brand FROM "cat food products"'  # Only fetching the brand name
                cursor.execute(query)

                results = cursor.fetchall()  # Get all brands
                conn.close()

                if results:
                    for row in results:
                        return (row[0])  # Print each brand
                else:
                    return ("⚠️ No brands found in the database.")

            # Run the test


            return get_pet_food_brands()
        else:
            return "I can only provide food suggestions for dogs or cats."
