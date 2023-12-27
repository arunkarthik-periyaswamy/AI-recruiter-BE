import uuid

from sqlalchemy import or_
from werkzeug.security import generate_password_hash

from app import db
from app.candidate.candidate import Candidate, CandidateDomains
from app.commons.custom_error import CustomError
from app.designation.designation import Designation
from app.designation.designation_service import get_designation_by_dsg_id
from app.evaluation.service import get_interviewed_candidate_evaluations, get_interviews_scheduled_by_user


def add_candidate_domains(c_id, domains):
    for domain in domains:
        candidate_domain = CandidateDomains(domain_id=domain, candidate_id=c_id)
        db.session.add(candidate_domain)
        db.session.flush()


def create_candidate(name, email, password, designation, phone_number,
                     valid_id, years_of_experience, expected_ctc, domains):
    designation = Designation.query.filter(
        db.and_(Designation.name == designation)).first()
    candidate = Candidate(
        c_id=uuid.uuid1(),
        c_name=name,
        phone_number=phone_number,
        email=email,
        password=generate_password_hash(password),
        valid_id=valid_id,
        expected_ctc=expected_ctc,
        years_of_experience=years_of_experience,
        dsg_id=designation.dsg_id
    )
    # insert user

    db.session.add(candidate)
    db.session.flush()
    add_candidate_domains(candidate.c_id, domains)
    return candidate


def candidate_exists_check(c_id):
    db.session.begin()
    exists = Candidate.query.filter(
        db.and_(Candidate.c_id == c_id)).first() is not None
    db.session.close()
    return exists


def get_candidate_by_id(c_id):
    candidate = Candidate.query.filter(
        db.and_(Candidate.c_id == c_id)).first()
    db.session.close()
    return candidate


def get_candidate_domains_by_candidate_id(c_id):
    candidate_domains = CandidateDomains.query.filter_by(
        candidate_id=c_id).all()
    db.session.close()
    return candidate_domains


def get_candidate_table_data(c_id):
    try:
        db.session.begin()
        candidate = Candidate.query.filter(
            db.and_(Candidate.c_id == c_id)).first()
        if candidate:
            result = {'c_id': candidate.c_id,
                      'c_name': candidate.c_name,
                      'c_phone_no': candidate.phone_number,
                      'dsg_id': candidate.dsg_id,
                      'yox': candidate.year_of_experience,
                      }

        return result
    except Exception as e:
        raise e
    finally:
        db.session.close()


def get_candidate_by_email_or_phone(email_id, phone_number, tenant_id):
    candidate = Candidate.query.filter((or_(Candidate.email == email_id,
                                            Candidate.phone_number == phone_number)),
                                       Candidate.tenant_id == tenant_id).first()
    return candidate


def create_candidate_with_email(email, designation_name, years_of_experience, phone_number,
                                name, expected_ctc, tenant_id):
    designation = Designation.query.filter(
        db.and_(Designation.name == designation_name)).first()
    if not designation:
        raise CustomError('Designation Does not exist', 400)
    candidate = Candidate(
        c_id=uuid.uuid1(),
        email=email,
        dsg_id=designation.dsg_id,
        years_of_experience=years_of_experience,
        phone_number=phone_number,
        c_name=name,
        expected_ctc=expected_ctc,
        tenant_id=tenant_id
    )
    db.session.add(candidate)
    db.session.flush()
    return candidate


def get_candidate_details(tenant_id):
    all_candidates_from_interview = get_interviews_scheduled_by_user(tenant_id)
    interviewed_candidate = []
    for interview in all_candidates_from_interview:
        candidate_detail = get_candidate_by_id(interview['c_id'])
        designation = get_designation_by_dsg_id(candidate_detail.dsg_id)
        evaluation_details = get_interviewed_candidate_evaluations(interview['i_id'])

        sum_of_individual_scores = 0
        for evaluation_of_candidate in evaluation_details:
            sum_of_individual_scores += int(evaluation_of_candidate['score']) if evaluation_of_candidate['score'] else 0
        overall_question_marks = len(evaluation_details) * 10 # each question mark is 10
        average = sum_of_individual_scores / overall_question_marks
        over_all_score_of_candidate = round(average * 100)

        interview.update({'score': str(over_all_score_of_candidate)+"/100",  # +str(overall_question_marks)
                          'name': candidate_detail.c_name,
                          'email': candidate_detail.email,
                          'dsg_name': designation.name
                          })
        interviewed_candidate.append(interview)
    return interviewed_candidate


def get_candidates_for_tenant(tenant_id, dsg_id=None):
    try:
        where = [Candidate.tenant_id == tenant_id]
        if dsg_id:
            where.append(Candidate.dsg_id == dsg_id)
        return Candidate.query.filter(*where).all()
    except Exception as e:
        raise e
    finally:
        db.session.close()


def fetch_candidate_by_id(c_id, tenant_id):
    try:
        candidate = Candidate.query.filter(Candidate.c_id == c_id,
                                           Candidate.tenant_id == tenant_id).first()
        if not candidate:
            raise CustomError("Candidate does not exist for the given id", 400)
        return candidate
    except CustomError as ce:
        raise ce
    except Exception as e:
        raise e
    finally:
        db.session.close()
