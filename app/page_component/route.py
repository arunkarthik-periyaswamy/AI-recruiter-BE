import json
import logging
from collections import namedtuple

from flask import Blueprint, request, jsonify
from marshmallow import ValidationError

from app.commons.custom_error import CustomError
from app.page_component import assign_components_req
from app.page_component.service import save_page_component, fetch_all_page_components, fetch_page_components_for_role, \
    assign_page_components
from app.roles.role_service import verify_role
from app.user.user_routes import token_required, get_user_and_tenant_from_token

page_component_blueprint = Blueprint('page_component_blueprint', __name__)


@page_component_blueprint.route("/", methods=['POST'])
@token_required
def create_page_component():
    try:
        logging.info("Request to create Page component")
        user_id, tenant_id = get_user_and_tenant_from_token(request)
        return save_page_component(request, user_id)
    except CustomError as e:
        logging.error(e)
        return {"message": 'Failed to create page component', "error": str(e.msg)}, e.status_code
    except Exception as ex:
        logging.error(ex)
        return {"message": "unable to create page component"}, 500


@page_component_blueprint.route("", methods=['GET'])
@token_required
def get_all_page_components():
    try:
        logging.info("Request to fetch all page components")
        page_components = fetch_all_page_components()
        return {
            "count": len(page_components),
            "page_components": [page_component.format() for page_component in page_components]
        }
    except Exception as ex:
        logging.error(ex)
        return {"message": "Unable to fetch page components", "error": str(ex)}, 500


@page_component_blueprint.route("/role/<role_id>", methods=['GET'])
@token_required
def get_page_component_by_role(role_id):
    try:
        role = verify_role(role_id)
        if not role:
            raise CustomError("Given role is not valid!.", 400)
        page_components = fetch_page_components_for_role(role_id)
        return {
            "count": len(page_components),
            "page_components": [page_component.format() for page_component in page_components]
        }
    except CustomError as e:
        return {"message": 'Failed to fetch page components for role', "error": str(e.msg)}, e.status_code
    except Exception as ex:
        return {"message": "unable to fetch page components", "error": str(ex)}, 500


@page_component_blueprint.route("/role/<role_id>", methods=['PUT'])
@token_required
def assign_page_component_for_role(role_id):
    try:
        role = verify_role(role_id)
        if not role:
            raise CustomError("Given role is not valid!.", 400)
        request_data = request.get_json()
        page_comp_schema = assign_components_req.PageComponentReq()
        try:
            # Validate request body against role_schema data types
            page_comp_schema.load(request_data)
            role_page_comp_data = json.loads(request.get_data(), object_hook=lambda d: namedtuple('X', d.keys())(*d.values()))
            return assign_page_components(role_page_comp_data, role_id)
        except ValidationError as err:
            # Return a nice message if validation fails
            return jsonify(err.messages), 400
    except CustomError as e:
        return {"message": 'Failed to assign page components for role', "error": str(e.msg)}, e.status_code
    except Exception as ex:
        return {"message": "unable to update page components for role", "error": str(ex)}, 500
