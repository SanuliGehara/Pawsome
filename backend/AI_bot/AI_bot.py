import openai

# Set your API key
openai.api_key = "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"  # Replace with your actual API key

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
