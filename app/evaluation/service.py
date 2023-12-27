import csv
import logging
import os

import openai

from app import db
from app.candidate import candidate_service
from app.commons.constants import EVALUATION_STATUS, EVAL_STATUS_CODE
from app.commons.custom_error import CustomError
from app.configurations.configuration_service import get_open_ai_key
from app.evaluation.ai_evaluations import ai_eval_score_generator
from app.evaluation.model import Evaluations
from app.interview import interview_service
from app.interview.interview import Interview
from app.question_bank import service as question_bank_service


def check_candidate_exist(c_id):
    if not candidate_service.candidate_exists_check(c_id):
        logging.error(f"Candidate:{c_id} not found")
        raise CustomError('Candidate not found', 404)
    return True


def check_question_exist(q_id):
    if not question_bank_service.question_exists_check(q_id):
        logging.error(f"Question:{q_id} not found")
        raise CustomError('Question not found', 404)
    return True


def add_evaluation_from_params(c_id, q_id, interview, question_number, tenant_id):
    evaluation = Evaluations(c_id=c_id, q_id=q_id, interview_id=interview.i_id,
                             question_number=question_number, tenant_id=tenant_id)
    db.session.add(evaluation)
    db.session.flush()
    return evaluation


def add_evaluation(evaluator_req):
    try:
        check_candidate_exist(evaluator_req.c_id)
        check_question_exist(evaluator_req.q_id)
    except CustomError as e:
        return {"message": 'Failed to add', "error": str(e.msg)}, e.status_code

    ai_ans_data = get_question(evaluator_req.q_id)

    c_id = evaluator_req.c_id
    q_id = evaluator_req.q_id
    ai_answer = ai_ans_data['ai_answer']
    candidate_answer = evaluator_req.candidate_answer
    is_clue_used = evaluator_req.is_clue_used if evaluator_req.is_clue_used else False
    # score = ""#ai_score""

    time_taken = evaluator_req.time_taken
    is_flagged = evaluator_req.is_flagged if evaluator_req.is_flagged else False
    evaluation = Evaluations(c_id=c_id, q_id=q_id, ai_answer=ai_answer, candidate_answer=candidate_answer,
                             is_clue_used=is_clue_used, time_taken=time_taken, is_flagged=is_flagged)
    # ai_answer = ai_answer,

    db.session.add(evaluation)
    db.session.commit()
    db.session.flush()
    db.session.refresh(evaluation)
    db.session.close()
    return {"q_id": evaluation.q_id, "c_id": evaluation.c_id}


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


def get_question(q_id):
    return question_bank_service.get_quest_bank_data_by_q_id(q_id)


def get_questions_attended_by_candidate(c_id):
    try:
        evaluations = Evaluations.query.filter(
            db.and_(Evaluations.c_id == c_id)).all()
        result = []
        if evaluations:
            for evaluation in evaluations:
                result.append({'q_id': evaluation.q_id,
                               'c_id': evaluation.c_id,
                               'candidate_answer': evaluation.candidate_answer,
                               'ai_answer': evaluation.ai_answer,
                               'score': evaluation.score,
                               })

        return result
    except Exception as e:
        raise e


def update_evaluation_with_ai_answer(q_id, c_id, ai_evaluation, score):
    evaluation = Evaluations.query.filter_by(q_id=q_id, c_id=c_id).first()
    evaluation.ai_answer = ai_evaluation
    evaluation.score = score
    db.session.flush()


def evaluate_question_answer(question, answer):
    try:
        openai.api_key = get_open_ai_key()
        return ai_eval_score_generator(question, answer)
    except openai.error.RateLimitError as e:
        print(f"Rate limit exceeded....: {e}")
        raise CustomError(e, EVAL_STATUS_CODE.RATE_LIMIT_ERROR.value)
    except openai.error.APIError as e:
        print(f"API error occurred....: {e}")
        raise CustomError(e, EVAL_STATUS_CODE.API_ERROR.value)
    except openai.error.APIConnectionError as e:
        print(f"Connection error occurred: {e}")
        raise CustomError(e, EVAL_STATUS_CODE.API_CONNECTION_ERROR.value)
    except openai.error.ServiceUnavailableError as e:
        print(f"ServiceUnavailable error occurred: {e}")
        raise CustomError(e, EVAL_STATUS_CODE.SERVICE_UNAVAILABLE_ERROR.value)
    except openai.error.InvalidRequestError as e:
        print(f"InvalidRequestError error occurred: {e}")
        raise CustomError(e, EVAL_STATUS_CODE.INVALID_REQUEST_ERROR.value)
    except openai.error.Timeout as e:
        print(f"Timeout error occurred: {e}")
        raise CustomError(e, EVAL_STATUS_CODE.TIME_OUT_ERROR.value)
    except CustomError as e:
        print(f"Evaluation error occurred: {e.msg}")
        raise CustomError(e, EVAL_STATUS_CODE.EVALUATION_ERROR.value)
    except Exception as e:
        print(f"Evaluation error occurred: {e}")
        raise CustomError(e, EVAL_STATUS_CODE.EVALUATION_ERROR.value)


