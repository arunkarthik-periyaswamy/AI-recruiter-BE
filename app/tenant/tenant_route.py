import json
from collections import namedtuple

from flask import request, jsonify, Blueprint
from marshmallow import ValidationError

from app.tenant import tenant_service, tenant_req
from app.tenant.tenant_header_check import is_super_user

tenant_blueprint = Blueprint('tenant_blueprint', __name__)


@tenant_blueprint.route("/", methods=['POST'])
# Anyone can create their own account.
# @is_super_user
def create_tenant():
    if request.method == 'POST':
        request_data = request.get_json()
        tenant_schema = tenant_req.TenantReq()
        try:
            # Validate request body against role_schema data types
            tenant_schema.load(request_data)
            tenant_req_data = json.loads(request.get_data(), object_hook=lambda d: namedtuple('X', d.keys())(*d.values()))
            return tenant_service.create_tenant(tenant_req_data)
        except ValidationError as err:
            # Return a nice message if validation fails
            return jsonify(err.messages), 400
