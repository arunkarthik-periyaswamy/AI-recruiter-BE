import uuid
from flask import jsonify
from app import db
from app.candidate import candidate_service
from app.commons.constants import INTERVIEW_STATUS, EVALUATION_STATUS
from app.commons.custom_error import CustomError
from app.evaluation import service as evaluation_service
from app.interview.interview import Interview
from app.question_bank import service as question_bank_service
from datetime import datetime, timezone


def validate_csv_row(row):
    if not row["question"]:
        raise CustomError('question is not provided in one of the rows in the question bank file', 403)
    if not row["question_type"]:
        raise CustomError('question_type is not provided in one of the rows in the question bank file', 403)
    if not row["answer_type"]:
        raise CustomError('answer_type is not provided in one of the rows in the question bank file', 403)
    if not row["code_required"]:
        raise CustomError('code_required is not provided in one of the rows in the question bank file', 403)
    if not row["difficulty_index"]:
        raise CustomError('difficulty_level is not provided in one of the rows in the question bank file', 403)


def update_interview_with_no_of_questions(interview, no_of_questions):
    interview = Interview.query.filter(
        db.and_(Interview.i_id == interview.i_id)).first()
    interview.no_of_questions = no_of_questions
    db.session.flush()


def start_interview_for_candidate(designation, email_id, years_of_experience, phone_number, name,
                                  expected_ctc, user_id):
    try:
        db.session.begin()
        candidate_id, interview = validate_candidate_and_create_interview(email_id, designation, years_of_experience, phone_number, name,
                                                                          expected_ctc, user_id)
        questions = question_bank_service.get_question_added_by_user(user_id, designation)
        no_of_questions = len(questions)
        for question_no in range(no_of_questions):
            evaluation_service.add_evaluation_from_params(candidate_id, questions[question_no], interview, question_no+1)

        if no_of_questions == 0:
            raise CustomError('questions should not be empty question bank file', 403)
        update_interview_with_no_of_questions(interview, no_of_questions)
        db.session.commit()
        return jsonify({'candidate_id': interview.c_id,
                        'interview_id': interview.i_id,
                        'no_of_question': interview.no_of_questions}), 201
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


def create_interview_for_candidate(candidate, user_id):
    interview = Interview(i_id=uuid.uuid1(), c_id=candidate.c_id, dsg_id=candidate.dsg_id, status=INTERVIEW_STATUS.PENDING.name,
                          evaluation_status=EVALUATION_STATUS.NOT_STARTED.name, date_of_interview=datetime.now(timezone.utc),
                          created_by=user_id)
    db.session.add(interview)
    db.session.flush()
    return interview


def validate_candidate_and_create_interview(email_id, designation, years_of_experience, phone_number, name, expected_ctc, user_id):
    candidate = candidate_service.get_candidate_by_email(email_id)
    if not candidate:
        candidate = candidate_service.create_candidate_with_email(email_id, designation, years_of_experience, phone_number, name,
                                                expected_ctc)
    elif candidate:
        # candidate_interview = get_interview_for_candidate(candidate)
        # if candidate_interview:
        #     if not candidate_interview.status == INTERVIEW_STATUS.COMPLETED.name:
        #         raise CustomError('Candidate Interview is not Completed', 403)
        raise CustomError('Candidate Already Exist', 403)
    interview = create_interview_for_candidate(candidate, user_id)

    return candidate.c_id, interview


def get_interview_for_candidate(candidate):
    return Interview.query.filter(
        db.and_(Interview.c_id == candidate.c_id)).first()


def get_interview_by_candidate_id(c_id):
    return Interview.query.filter(
        db.and_(Interview.c_id == c_id)).first()


def get_interview_by_id(i_id):
    try:
        interview = Interview.query.filter(
            db.and_(Interview.i_id == i_id)).first()
        if interview is None:
            raise CustomError('No Interview found', 404)
        last_visited_question = evaluation_service.get_last_visited_question_by_candidate(interview.c_id, interview.i_id)
        candidate = candidate_service.get_candidate_by_id(interview.c_id)
        interview_date = interview.date_of_interview
        if interview_date:
            interview_date = interview_date.strftime("%d/%m/%Y")
        result = {'interview_id': interview.i_id,
                  'candidate_id': interview.c_id,
                  'email': candidate.email,
                  'name': candidate.c_name,
                  'no_of_questions': interview.no_of_questions,
                  'last_visited_question': last_visited_question['last_visited_question_num'],
                  'question_id': last_visited_question['question_id'],
                  'interview_status': interview.status,
                  'date_of_interview': interview_date}

        return result
    except CustomError as e:
        print(e)
        return {'message': 'error occurred',
                'error': e.msg}, e.status_code
    except Exception as e:
        print(e)
        return {'message': 'error occurred',
                'error': str(e)}
    finally:
        db.session.close()


def update_interview_status(i_id, interview_status):
    try:
        interview = Interview.query.filter(
            db.and_(Interview.i_id == i_id)).first()
        if interview:
            interview.status = interview_status
            db.session.commit()
            return
        raise FileNotFoundError("Interview: `{}` does not exist".format(i_id))
    finally:
        db.session.close()
