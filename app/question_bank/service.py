import csv
import logging
import random
import uuid

import openai
from flask import jsonify

from app import db
from app.candidate.candidate_service import get_candidate_by_id, get_candidate_domains_by_candidate_id
from app.commons.constants import EVAL_STATUS_CODE
from app.commons.custom_error import CustomError
from app.configurations.configuration_service import get_open_ai_key
from app.designation import designation_service
from app.designation.designation_service import get_designation_by_dsg_id, designation_exists_check
from app.domain.domain_service import get_domain_by_domain_id
from app.evaluation.service import get_questions_attended_by_candidate, get_questions_un_attended_by_candidate
from app.interview.interview_service import validate_csv_row
from app.question_bank.ai_generate_qa import generate_qa_from_ai, generate_answer_from_ai
from app.question_bank.model import Question
from app.sub_domain.service import validate_sub_domain
from app.user import user_service


def check_user_exist(user_id):
    if not user_service.user_exists_check(user_id):
        logging.error(f"User:{user_id} User not found")
        raise CustomError('Questioner not found', 404)
    return True


def check_designation_exist(designation):
    if not designation_service.designation_exists_check(designation):
        logging.error(f"Designation:{designation} designation not found")
        raise CustomError('Designation not found', 404)


def check_question_exists(question, tenant_id=None):
    if Question.query.filter(Question.question == question, Question.tenant_id == tenant_id).first() is not None:
        raise CustomError('Question already exists', 403)
    return False


def add_question_from_params(row, designation, user_id, tenant_id):
    code_required = row["code_required"]
    if code_required.lower() == 'true':
        code_required = True
    elif code_required.lower() == 'false':
        code_required = False

    try:
        check_question_exists(row["question"])
    except CustomError as ce:
        logging.error(f"Question {row['question']} already exists")
        return None
    questionInDb = Question(question_id=uuid.uuid1(),
                            question=row["question"],
                            question_type=row["question_type"],
                            designation=designation,
                            user_id=user_id,
                            answer_type=row["answer_type"],
                            code_required=code_required,
                            difficulty_index=row["difficulty_index"],
                            clues=row["clues"],
                            tenant_id=tenant_id
                            )
    db.session.add(questionInDb)
    db.session.flush()
    return questionInDb.question_id


def add_question(questionReq, tenant_id=None):
    try:
        check_user_exist(questionReq.user_id)
        check_designation_exist(questionReq.designation)

        check_question_exists(questionReq.question, tenant_id)

        question = questionReq.question
        question_type = questionReq.question_type
        designation = questionReq.designation
        user_id = questionReq.user_id
        domain = questionReq.domain
        sub_domain = validate_sub_domain(designation, domain, questionReq.sub_domain)
        answer_type = questionReq.answer_type
        ai_answer = questionReq.ai_answer if hasattr(questionReq, "ai_answer") else None
        max_answering_time = questionReq.max_answering_time if hasattr(questionReq, "max_answering_time") else 300
        preparation_time = questionReq.preparation_time if hasattr(questionReq, "preparation_time") else 30
        code_required = questionReq.code_required
        difficulty_index = questionReq.difficulty_index
        clues = questionReq.clues if hasattr(questionReq, "clues") else None
        url = questionReq.url if hasattr(questionReq, "url") else None
        flagged = questionReq.flagged if hasattr(questionReq, "flagged") else None
        flag_expectation = questionReq.flag_expectation if hasattr(questionReq, "flag_expectation") else None

        questionInDb = Question(question_id=uuid.uuid1(), question=question, question_type=question_type,
                                designation=designation, user_id=user_id, sub_domain=sub_domain,
                                domain=domain, answer_type=answer_type, preparation_time=preparation_time,
                                ai_answer=ai_answer, max_answering_time=max_answering_time,
                                code_required=code_required, difficulty_index=difficulty_index, clues=clues,
                                url=url, flagged=flagged, flag_expectation=flag_expectation, tenant_id=tenant_id)
        db.session.add(questionInDb)
        db.session.commit()
        return questionInDb.as_dict()
    except CustomError as e:
        raise e
    finally:
        db.session.close()


def question_exists_check(q_id):
    db.session.begin()
    exists = Question.query.filter(
        db.and_(Question.question_id == q_id)).first() is not None
    db.session.close()
    return exists


def get_quest_bank_data_by_q_id(q_id):
    try:
        question = Question.query.filter(
            db.and_(Question.question_id == q_id)).first()
        if question:
            result = {
                'q_id': question.question_id,
                'ai_answer': question.ai_answer,
                'is_flagged': question.flagged,
                'question': question.question,
                'clues': question.clues,
                'code_required': question.code_required
            }
            return result
        else:
            return None
    except Exception as e:
        raise e


def get_question_for_candidate(c_id):
    try:
        db.session.begin()
        candidate = get_candidate_by_id(c_id)

        if candidate:
            designation = get_designation_by_dsg_id(candidate.dsg_id)
            candidate_domains = get_candidate_domains_by_candidate_id(c_id)

            difficulty_index_random = random.randrange(candidate.years_of_experience, 12, 2)
            d_random = random.randint(0, len(candidate_domains) - 1)

            domain = get_domain_by_domain_id(candidate_domains[d_random].domain_id)
            sub_domain = domain.sub_domain
            # domain should have sub_domain mapped
            sub_domain_random = random.randint(0, len(sub_domain) - 1)

            # get_question_attended_by_candidate from evaluation based on the candidate id,
            candidate_attended_questions = get_questions_attended_by_candidate(c_id)
            # questions = [uuid.uuid1(), uuid.uuid1()]
            question = Question.query.filter(
                Question.flagged == False,
                Question.difficulty_index == difficulty_index_random,
                Question.designation == designation.name,
                Question.domain == domain.name,
                Question.sub_domain == sub_domain[sub_domain_random],
                Question.question_id.not_in(candidate_attended_questions)).first()
            if question:
                return question.get_question_response()
            else:
                return jsonify({'message': 'No question found !!'}), 404
    except Exception as ex:
        db.session.rollback()
        print(ex)
        raise ex
    finally:
        db.session.close()


