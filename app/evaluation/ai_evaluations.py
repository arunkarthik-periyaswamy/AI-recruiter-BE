import openai
import re

from app import logger
from app.commons.custom_error import CustomError

gpt_prompt = {"role": "system",
              "content": """You are a evaluator who evaluates answers 
- you will rate the accuracy and correctness of the response in the scale of low, average, high without asking for a more accurate answer
- in case of a empty user prompt rate the answer as low and give the right answer do bot ask to provide more information.
- you will refrain from evaluating controversial questions.
- If Evaluation is low score should be in the range of 0 to 2
- Do not ask for more information or don't ask the user any question just provide rating and reason.
- provide the final response as a proper json format code {"Evaluation":"High,Low or Average","score":"integer number on a scale of 10 do not show as /10","Reason":"Provide the reason here","Question_Type":"Open-Ended or Closed"}"""}

gpt_prompt_2 = {"role": "system",
                "content": """You are a evaluator who evaluates answers - Input will be in the format {"question":the 
                question, "Answer":the answer for the question} - you will rate the accuracy and correctness of the 
                response in the scale of low, average, high without asking for a more accurate answer - in case of a 
                empty user prompt rate the answer as low and give the right answer do not ask to provide more 
                information. - you will refrain from evaluating controversial questions. - If Evaluation is low score 
                should be in the range of 0 to 2 - Do not ask for more information or don't ask the user any question 
                just provide rating and reason. - provide the response prompt as a proper json format code {
                "Evaluation":"High,Low or Average","Score":"integer number on a scale of 10 do not show as /10",
                "Reason":"Provide the reason here","Correct Answer":"If incorrect provide what is the correct 
                answer","Question_Type":"Open-Ended or Closed"}"""}


def ai_eval_score_generator(question, user_answer):
    messages = [
        gpt_prompt,
        {"role": "assistant",
         "content": question,
         },
        {"role": "user",
         "content": user_answer}
    ]
    content = {'input': {'question': question, 'Answer': user_answer}}
    messages_2 = [gpt_prompt_2, {"role": "user", "content": str(content)}]

    scorer = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=messages_2,
        temperature=0
    )
    answer_ratings = scorer["choices"][0]["message"]["content"]
    eval_result = get_score_accuracy_from_ai_response_using_regex(answer_ratings.strip())
    score, accuracy = get_score_accuracy_from_ai_response(eval_result.strip())
    try:
        score = int(score) if type(score) != str else int(score.strip("'").strip('"'))
    except ValueError as ve:
        raise CustomError("Score received in wrong datatype!.")
    return answer_ratings, score, accuracy


def get_score_accuracy_from_ai_response_using_regex(ai_response):
    pattern = r"\{([^{}]+)\}"

    matches = re.findall(pattern, ai_response)
    logger.info('Checking ai response regex match={}'.format(ai_response))
    for match in matches:
        logger.info(r'found regex match={}'.format(ai_response))
        return match


def get_score_accuracy_from_ai_response(ai_response):
    try:
        ai_list = ai_response.split(",")
        logger.info(r'ai_list {}'.format(ai_list))
        logger.info(r'ai_response {}'.format(ai_response))
        score = 0
        accuracy = None
        for string in ai_list:
            if ',' in string:
                string = string.replace(",", "")
            if 'Evaluation' in string:
                accuracy = string.split(":")[1]
                accuracy = accuracy.strip()
            if 'Score' in string:
                score = string.split(":")[1]
                if '/' in score:
                    score = score.split("/")[0]
                if 'out of 10' in score:
                    score = score.split("out of 10")[0]
                score = score.strip()
        return score, accuracy
    except Exception as e:
        print(e)
        raise CustomError(r'Cannot get Score and Accuracy from AI response format due to {}'.format(e), 500)
