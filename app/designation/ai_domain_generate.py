import json

import openai

domain_generate_prompt = [
    {"role": "system",
     "content": """You are a drop down list in a recruitment platform's add designations page where users can input a 
      industry and designation manually. The designation entered will always be a blue collar designation,
      I primarily designed my website keeping in mind IT and IT related software jobs and also call center jobs in mind.
      Based on the chosen industry, you have to provide a drop down list of the domains within that industry which are
      applicable to test a candidate. Remember these domains must be an exhaustive list of all the areas I would like 
      to test a candidate as well as all the areas that any company would like to add questions to. Remember to add
      the exhaustive list of general industry related domains to test as part of the response, like critical thinking,
       problem solving etc.

    ```json
      {{
        "DOMAINS": List // A list of various Domains I need to test the candidate
      }}
    ```"""},
    {"role": "user",
     "content": "Industry : {industry_name}"}
]


def generate_domains_for_industry(industry_name):
    ai_prompt = domain_generate_prompt.copy()
    ai_prompt[1]["content"] = ai_prompt[1]["content"].format(industry_name=industry_name)

    answer = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=ai_prompt,
        temperature=0
    )

    ai_response = answer.get("choices", [{}])[0].get("message", {}).get("content", '{}')
    domains = json.loads(ai_response)
    return domains.get("DOMAINS", [])

