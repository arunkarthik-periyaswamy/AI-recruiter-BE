import json

from flask import request, jsonify, Blueprint
from marshmallow import ValidationError

from app.commons.custom_error import CustomError
from app.domain import domain_req, domain_service
from collections import namedtuple

from app.user.user_routes import token_required, get_user_and_tenant_from_token

domain_blueprint = Blueprint('domain_blueprint', __name__)


@domain_blueprint.route("/", methods=['POST', 'GET'])
@token_required
def handle_domain():
    if request.method == 'POST':
        user_id, tenant_id = get_user_and_tenant_from_token(request)
        request_data = request.get_json()
        domain_schema = domain_req.DomainReq()
        try:
            # Validate request body against schema data types
            domain_schema.load(request_data)
            domain_req_data = json.loads(request.get_data(),
                                         object_hook=lambda d: namedtuple('X', d.keys())(*d.values()))
            return domain_service.add_domain(domain_req_data, user_id), 200
        except ValidationError as err:
            # Return a nice message if validation fails
            return jsonify(err.messages), 400
    elif request.method == 'GET':
        domains = domain_service.get_all_domain()
        results = [
            {
                "id": domain.d_id,
                "name": domain.name,
            } for domain in domains]

        return {"count": len(results), "domains": results}


@domain_blueprint.route("/designation/<dsg_id>", methods=['GET'])
def get_domain_by_dsg_id(dsg_id):
    try:
        if not dsg_id.isdigit():
            raise CustomError("Designation id missing!.", 400)
        domains = domain_service.get_domain_by_dsg_id(dsg_id)
        if domains:
            return domains, 200
        return jsonify({'message': 'Domain Doesnt exist for the given Designation !!'}), 404
    except CustomError as e:
        return {"message": 'Failed to fetch domains for designation', "error": str(e.msg)}, e.status_code
    except Exception as ex:
        return {"message": "unable to fetch domains", "Error": str(ex)}, 500
