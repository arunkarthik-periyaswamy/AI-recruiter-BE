import json
import openai
import logging

prompt = {"role": "system",
          "content": """Given the following inputs 
Industry: Name of the industry which the subject is about
Role: The designation for which the question is suitable
Domain: The domain on which we need to generate the question
Sub-Domain: The sub-domain to which we have to restrict the question.
Difficulty: difficulty level in the range of [1-10] which defines how hard the generated question should be
Code_Based: Boolean field indicating if the answer to questions needs to be a code snippet
you will generate a question based on the given inputs also follow the rules strictly.

Inputs:
Industry: {industry}
Role: {designation}
Domain: {domain}
Sub-Domain: {sub_domain}
Difficulty: {difficulty}
Code_Based: {code_based}

Rules:
1. Generate questions that require application of knowledge.
2. Ensure that the questions strictly adheres to the Sub-Domain.
3. If Code_Based is set to true strictly generate questions that require code snippet as answer.
4. Do not generate question which asks for definitions of terms and technology.
5. Enforce the difficulty level strictly - difficulty level 10 implies that the question is answerable by a person who has 10 years experience in the Sub-Domain.

The output should be a markdown code snippet formatted in the following schema, including the leading and trailing "```json" and "```":

```json
  {{
    "Generated Question": Str // A question of given difficulty level
    "Best Answer": Str // The best answer to the above question.
    "More Difficult Question": Str // A Question which is more difficult than the above question.
    "Difficulty_Hard": Int // What is the difficulty level for more difficult question compared to the generated question.
    "Answer_Hard": Str // The answer for the more difficult question
    "More Easy Question": Str // A Question which is more easier than the Generated Question.
    "Difficulty_Easy": Int // What is the difficulty level for more easy question compared to the generated question.
    "Answer_Easy": Str // The answer for the more easy question
  }}
```"""}


def generate_qa_from_ai(question_request):
    
    ai_prompt = prompt.copy() # Dont refer to dict as it replaces the {} in prompt above and will no longer be placeholder variables instead values
    structured_output = ""
    ai_prompt["content"] = ai_prompt["content"].format(industry=question_request.industry,
                                                               designation=question_request.designation,
                                                               domain=question_request.domain,
                                                               sub_domain=question_request.sub_domain,
                                                               difficulty=str(question_request.difficulty),
                                                               code_based=str(question_request.code_based)
                                                               )
    answer = openai.ChatCompletion.create(
          model="gpt-3.5-turbo",
          messages=[ai_prompt],
          temperature=0
    )
    
    ai_reply = answer.get("choices", [{}])[0].get("message", {}).get("content", None)
    if "```json" in ai_reply:
      print("formatting")
      print(ai_reply)
      json_string = ai_reply.split("```json")[1].strip().replace("```","")
      print(json_string)
      structured_output=json.loads(json_string)
    else:
      print("CAUGHT ERROR")
      json_string = ai_reply
    #json_output = json.loads(ai_reply) if ai_reply else None
    return structured_output
