import json
import logging
from collections import namedtuple

from flask import Blueprint, request, jsonify
from marshmallow import ValidationError

from app.commons.custom_error import CustomError
from app.sub_domain import sub_domain_request
from app.sub_domain.service import save_sub_domain, fetch_sub_domain_for_domain
from app.user.user_routes import token_required, get_user_and_tenant_from_token

sub_domain_blueprint = Blueprint('sub_domain_blueprint', __name__)


@sub_domain_blueprint.route("/", methods=['POST'])
@token_required
def create_sub_domain():
    try:
        logging.info("Request to create Sub-domain")
        user_id, tenant_id = get_user_and_tenant_from_token(request)
        request_data = request.get_json()
        sub_domain_schema = sub_domain_request.SubdomainReq()
        try:
            # Validate request body against schema data types
            sub_domain_schema.load(request_data)
            sub_domain_data = json.loads(request.get_data(),
                                         object_hook=lambda d: namedtuple('X', d.keys())(*d.values()))
            return save_sub_domain(sub_domain_data, user_id), 200
        except ValidationError as err:
            # Return a nice message if validation fails
            return jsonify(err.messages), 400
    except CustomError as e:
        logging.error(e)
        return {"message": 'Failed to create industry', "error": str(e.msg)}, e.status_code
    except Exception as ex:
        logging.error(ex)
        return {"message": "unable to create sub domain"}, 500


@sub_domain_blueprint.route("/domain/<domain_id>", methods=['GET'])
@token_required
def get_sub_domain_by_domain(domain_id):
    try:
        if not domain_id.isdigit():
            raise CustomError("Domain id missing!.", 400)
        return fetch_sub_domain_for_domain(domain_id), 200
    except CustomError as e:
        return {"message": 'Failed to fetch sub-domains for domains', "error": str(e.msg)}, e.status_code
    except Exception as ex:
        return {"message": "unable to fetch sub-domains", "Error": str(ex)}, 500
