from channels.generic.websocket import AsyncWebsocketConsumer
import json
import os
from dotenv import load_dotenv
import httpx
import pandas as pd
from typing import Dict, Any, List

# Load environment variables
load_dotenv()


class ChatConsumer(AsyncWebsocketConsumer):

    def __init__(self, *args, **kwargs):
        super().__init__(args, kwargs)
        self.pet_type = None  # Store pet type (dog or cat)
        self.sickness = None  # Store sickness/condition
        self.food_type = None  # Store food type (wet or dry)
        self.data_set = None  # Store dataset name
        self.conversation_history = []  # Store conversation history
        self.last_action = None  # Track last action for follow-up

    async def connect(self):
        print("connect")
        self.room_name = self.scope['url_route']['kwargs']['room_name']
        self.room_group_name = f'chat_{self.room_name}'

        # Initialize API key
        self.openai_api_key = os.getenv("OPENAI_API_KEY")

        await self.accept()


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
        await self.send(text_data=json.dumps({'message': message}))

    async def receive(self, text_data):
        data = json.loads(text_data)
        user_message = data['message']
        user_message_lower = user_message.lower().strip()

        # Add user message to conversation history
        self.conversation_history.append({"role": "user", "content": user_message})

        # Check if message is health-related or food-related
        is_health_related = any(
            word in user_message_lower for word in ["sick", "illness", "symptoms", "injury", "health"])
        is_food_related = any(word in user_message_lower for word in ["food", "give", "eat", "feed"])

        # Check what details are present
        has_pet_type = any(word in user_message_lower for word in ["cat", "dog"])
        has_food_type = any(word in user_message_lower for word in ["wet", "dry"])

        # Set pet type if mentioned in message
        if has_pet_type and not self.pet_type:
            self.pet_type = "cat" if "cat" in user_message_lower else "dog"

        # HANDLE FOOD-RELATED QUERIES
        if is_food_related:
            # Follow-up on previous food suggestion
            if self.last_action == "food_suggestion" and user_message_lower not in ["no", "nope"]:
                food_suggestion = await self.get_filtered_products(user_message_lower)
                return

            # All details present → Fetch food immediately
            if has_pet_type and has_food_type:
                self.pet_type = "cat" if "cat" in user_message_lower else "dog"
                self.food_type = "Wet Food" if "wet" in user_message_lower else "Dry Food"
                pet_dataset = f"{self.pet_type}_food"
                self.data_set = pet_dataset
                food_suggestion = self.get_food_from_dataset(pet_dataset, self.food_type)

                await self.channel_layer.group_send(
                    self.room_group_name,
                    {'type': 'chat_message', 'message': f'🍖 Recommended food: {food_suggestion}'}
                )

                return

            # Handle when the last action was food_suggestion and check user input
            elif hasattr(self, "last_action") and self.last_action == "food_suggestion":
                print(f"Last action is: {self.last_action}")  # Debugging to see if last_action is set correctly
                print(f"User message: {user_message_lower}")  # Debugging to track the input

                if user_message_lower not in ["no", "nope"]:
                    print("User is not saying 'no' or 'nope'. Sending 'testing ?' message.")
                    # Make sure the message is being sent correctly
                    await self.channel_layer.group_send(
                        self.room_group_name,
                        {'type': 'chat_message', 'message': 'testing ?'}
                    )
                else:
                    print("User said 'no' or 'nope'. No action taken.")

                return


            # Pet type is present, but food type is missing → Ask for food type
            elif has_pet_type and not has_food_type:
                self.pet_type = "cat" if "cat" in user_message_lower else "dog"
                await self.channel_layer.group_send(
                    self.room_group_name,
                    {'type': 'chat_message', 'message': f'🍖 Do you want wet or dry food for your {self.pet_type}?'}
                )
                self.last_action = "asked_food_type"

                return


            # Food type is present, but pet type is missing → Ask for pet type
            elif has_food_type and not has_pet_type:
                self.food_type = "Wet Food" if "wet" in user_message_lower else "Dry Food"
                await self.channel_layer.group_send(
                    self.room_group_name,
                    {'type': 'chat_message', 'message': f'🐶🐱 Do you have a dog or a cat?'}
                )
                self.last_action = "asked_pet_type"
                return

            # Neither pet type nor food type is present → Ask for pet type first
            elif not has_pet_type and not has_food_type:
                await self.channel_layer.group_send(
                    self.room_group_name,
                    {'type': 'chat_message', 'message': f'🐶🐱 Do you have a dog or a cat?'}
                )
                self.last_action = "asked_pet_type"
                return

        # HANDLE FOLLOW-UP RESPONSES FOR FOOD QUERIES
        if self.last_action == "asked_pet_type" and user_message_lower in ["cat", "dog"]:
            self.pet_type = user_message_lower

            if self.food_type:
                # If we already have food type, provide recommendation
                pet_dataset = f"{self.pet_type}_food"
                self.data_set = pet_dataset
                food_suggestion = self.get_food_from_dataset(pet_dataset, self.food_type)

                await self.channel_layer.group_send(
                    self.room_group_name,
                    {'type': 'chat_message', 'message': f'🍖 Recommended food: {food_suggestion}'}
                )

                return
            else:
                # Ask for food type
                await self.channel_layer.group_send(
                    self.room_group_name,
                    {'type': 'chat_message', 'message': f'🍖 Do you want wet or dry food for your {self.pet_type}?'}
                )
                self.last_action = "asked_food_type"
            return

        if self.last_action == "asked_food_type" and any(word in user_message_lower for word in ["wet", "dry"]):
            self.food_type = "Wet Food" if "wet" in user_message_lower else "Dry Food"
            pet_dataset = f"{self.pet_type}_food"
            self.data_set = pet_dataset
            food_suggestion = self.get_food_from_dataset(pet_dataset, self.food_type)

            await self.channel_layer.group_send(
                self.room_group_name,
                {'type': 'chat_message', 'message': f'🍖 Recommended food: {food_suggestion}'}
            )


            return

        # HANDLE HEALTH-RELATED QUERIES
        if is_health_related:
            # Check if pet type is already stored, else ask for it
            if not self.pet_type:
                await self.ask_for_pet_type()
                return

            # If pet type is provided, ask for sickness description
            if self.pet_type and not self.sickness:
                await self.ask_for_sickness()
                return

            # Once both pet type and sickness are captured, provide health advice
            if self.pet_type and self.sickness:
                response = await self.get_ai_response()
                await self.channel_layer.group_send(
                    self.room_group_name,
                    {'type': 'chat_message', 'message': f'🩺 {response}'}
                )
                # Reset sickness after providing advice
                self.sickness = None
                self.last_action = None
                return

        # Handle sickness input if we're waiting for it
        if self.pet_type and not self.sickness and len(self.conversation_history) >= 2 and \
                self.conversation_history[-2][
                    'content'] == 'What seems to be the problem with your pet? Please describe the symptoms.':
            self.sickness = user_message
            response = await self.get_ai_response()
            await self.channel_layer.group_send(
                self.room_group_name,
                {'type': 'chat_message', 'message': f'🩺 {response}'}
            )
            # Reset sickness after providing advice
            self.sickness = None
            self.last_action = None
            return

        # For general conversation
        response = await self.get_ai_response()
        await self.channel_layer.group_send(
            self.room_group_name,
            {'type': 'chat_message', 'message': response}
        )

    async def disconnect(self, close_code):
        print("disconnect")
        await self.channel_layer.group_discard(self.room_group_name, self.channel_name)

    async def get_ai_response(self):
        """Get response from OpenAI API using AI SDK approach"""
        try:
            # System prompt to guide the model's behavior
            system_prompt = """
            You are a helpful pet assistant specializing in cats and dogs. You can provide advice on:

            1. HEALTH ISSUES:
               - Common illnesses and symptoms
               - When to see a vet
               - Basic first aid and care

            2. PET CARE:
               - General pet care tips
               - Exercise needs
               - Grooming advice

            Guidelines:
            - Always maintain a conversational, caring tone
            - For serious health issues, always recommend consulting a veterinarian
            - Only provide pet care information for cats and dogs
            - Keep responses concise and helpful

            Remember that you are not a substitute for professional veterinary care.
            """

            # Prepare messages for the API
            messages = [{"role": "system", "content": system_prompt}]

            # Add conversation history
            messages.extend(self.conversation_history)

            # Add pet type and sickness context if available
            if self.pet_type:
                context = f"The user has a {self.pet_type}."
                if self.sickness:
                    context += f" The {self.pet_type} is showing these symptoms: {self.sickness}"
                messages.append({"role": "system", "content": context})

            # Make API request to OpenAI
            async with httpx.AsyncClient() as client:
                response = await client.post(
                    "https://api.openai.com/v1/chat/completions",
                    headers={
                        "Content-Type": "application/json",
                        "Authorization": f"Bearer {self.openai_api_key}"
                    },
                    json={
                        "model": "gpt-4o",
                        "messages": messages,
                        "temperature": 0.7,
                        "max_tokens": 500
                    },
                    timeout=30.0
                )

                if response.status_code == 200:
                    result = response.json()
                    ai_message = result["choices"][0]["message"]["content"].strip()

                    # Add assistant response to conversation history
                    self.conversation_history.append({"role": "assistant", "content": ai_message})

                    return ai_message
                else:
                    return f"⚠️ Error: API returned status code {response.status_code}"

        except Exception as e:
            return f"⚠️ Error generating response: {str(e)}"

    async def ask_for_pet_type(self):
        """Ask user to specify if the pet is a cat or dog."""
        message = 'Is your pet a cat or a dog?'
        # Add assistant message to conversation history
        self.conversation_history.append({"role": "assistant", "content": message})
        await self.send(text_data=json.dumps({
            'message': message
        }))

    async def ask_for_sickness(self):
        """Ask user to describe the sickness/condition of the pet."""
        message = 'What seems to be the problem with your pet? Please describe the symptoms.'
        # Add assistant message to conversation history
        self.conversation_history.append({"role": "assistant", "content": message})
        await self.send(text_data=json.dumps({
            'message': message
        }))

    async def get_filtered_products(self, filter_value):
        """
        Fetch products based on the stored filter (brand or price).
        """
        try:
            file_path = f"{self.data_set}.csv"
            df = pd.read_csv(file_path)

            # Apply base filter (food type)
            df_filtered = df[df['Category'].str.lower() == self.food_type.lower()]

            # Check if filter_value is a price (number) or brand (string)
            if filter_value.replace("$", "").replace(".", "").isdigit():
                try:
                    price_limit = float(filter_value.replace("$", ""))  # Convert string price
                    df_filtered = df_filtered[df_filtered['Product_Price'] <= price_limit]
                except ValueError:
                    await self.channel_layer.group_send(
                        self.room_group_name,
                        {'type': 'chat_message',
                         'message': '⚠ Please provide a valid price range (Example: "Under $20").'}
                    )
                    return
            else:
                df_filtered = df_filtered[
                    df_filtered['Product_Brand'].str.lower().str.contains(filter_value.lower(), na=False)]

            # Select top 5 results
            food_recommendations = df_filtered[['Product_Name', 'Product_Price']].head(8).values.tolist()

            # Handle case where no products match
            if not food_recommendations:
                message = "⚠ No matching products found. Try another brand or price range."
            else:
                formatted_food = ", ".join([f"{name} (${price})" for name, price in food_recommendations])
                message = f'🍖 Recommended food: {formatted_food}'

            await self.channel_layer.group_send(
                self.room_group_name,
                {'type': 'chat_message', 'message': message}
            )

        except Exception as e:
            await self.channel_layer.group_send(
                self.room_group_name,
                {'type': 'chat_message', 'message': f"⚠ Error loading food data: {str(e)}"}
            )

    def get_food_from_dataset(self, pet_type, food_type):
        try:
            file_path = f"{pet_type}.csv"
            df = pd.read_csv(file_path)
            df_filtered = df[df['Category'].str.lower() == food_type.lower()]
            food_recommendations = df_filtered[
                ['Product_Brand', 'Product_Name', 'Product_Price', 'Category', 'Product_Description']].head(
                5).values.tolist()

            if not food_recommendations:
                return "No data found."

            firebase_base_url = "https://firebasestorage.googleapis.com/v0/b/pawsome-app-1903c.firebasestorage.app/o/food_products_images%2FDrools.jpg?alt=media&token=d6a4adad-8ae4-46ef-891d-36af8a909931"

            formatted_food = "\n\n".join([
                f"🛒 *{brand} - {name}*\n💰 Price: ${price}\n📂 Category: {category}\n📄 {description}\n"
                for brand, name, price, category, description in food_recommendations
            ])

            return formatted_food
        except Exception as e:
            return f"⚠ Error loading food data: {str(e)}"