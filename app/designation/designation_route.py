import json
import logging

from flask import request, jsonify, Blueprint
from marshmallow import ValidationError

from app.commons.custom_error import CustomError
from app.designation import designation_req, designation_service
from collections import namedtuple

from app.designation.designation_service import fetch_designation_by_industry, assign_user_to_designation, \
    fetch_questioners_for_designation, remove_questioner
from app.question_bank.service import get_question_count_for_designations
from app.user.user_routes import token_required, get_user_and_tenant_from_token

designation_blueprint = Blueprint('designation_blueprint', __name__)


@designation_blueprint.route("/", methods=['POST', 'GET'])
@token_required
def handle_designation():
    user_id, tenant_id = get_user_and_tenant_from_token(request)
    if request.method == 'POST':
        request_data = request.get_json()
        designation_schema = designation_req.DesignationReq()
        try:
            # Validate request body against schema data types
            designation_schema.load(request_data)
            designation_req_data = json.loads(request.get_data(), object_hook=lambda d: namedtuple('X', d.keys())(*d.values()))
            return designation_service.add_designation(designation_req_data, tenant_id)
        except ValidationError as err:
            return jsonify(err.messages), 400
    elif request.method == 'GET':
        try:
            designations = designation_service.get_all_designation(tenant_id)
            results = [
                {
                    "id": designation.dsg_id,
                    "name": designation.name,
                    "industry_id": designation.industry_id
                } for designation in designations]

            no_of_questions = get_question_count_for_designations([result.get("name") for result in results], tenant_id)
            no_of_questions = dict(no_of_questions)

            for result in results:
                result["no_of_questions"] = no_of_questions.get(result.get("name"), 0)

            return {"count": len(results), "designations": results}
        except Exception as e:
            logging.error(e)
            return {"message": 'Failed', "error": str(e)}, 500


@designation_blueprint.route("/<dsg_id>", methods=['GET'])
@token_required
def get_designation_by_dsg_id(dsg_id):
    designation = designation_service.get_designation_by_dsg_id(dsg_id)
    if designation:
        return designation
    return jsonify({'message': 'Designation Doesnt exist for the given Designation Id !!'}), 404


@designation_blueprint.route("/industry/<industry_id>", methods=['GET'])
@token_required
def get_designation_by_industry(industry_id):
    try:
        user_id, tenant_id = get_user_and_tenant_from_token(request)
        return fetch_designation_by_industry(industry_id, tenant_id)
    except Exception as e:
        logging.error(e)
        return {"message": 'Failed to fetch designations', "error": str(e)}, 500


@designation_blueprint.route("/<dsg_id>/user/<user_id>", methods=['PUT'])
@token_required
def add_user_to_designation(dsg_id, user_id):
    try:
        current_user_id, tenant_id = get_user_and_tenant_from_token(request)
        return assign_user_to_designation(dsg_id, user_id, tenant_id)
    except CustomError as e:
        return {"message": e.msg, "error": 'Failed'}, e.status_code
    except Exception as e:
        return {"message": 'Failed to add user to designation', "error": str(e)}, 500


@designation_blueprint.route("/<dsg_id>/questioners", methods=['GET'])
@token_required
def get_questioners_for_designation(dsg_id):
    try:
        user_id, tenant_id = get_user_and_tenant_from_token(request)
        return fetch_questioners_for_designation(dsg_id, tenant_id)
    except CustomError as e:
        return {"message": 'Failed', "error": e.msg}, e.status_code
    except Exception as e:
        return {"message": 'Failed to fetch questioners', "error": str(e)}, 500


@designation_blueprint.route("/<dsg_id>/user/<user_id>", methods=['DELETE'])
@token_required
def remove_user_from_designation(dsg_id, user_id):
    try:
        current_user, tenant_id = get_user_and_tenant_from_token(request)
        return remove_questioner(dsg_id, user_id, current_user)
    except CustomError as e:
        return {"message": e.msg, "error": 'Failed'}, e.status_code
    except Exception as e:
        return {"message": 'Failed to remove user from designation', "error": str(e)}, 500