def get_questions_un_attended_by_candidate(c_id, i_id):
    try:
        db.session.begin()
        evaluation = Evaluations.query.filter(
            db.and_(Evaluations.c_id == c_id, Evaluations.interview_id == i_id,
                    Evaluations.candidate_answer == None)).first()
        result = None
        if evaluation:
            question_db = question_bank_service.get_quest_bank_data_by_q_id(evaluation.q_id)
            clue_status = True if question_db['clues'] else False
            result = {'q_id': evaluation.q_id,
                      'c_id': evaluation.c_id,
                      'question': question_db['question'],
                      # 'candidate_answer': evaluation.candidate_answer,
                      # 'ai_answer': evaluation.ai_answer,
                      'clue_available': clue_status,
                      'interview_id': i_id,
                      'code_required': question_db['code_required']
                      }
        return result
    except Exception as e:
        raise e
    finally:
        db.session.close()


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
                               'candidate_answer': evaluation.candidate_answer,
                               'score': evaluation.score
                               })
        return result
    except Exception as e:
        raise e


def candidate_interview_evaluation_report(c_id, i_id, interview_candidate):
    try:
        db.session.begin()
        date_of_interview = update_interview_status_evaluation_status(i_id, None, EVALUATION_STATUS.IN_PROGRESS.name, None)
        interview_candidate_evaluations = get_interviewed_candidate_evaluations(i_id)
        evaluate_report_data = evaluate_interview_candidate_qa(interview_candidate_evaluations, date_of_interview, i_id)
        filename = report_filename_generate(c_id, interview_candidate.email, i_id, date_of_interview)
        save_interview_candidate_report(evaluate_report_data, filename)
        update_interview_status_evaluation_status(i_id, None, EVALUATION_STATUS.COMPLETED.name, None)
        db.session.commit()
    except Exception as e:
        print(e)
        db.session.rollback()
        raise e
    finally:
        db.session.close()


def report_filename_generate(c_id, mail_id, i_id, date_of_interview):
    filename = c_id + "_" + mail_id + "_" + i_id
    base_path = "uploads/reports/"
    day_dir = str(date_of_interview.date())
    complete_path = base_path + day_dir + "/"
    is_exist = os.path.exists(complete_path)
    if not is_exist:
        os.makedirs(complete_path)
    return complete_path + filename + ".csv"


def get_candidate_report_for_download(c_id, email, i_id):
    try:
        interview = interview_service.get_interview_by_candidate_id(c_id)
        file_path = report_filename_generate(c_id, email, i_id, interview.date_of_interview)
        fd = None
        with open(file_path, 'r') as f:
            fd = f.read()
        return fd, f.name() + ".csv"
    except Exception as e:
        print(e)
        return {'message': 'error occurred',
                'error': str(e)}
    finally:
        db.session.close()


def get_interviews_scheduled_by_user(tenant_id):
    interviews = Interview.query.filter(db.and_(Interview.tenant_id == tenant_id)).all()
    candidates = []
    for interview in interviews:
        interview_date = interview.date_of_interview
        if interview_date:
            interview_date = interview_date.strftime("%d/%m/%Y")
        candidates.append({"i_id": interview.i_id,
                           "c_id": interview.c_id,
                           "evaluation_status": interview.evaluation_status,
                           "date_of_interview": interview_date,
                           "evaluation_status_code": interview.eval_status_code,
                           "interview_status": interview.status})
    return candidates


def update_interview_status_evaluation_status(i_id, interview_status, eval_status, eval_status_code):
    interview = Interview.query.filter(
        db.and_(Interview.i_id == i_id)).first()
    if interview_status:
        interview.status = interview_status
    if eval_status:
        interview.evaluation_status = eval_status
    interview.eval_status_code = eval_status_code
    db.session.commit()
    return interview.date_of_interview


def evaluate_interview_candidate_qa(interview_candidate_evaluations, date_of_interview, i_id):
    openai.api_key = get_open_ai_key()
    eval_report = []
    try:
        for evaluation in interview_candidate_evaluations:
            evaluated_answer, score, accuracy = ai_eval_score_generator(evaluation['question'],
                                                                        evaluation['candidate_answer'])
            candidate_evaluation = [evaluation['c_id'], date_of_interview.date(), evaluation['question'],
                                    evaluation['candidate_answer'],
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


def save_interview_candidate_report(report_data, filename):
    fields = ['Candidate_ID', 'Date_of_Interview', 'Question', 'Candidate Answer', 'Evaluated Answer', 'Score',
              'Accuracy']
    with open(filename, 'w') as f:
        csv_writer = csv.writer(f)
        csv_writer.writerow(fields)
        csv_writer.writerows(report_data)
    return filename


def get_all_candidate_status(tenant_id):
    try:
        db.session.begin()
        return candidate_service.get_candidate_details(tenant_id)
    except Exception as e:
        print(e)
        return {'message': 'error occurred',
                'error': str(e)}
    finally:
        db.session.close()


def get_candidate_report_for_download(c_id, email, i_id):
    try:
        interview = interview_service.get_interview_by_candidate_id(c_id)
        file_path = report_filename_generate(c_id, email, i_id, interview.date_of_interview)
        fd = None
        with open(file_path, 'r') as f:
            fd = f.read()
        return fd, f.name + ".csv"
    except Exception as e:
        print(e)
        return {'message': 'error occurred',
                'error': str(e)}
    finally:
        db.session.close()


def get_last_visited_question_by_candidate(c_id, i_id):
    evaluation = Evaluations.query.filter(
        db.and_(Evaluations.c_id == c_id, Evaluations.interview_id == i_id,
                Evaluations.candidate_answer != None)).order_by(Evaluations.question_number.desc()).first()
    if evaluation:
        result = {'last_visited_question_num': evaluation.question_number,
                  'question_id': evaluation.q_id
                  }
    else:
        result = {'last_visited_question_num': None,
                  'question_id': None
                  }
    return result
