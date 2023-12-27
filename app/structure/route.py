from flask import Blueprint, request

from app.commons.custom_error import CustomError
from app.structure.service import get_domains_and_subdomains_by_designation
from app.user.user_routes import get_user_and_tenant_from_token

structure_blueprint = Blueprint('structure_blueprint', __name__)


@structure_blueprint.route("/designation/<designation_id>", methods=['GET'])
def get_domains_and_subdomains(designation_id):
    try:
        # Check for the designation id is digit or not
        if not designation_id.isdigit():
            raise CustomError("Designation id missing!.", 400)
        
        user_id, tenant_id = get_user_and_tenant_from_token(request)
        return get_domains_and_subdomains_by_designation(tenant_id, designation_id)
    except CustomError as e:
        return {"message": str(e), "error": "Failed to get the domains and subdomains."}, e.status_code
    except Exception as e:
        return {"message": "Unable to continue!.", "error": str(e)}, 500
