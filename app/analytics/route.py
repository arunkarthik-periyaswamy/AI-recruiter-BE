from flask import Blueprint, request

from app.analytics.service import fetch_analytics
from app.commons.custom_error import CustomError
from app.user.user_routes import get_user_and_tenant_from_token

analytics_blueprint = Blueprint('analytics_blueprint', __name__)


@analytics_blueprint.route("", methods=['GET'])
def get_analytics():
    try:
        user_id, tenant_id = get_user_and_tenant_from_token(request)
        designation_id = request.args.get("dsg_id")
        return fetch_analytics(tenant_id, designation_id)
    except CustomError as ce:
        return {"message": 'Failed to fetch analytics data', "error": str(ce.msg)}, ce.status_code
    except Exception as e:
        return {"message": 'Failed to fetch analytics data', "error": str(e)}, 500


