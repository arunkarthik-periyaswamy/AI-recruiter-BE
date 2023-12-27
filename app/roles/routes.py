import json
import logging

from flask import request, jsonify, Blueprint
from marshmallow import ValidationError

from app.commons.custom_error import CustomError
from app.roles import role_req, role_service
from collections import namedtuple

from app.roles.role_service import add_permission, fetch_lower_hierarchy_roles
from app.user.user_routes import get_user_and_tenant_from_token, token_required
from app.user.user_service import fetch_user_by_id

roles_blueprint = Blueprint('roles_blueprint', __name__)


@roles_blueprint.route("/", methods=['POST', 'GET'])
@token_required
def handle_role():
    if request.method == 'POST':
        user_id, tenant_id = get_user_and_tenant_from_token(request)
        request_data = request.get_json()
        role_schema = role_req.RoleReq()
        try:
            # Validate request body against role_schema data types
            role_schema.load(request_data)
            role_req_data = json.loads(request.get_data(), object_hook=lambda d: namedtuple('X', d.keys())(*d.values()))
            return role_service.add_role(role_req_data, user_id), 200
        except ValidationError as err:
            # Return a nice message if validation fails
            return jsonify(err.messages), 400
    elif request.method == 'GET':
        try:
            roles = role_service.get_all_role()
            results = [role.format() for role in roles]
            return {"count": len(results), "roles": results}
        except Exception as ex:
            logging.error(ex)
            return {"message": "unable to fetch roles"}, 500


@roles_blueprint.route("/<role_id>/permission/<permission_id>", methods=['POST'])
@token_required
def add_permission_to_role(role_id, permission_id):
    try:
        return add_permission(role_id, permission_id)
    except CustomError as e:
        return {"message": 'Failed', "error": e.msg}, e.status_code
    except Exception as ex:
        logging.error(ex)
        return {"message": "unable to add permission to role"}, 500


@roles_blueprint.route("/lower-roles", methods=['GET'])
@token_required
def get_lower_roles():
    try:
        user_id, tenant_id = get_user_and_tenant_from_token(request)
        user = fetch_user_by_id(user_id)
        return fetch_lower_hierarchy_roles(user)
    except Exception as ex:
        logging.error(ex)
        return {"message": "unable to fetch roles"}, 500
