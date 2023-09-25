from flask import request, Blueprint, Response

from app.commons.custom_error import CustomError
from app.configurations.configuration_service import get_configurations, create_config, update_config
from app.tenant.tenant_header_check import check_tenant_user
from app.user.user_routes import token_required, get_user_and_tenant_from_token

configurations_blueprint = Blueprint('configurations_blueprint', __name__)


@configurations_blueprint.route("/", methods=['GET'])
@token_required
def get_configuration():
    return get_configurations()


@configurations_blueprint.route("/", methods=['POST', 'PUT'])
@token_required
@check_tenant_user
def create_or_update_config():
    request_data = request.get_json()
    user_id, tenant_id = get_user_and_tenant_from_token(request)
    if request.method == 'POST':
        try:
            create_config(request_data, tenant_id)
            return Response(response='CREATED', status=200)
        except CustomError as e:
            return Response(response=e.msg, status=e.status_code)
    if request.method == 'PUT':
        try:
            update_config(request_data, tenant_id)
            return Response(response='UPDATED', status=200)
        except CustomError as e:
            return Response(response=e.msg, status=e.status_code)
