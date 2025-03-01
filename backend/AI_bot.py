import openai

# Set your API key
openai.api_key = "your_openai_api_key_here"  # Replace with your actual API key

# Example function to generate text
def generate_text(prompt):
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",  # Use "gpt-4" for better results if available
        messages=[{"role": "system", "content": "You are a helpful assistant."},
                  {"role": "user", "content": prompt}]
    )
    return response["choices"][0]["message"]["content"]

# Example usage
user_input = "Explain the concept of recursion in simple terms."
print(generate_text(user_input))