def get_clues_for_question(q_id):
    try:
        db.session.begin()
        question = Question.query.filter(Question.question_id == q_id).first()
        if question:
            clues = question.clues
            return jsonify({'clues': clues}), 200
        else:
            return jsonify({'message': 'No clues found for question !!'}), 404
    except Exception as ex:
        db.session.rollback()
        raise ex
    finally:
        db.session.close()


def get_question_by_question_id(q_id):
    try:
        db.session.begin()
        question = Question.query.filter(Question.question_id == q_id).first()
        if question:
            result = {
                "answer_type": question.answer_type,
                "code_required": question.code_required,
                "designation": question.designation,
                "difficulty_index": question.difficulty_index,
                "domain": question.domain,
                "max_answering_time": question.max_answering_time,
                "preparation_time": question.preparation_time,
                "question": question.question,
                "question_id": question.question_id,
                "question_type": question.question_type,
                "sub_domain": question.sub_domain,
                "url": question.url,
                "user_id": question.user_id
            }
            return result
        else:
            return jsonify({'message': 'No question found for question !!'}), 404
    except Exception as ex:
        db.session.rollback()
        raise ex
    finally:
        db.session.close()


def get_question_for_candidate_interview(c_id, i_id):
    return get_questions_un_attended_by_candidate(c_id, i_id)


def add_questions_from_file(file_path, designation, user_id, tenant_id):
    try:
        no_of_questions = 0
        with open(file_path, newline='') as csvfile:
            reader = csv.DictReader(csvfile)
            for question_row in reader:
                validate_csv_row(question_row)
                no_of_questions += 1
                add_question_from_params(question_row, designation, user_id, tenant_id)
        db.session.commit()
    except CustomError as e:
        print(e)
        db.session.rollback()
        return {"message": 'Failed', "error": e.msg}, e.status_code
    except Exception as e:
        print(e)
        db.session.rollback()
        return {"message": 'Failed', "error": str(e)}
    finally:
        db.session.close()


def get_question_added_under_tenant(tenant_id, designation):
    try:
        questions = Question.query.filter(db.and_(Question.tenant_id == tenant_id, Question.designation == designation)).all()
        result = []
        if questions:
            for question in questions:
                result.append(question.question_id)
            return result
        else:
            raise CustomError('No questions added for this designation.', 403)
    except Exception as ex:
        raise ex


def get_question_bank_designation_for_user(user_id):
    try:
        questions = Question.query.distinct(Question.designation).filter(db.and_(Question.user_id == user_id)).all()
        result = []
        if questions:
            for question in questions:
                if question.designation not in result:
                    result.append(question.designation)
        return result
    except Exception as ex:
        raise ex
    finally:
        db.session.close()


def get_question_list_for_designation(request, tenant_id):
    try:
        logging.info("fetching question list")
        designation = request.args.get("designation", '')
        if not designation:
            raise CustomError('Designation not provided', 400)
        if not designation_exists_check(designation):
            raise CustomError('Invalid designation provided!.', 400)
        where = [Question.designation == designation]

        # Todo: Handle user based filter based on role of the user.
        if tenant_id:
            where.append(Question.tenant_id == tenant_id)
        questions = Question.query.filter(*where).all()
        result = [{
            "answer_type": question.answer_type,
            "code_required": question.code_required,
            "designation": question.designation,
            "difficulty_index": question.difficulty_index,
            "domain": question.domain,
            "max_answering_time": question.max_answering_time,
            "preparation_time": question.preparation_time,
            "question": question.question,
            "question_id": question.question_id,
            "question_type": question.question_type,
            "sub_domain": question.sub_domain,
            "url": question.url,
            "user_id": question.user_id
        } for question in questions]
        logging.info(f"Fetched {len(result)} questions for the designation {designation}")
        return {"count": len(result),
                "questions": result}
    except CustomError as e:
        logging.error(e)
        return {"message": 'Failed', "error": e.msg}, e.status_code
    except Exception as e:
        logging.error(e)
        return {"message": 'Failed', "error": str(e)}
    finally:
        db.session.close()


def generate_question_and_answer(generate_question_request):
    try:
        logging.info("Generating question and answer")
        openai.api_key = get_open_ai_key()
        return generate_qa_from_ai(generate_question_request)
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


def get_question_count_for_designations(designations, tenant_id):
    try:
        return db.session.query(
            Question.designation, db.func.count(Question.question_id)).filter(
            Question.designation.in_(designations), Question.tenant_id == tenant_id).group_by(
            Question.designation).all()
    except Exception as e:
        raise e
    finally:
        db.session.close()


def generate_answer_for_ques(req_data):
    try:
        logging.info("Generating question and answer")
        openai.api_key = get_open_ai_key()
        return generate_answer_from_ai(req_data)
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


def get_questions_for_tenant(tenant_id, dsg_id=None):
    try:
        where = [Question.tenant_id == tenant_id]
        if dsg_id:
            designation = get_designation_by_dsg_id(dsg_id)
            if not designation:
                raise CustomError("Invalid designation", 400)
            where.append(Question.designation == designation.name)
        return Question.query.filter(*where).all()
    except CustomError as ce:
        raise ce
    except Exception as e:
        raise e
    finally:
        db.session.close()
