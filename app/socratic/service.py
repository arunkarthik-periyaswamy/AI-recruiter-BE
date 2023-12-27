from langchain.chat_models import ChatOpenAI
from langchain.schema import SystemMessage, HumanMessage, AIMessage
from app.commons.constants import EVALUATION_STATUS, EVAL_STATUS_CODE

from app.commons.custom_error import CustomError
from app.configurations.configuration_service import get_open_ai_key
from app.evaluation.service import check_candidate_exist, check_question_exist, get_question, update_evaluation_with_ai_answer, update_interview_status_evaluation_status
from app.socratic import socratic_prompt
from app.evaluation.model import Evaluations
from app import db
import openai

from app.socratic.ai_evaluations import ai_eval_score_generator


def get_next_chat_demo(chat):
    try:
        gpt = ChatOpenAI(
            temperature=0,
            model="gpt-4",
            max_retries=3,
            openai_api_key=get_open_ai_key()
        )

        print('+++++++++++++++++++++++++++', chat,
              '----------------------------', type(chat))
        question = chat[0].get("question")
        demo_prompt = socratic_prompt.demo_prompt
        demo_prompt = demo_prompt.format(question=question)

        chat[0] = SystemMessage(content=demo_prompt)
        for i in range(1, len(chat)):
            if "ai" in chat[i]:
                chat[i] = AIMessage(content=chat[i]["ai"])
            elif "human" in chat[i]:
                chat[i] = HumanMessage(content=chat[i]["human"])

        ai_response = gpt(chat)
        print('fetch data if already available use iid/qid for this')
        print('add all the chat to database without system prompt')
        print('If already thre update the column')
        return {"message": ai_response.content}

    except CustomError as e:
        raise e
    except Exception as e:
        raise e

def get_next_chat_interview(chat):
    try:
        gpt = ChatOpenAI(
            temperature=0,
            model="gpt-4",
            max_retries=3,
            openai_api_key=get_open_ai_key()
        )

        print('+++++++++++++++++++++++++++', chat,
              '----------------------------', type(chat))
        question = chat[0].get("question")
        demo_prompt = socratic_prompt.demo_prompt
        demo_prompt = demo_prompt.format(question=question)

        chat[0] = SystemMessage(content=demo_prompt)
        for i in range(1, len(chat)):
            if "ai" in chat[i]:
                chat[i] = AIMessage(content=chat[i]["ai"])
            elif "human" in chat[i]:
                chat[i] = HumanMessage(content=chat[i]["human"])

        ai_response = gpt(chat)
        print('fetch data if already available use iid/qid for this')
        print('add all the chat to database without system prompt')
        print('If already thre update the column')
        return {"message": ai_response.content}

    except CustomError as e:
        raise e
    except Exception as e:
        raise e



def get_interviewed_candidate_evaluations(i_id):
    try:
        evaluations = Evaluations.query.filter(Evaluations.interview_id == i_id).all()
        result = []
        if evaluations:
            for evaluation in evaluations:
                question = get_question(evaluation.q_id)
                result.append({'q_id': evaluation.q_id,
                               'c_id': evaluation.c_id,
                               'question': question['question'],
                               'candidate_conversations': evaluation.conversations,
                               'score': evaluation.score
                               })
        return result
    except Exception as e:
        raise e


