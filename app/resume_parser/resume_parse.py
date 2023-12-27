from langchain.chat_models import ChatOpenAI
from langchain.schema import SystemMessage
from concurrent.futures import ThreadPoolExecutor
import json
from app.configurations.configuration_service import get_open_ai_key
# import openai

# openai.openai_api_key = get_open_ai_key()

chatGPT_3516k = ChatOpenAI(
    model_name="gpt-4", temperature=0.0, openai_api_key = get_open_ai_key())

def first_questions(context, given_role, given_domain):
    try:
        messages = [
            SystemMessage(
                content="""Use the following pieces of context to answer the question at the end.
    
          """
                + context
                + """
    
          Questions:
          1. What is the first name of the candidate?
          2. What is the proof that the candidate has worked in """ + given_domain +""" industry?
          3. on a scale of 0 to 100 how good is the candidate's profile suited for the """+given_domain+""" domain?
          4. What is his most recent designation?
          5. what are the other suitable roles for him?
          6. What is the top best suitable role for him along with score?
          7. Does his recent designation better than """+ given_role +""" in the corporate hierarchy and in terms of salary?
          8. On a scale of 1 - 100 how likely will he accept the offer as a """+ given_role +"""?
          9. Explain why he is likely to accept or reject the offer as a """+ given_role +"""
          
    
          Use Candidate's firstname in titlecase wherever you refer to the candidate
          The output should be a markdown code snippet formatted in the following schema, including the leading and trailing "```json" and "```":
    
          ```json
          {{
            "FIRSTNAME" : string // Candidate's name in titlecase
            "CHECKPROOF" : string // Provide reasons if the candidate has experience working in healthcare industry if he does not have return No
            "DOMAIN_SCORE" : int // on a scale of 0 to 100 how good is the candidate's profile suited for the healthcare domain
            "RECENT_DESIGNATION": string // What is most recent designation
            "OTHER_SUITABLE_ROLES": list // A list of other suitable roles which are equal or higher to recent designation
            "TOP_SUITABLE_ROLES": key value pair // The best suitable role and score for that role out of 100
            "REASONS": string // If recent designation is ranked higher then """+ given_role +""" explain why else answer None
            "ACCEPTANCE_RATE": int  // on a scale of 0 to 100 Based on the above reasons what is his acceptance score if he gets the offer
            "ACCEPTANCE": string  // Explain why he is likely to accept or reject the offer as a """+ given_role +"""
          }}
          ```"""
            ),
        ]
        fin = chatGPT_3516k(messages)

        result = fin.content

        if "```json" in result:
            json_string = result.split("```json")[1].strip().replace("```", "")
            structured_output = json.loads(json_string)
            final = {
                "Acceptance": {
                    "score": structured_output["ACCEPTANCE_RATE"],
                    "content": structured_output["ACCEPTANCE"]
                    + " "
                    + structured_output["REASONS"]
                    + "\n He is suitable for the roles of "
                    + ",".join(structured_output["OTHER_SUITABLE_ROLES"])
                    + "\n He is best suited as a "
                    + structured_output["TOP_SUITABLE_ROLES"]["role"],
                },
                "domain": {
                    "score": structured_output["DOMAIN_SCORE"],
                    "content": structured_output["CHECKPROOF"],
                },
            }
        return final
    except Exception as e:
        raise e


def next_questions(context, given_role, given_domain):
    try:
        message_2 = [
            SystemMessage(
                content="""Use the following pieces of context to answer the question at the end.
    
          """
                + context
                + """
    
          Questions:
          1. Was he a job hopper in the past
          2. on a scale of 0 to 100 how good is the candidate's job stability
          3. Give reasons for job hopper considerations
          4. How good is his educational prowess?
          5. on a scale of 0-100 where 100 refers to a person who has doctorate from ivy league and 20 refers to a person who has passed school rate the candidate?
          6. on a scale of 0 to 100 how good is the candidate's profile suited for the """+ given_role +"""
          7. why did you give the above score?
    
          Use Candidate's firstname in titlecase wherever you refer to the candidate
          The output should be a markdown code snippet formatted in the following schema, including the leading and trailing "```json" and "```":
    
          ```json
          {{
            "WAS_JOB_HOPPER": string // yes or no whether he has showed tendency of job hopping in the past
            "JOB_STABILITY" : int //  on a scale of 0 to 100 how good is the candidate's job stability
            "JOB_HOPPER_CONSIDERATIONS": string // Define why he is or is not a Job Hopper
            "EDUCATIONAL_PROWESS": string // comments on candidates educational profile
            "EDUCATION_SCORE": string // rated on a scale of 0 to 100
            "FITNESS" : int // on a scale of 0 to 100 how good is the candidate's profile suited for the p"""+ given_role +"""
            "FITNESS_REASON" : string // What is the reason for the above score
          }}
          ```"""
            ),
        ]
        fin_2 = chatGPT_3516k(message_2)
        result_2 = fin_2.content

        if "```json" in result_2:
            json_string_2 = result_2.split("```json")[1].strip().replace("```", "")
            structured_output_2 = json.loads(json_string_2)
        final_2 = {
            "Fitness": {
                "score": structured_output_2["FITNESS"],
                "content": structured_output_2["FITNESS_REASON"],
            },
            "stability": {
                "score": structured_output_2["JOB_STABILITY"],
                "content": structured_output_2["JOB_HOPPER_CONSIDERATIONS"],
            },
            "education": {
                "score": structured_output_2["EDUCATION_SCORE"],
                "content": structured_output_2["EDUCATIONAL_PROWESS"],
            },
        }
        return final_2
    except Exception as e:
        raise e


def doc_parser(documents, given_role, given_domain):
    try:
        context = ""
        for docs in documents:
            context = context + docs.page_content + "\n"
        context = context.strip()

        # Commenting to utilize in future
        # with ThreadPoolExecutor(max_workers=4) as executor:
        #     futures = [
        #         executor.submit(first_questions, context, given_role, given_domain),
        #         executor.submit(next_questions, context, given_role, given_domain),
        #     ]
        # responses = [future.result() for future in futures]
        # response_object = {}
        # for response in responses:
        #     response_object.update(response)
        # return response_object

        response = first_questions(context, given_role, given_domain)
        response2 = next_questions(context, given_role, given_domain)
        response.update(response2)
        return response
    except Exception as e:
        raise e

