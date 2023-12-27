import json

from flask import request, jsonify, Blueprint
from marshmallow import ValidationError

from app.commons.custom_error import CustomError
from app.domain import domain_req, domain_service
from collections import namedtuple

from app.sub_domain.service import fetch_sub_domain_for_domain
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
            return domain_service.add_domain(domain_req_data, user_id)
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
        return domain_service.get_domain_by_dsg_id(dsg_id), 200
    except CustomError as e:
        return {"message": 'Failed to fetch domains for designation', "error": str(e.msg)}, e.status_code
    except Exception as ex:
        return {"message": "unable to fetch domains", "Error": str(ex)}, 500


@domain_blueprint.route("/subdomain/designation/<designation_id>", methods=['GET'])
def get_domains_and_subdomains_by_designation(designation_id):
    try:
        # Check for the designation id is digit or not
        if not designation_id.isdigit():
            raise CustomError("Designation id missing!.", 400)

        # Get domains for the given designation id
        domains = domain_service.get_domain_by_dsg_id(designation_id)

        # Fetch the sub-domains for each domain
        sub_domains = {}
        for domain in domains['domains']:
            domain_id = domain['d_id']
            sub_domains[domain_id] = fetch_sub_domain_for_domain(str(domain_id))

        result = {"domains": domains, "sub_domains": sub_domains}
        return result, 200

    except CustomError as e:
        return {"message": 'Failed to fetch domains and sub-domains for designation', "error": str(e.msg)}, e.status_code
    except Exception as ex:
        return {"message": "Unable to fetch domains and sub-domains", "error": str(ex)}, 500
