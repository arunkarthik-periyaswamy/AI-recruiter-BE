import openai

gpt_prompt = {"role": "system",
              "content": "you are designed for answer user questions."}


def generate_response(question):
    messages = [
        {"role": "user",
         "content": question,
         }
    ]

    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=messages
    )

    return response["choices"][0]["message"]["content"]
