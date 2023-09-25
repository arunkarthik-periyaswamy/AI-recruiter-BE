import json
import logging

from flask import request, jsonify, Blueprint
from marshmallow import ValidationError

from app.commons.custom_error import CustomError
from app.permission import permission_req, permission_service
from collections import namedtuple

from app.permission.permission_service import fetch_permissions_for_role
from app.roles.role_service import verify_role
from app.user.user_routes import get_user_and_tenant_from_token, token_required

permission_blueprint = Blueprint('permission_blueprint', __name__)


@permission_blueprint.route("/", methods=['POST', 'GET'])
@token_required
def handle_permission():
    if request.method == 'POST':
        user_id, tenant_id = get_user_and_tenant_from_token(request)
        request_data = request.get_json()
        permission_schema = permission_req.PermissionReq()
        try:
            # Validate request body against schema data types
            permission_schema.load(request_data)
            permission_req_data = json.loads(request.get_data(), object_hook=lambda d: namedtuple('X', d.keys())(*d.values()))
            return permission_service.save_permission(permission_req_data, user_id), 200
        except ValidationError as err:
            return jsonify(err.messages), 400
    elif request.method == 'GET':
        permissions = permission_service.get_all_permission()
        results = [permission.format() for permission in permissions]

        return {"count": len(results), "permissions": results}


@permission_blueprint.route("/role/<role_id>", methods=['GET'])
@token_required
def permissions_for_role(role_id):
    try:
        role = verify_role(role_id)
        if not role:
            raise CustomError("Given role is not valid!.", 400)
        permissions = fetch_permissions_for_role(role_id)
        return {
            "count": len(permissions),
            "Permissions": [permission.format() for permission in permissions]
        }
    except CustomError as e:
        return {"message": 'Failed to Fetch permissions', "error": str(e.msg)}, e.status_code
    except Exception as e:
        logging.info(str(e))
        return {"message": "Unable to fetch permissions for given role"}, 500