def evaluate_interview_candidate_qa(interview_candidate_evaluations, date_of_interview, i_id):
    openai.api_key = get_open_ai_key()
    eval_report = []
    try:
        for evaluation in interview_candidate_evaluations:
            evaluated_answer, score, accuracy = ai_eval_score_generator(evaluation['question'],
                                                                        evaluation['conversations'])
            candidate_evaluation = [evaluation['c_id'], date_of_interview.date(), evaluation['question'],
                                    evaluation['conversations'],
                                    evaluated_answer, score, accuracy]
            update_evaluation_with_ai_answer(evaluation['q_id'], evaluation["c_id"], evaluated_answer, score)
            eval_report.append(candidate_evaluation)
        return eval_report
    except openai.error.RateLimitError as e:
        # retry_time = e.retry_after if hasattr(e, 'retry_after') else 30
        print(f"Rate limit exceeded....: {e}")
        update_interview_status_evaluation_status(i_id, None, EVALUATION_STATUS.ERROR.name, EVAL_STATUS_CODE.RATE_LIMIT_ERROR.value)
        raise CustomError(e, EVAL_STATUS_CODE.RATE_LIMIT_ERROR.value)
        # time.sleep(retry_time)
        # return evaluate_interview_candidate_qa(interview_candidate_evaluations, date_of_interview, i_id)
    except openai.error.APIError as e:
        print(f"API error occurred....: {e}")
        update_interview_status_evaluation_status(i_id, None, EVALUATION_STATUS.ERROR.name, EVAL_STATUS_CODE.API_ERROR.value)
        raise CustomError(e, EVAL_STATUS_CODE.API_ERROR.value)
    except openai.error.APIConnectionError as e:
        print(f"Connection error occurred: {e}")
        update_interview_status_evaluation_status(i_id, None, EVALUATION_STATUS.ERROR.name, EVAL_STATUS_CODE.API_CONNECTION_ERROR.value)
        raise CustomError(e, EVAL_STATUS_CODE.API_CONNECTION_ERROR.value)
    except openai.error.ServiceUnavailableError as e:
        print(f"ServiceUnavailable error occurred: {e}")
        update_interview_status_evaluation_status(i_id, None, EVALUATION_STATUS.ERROR.name, EVAL_STATUS_CODE.SERVICE_UNAVAILABLE_ERROR.value)
        raise CustomError(e, EVAL_STATUS_CODE.SERVICE_UNAVAILABLE_ERROR.value)
    except openai.error.InvalidRequestError as e:
        print(f"InvalidRequestError error occurred: {e}")
        update_interview_status_evaluation_status(i_id, None, EVALUATION_STATUS.ERROR.name, EVAL_STATUS_CODE.INVALID_REQUEST_ERROR.value)
        raise CustomError(e, EVAL_STATUS_CODE.INVALID_REQUEST_ERROR.value)
    except openai.error.Timeout as e:
        print(f"Timeout error occurred: {e}")
        update_interview_status_evaluation_status(i_id, None, EVALUATION_STATUS.ERROR.name, EVAL_STATUS_CODE.TIME_OUT_ERROR.value)
        raise CustomError(e, EVAL_STATUS_CODE.TIME_OUT_ERROR.value)
    except CustomError as e:
        print(f"Evaluation error occurred: {e.msg}")
        update_interview_status_evaluation_status(i_id, None, EVALUATION_STATUS.ERROR.name, EVAL_STATUS_CODE.EVALUATION_ERROR.value)
        raise CustomError(e, EVAL_STATUS_CODE.EVALUATION_ERROR.value)
    except Exception as e:
        print(f"Evaluation error occurred: {e}")
        update_interview_status_evaluation_status(i_id, None, EVALUATION_STATUS.ERROR.name, EVAL_STATUS_CODE.EVALUATION_ERROR.value)
        raise CustomError(e, EVAL_STATUS_CODE.EVALUATION_ERROR.value)

def candidate_interview_evaluation_report(c_id, i_id, interview_candidate):
    try:
        db.session.begin()
        date_of_interview = update_interview_status_evaluation_status(i_id, None, EVALUATION_STATUS.IN_PROGRESS.name, None)
        interview_candidate_evaluations = get_interviewed_candidate_evaluations(i_id)
        evaluate_report_data = evaluate_interview_candidate_qa(interview_candidate_evaluations, date_of_interview, i_id)
        # filename = report_filename_generate(c_id, interview_candidate.email, i_id, date_of_interview)
        # save_interview_candidate_report(evaluate_report_data, filename)
        update_interview_status_evaluation_status(i_id, None, EVALUATION_STATUS.COMPLETED.name, None)
        db.session.commit()
    except Exception as e:
        print(e)
        db.session.rollback()
        raise e
    finally:
        db.session.close()


def update_evaluation(evaluator_req):
    try:
        check_candidate_exist(evaluator_req.c_id)
        check_question_exist(evaluator_req.q_id)
        c_id = evaluator_req.c_id
        q_id = evaluator_req.q_id
        interview_id = evaluator_req.interview_id

        candidate_answer = evaluator_req.candidate_answer
        is_clue_used = evaluator_req.is_clue_used if evaluator_req.is_clue_used else False

        time_taken = evaluator_req.time_taken
        is_flagged = evaluator_req.is_flagged if evaluator_req.is_flagged else False
        evaluation = Evaluations.query.filter(
            db.and_(Evaluations.c_id == c_id, Evaluations.q_id == q_id,
                    Evaluations.interview_id == interview_id)).first()

        if evaluation:
            evaluation.candidate_answer = candidate_answer
            evaluation.is_clue_used = is_clue_used
            evaluation.time_taken = time_taken
            evaluation.is_flagged = is_flagged
            db.session.commit()
            return {"q_id": evaluation.q_id, "c_id": evaluation.c_id, "interview_id": interview_id}
        else:
            return {"message": 'No Evaluation found'}, 404
    except CustomError as e:
        return {"message": 'Failed to update', "error": str(e.msg)}, e.status_code
    except Exception as e:
        print(e)
        return {"message": 'Failed to update', "error": str(e)}, 500
    finally:
        db.session.close()
