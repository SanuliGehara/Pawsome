import google.generativeai as genai

# Set your API key
api_key="AIzaSyAUwy7cyVdTHtx8xN6vFx9ocaKTUkzxjh0"

genai.configure(api_key=api_key)

# Initialize the model
model = genai.GenerativeModel(model_name="gemini-2.0-flash")

# Generate a response
response = model.generate_content("Tell me a fun fact about AI")

# Print the output
print(response.text)
