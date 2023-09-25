import json
from collections import namedtuple

from flask import request, jsonify, Blueprint, make_response

from app.candidate import candidate_req
from werkzeug.security import check_password_hash
from app.candidate.candidate import Candidate
from app.candidate.candidate_service import create_candidate, get_candidate_by_id
from app import db
from app.tenant.tenant_header_check import check_tenant_user
from app.user.user_routes import token_required, get_user_and_tenant_from_token



candidate_blueprint = Blueprint('candidate_blueprint', __name__)


@candidate_blueprint.route('/login', methods=['POST'])
def login():
    try:
        request_data = request.get_json()
        schema = candidate_req.CandidateReq()
        # Validate request body against schema data types
        schema.load(request_data)
        candidate_req_data = json.loads(request.get_data(),
                                        object_hook=lambda d: namedtuple('X', d.keys())(*d.values()))

        if not candidate_req_data.email or not candidate_req_data.password:
            return make_response('Could not verify', 401)

        if not candidate_req_data.designation:
            return make_response('Designation is required', 403)

        if not candidate_req_data.phone_number:
            return make_response('Phone Number is required', 403)

        if not candidate_req_data.valid_id:
            return make_response('Valid Id is required', 403)

        if not candidate_req_data.years_of_experience:
            return make_response('Years of Experience is required', 403)

        if not candidate_req_data.expected_ctc:
            return make_response('expected_ctc is required', 403)

        if not candidate_req_data.domains:
            return make_response('Domain is required', 403)

        candidate = Candidate.query.filter_by(email=candidate_req_data.email).first()

        if not candidate:
            candidate = create_candidate(candidate_req_data.name, candidate_req_data.email,
                                         candidate_req_data.password,
                                         candidate_req_data.designation,
                                         candidate_req_data.phone_number,
                                         candidate_req_data.valid_id,
                                         candidate_req_data.years_of_experience,
                                         candidate_req_data.expected_ctc,
                                         candidate_req_data.domains)
            db.session.commit()
        elif candidate:
            if not check_password_hash(candidate.password, candidate_req_data.password):
                return make_response('Could not verify', 403)

        return make_response(jsonify({'candidate_id': candidate.c_id}),
                             201)
    except Exception as e:
        db.session.rollback()
        raise e
    finally:
        db.session.close()


@candidate_blueprint.route('/<c_id>', methods=['GET'])
def get_candidate_by_candidate_id(c_id):
    candidate = get_candidate_by_id(c_id)
    if candidate:
        return {
            "candidate_id": candidate.c_id,
            "name": candidate.c_name,
            "phone_number": candidate.phone_number,
            "email": candidate.email
        }
    else:
        return make_response('Could not find candidate', 404)

# Commented for later implementation
# @candidate_blueprint.route("/<c_id>/candidate/delete", methods=['GET'])
# @token_required
# @check_tenant_user
# def delete_candidate_by_candidate_id(c_id):
#     try:
#         return delete_candidate(c_id)
#     except Exception as e:
#         db.session.rollback()
#         raise e


