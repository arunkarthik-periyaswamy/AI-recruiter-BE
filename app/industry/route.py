import logging

from flask import Blueprint, request

from app.commons.custom_error import CustomError
from app.industry.service import save_industry, fetch_industries
from app.user.user_routes import token_required, get_user_and_tenant_from_token

industry_blueprint = Blueprint('industry_blueprint', __name__)


@industry_blueprint.route("/", methods=['POST'])
@token_required
def create_industry():
    try:
        user_id, tenant_id = get_user_and_tenant_from_token(request)
        logging.info("Request to create industry.")
        return save_industry(request, user_id)
    except CustomError as e:
        logging.error(e)
        return {"message": 'Failed to create industry', "error": str(e.msg)}, e.status_code
    except Exception as ex:
        logging.error(ex)
        return {"message": "unable to create industry"}, 500


@industry_blueprint.route("", methods=['GET'])
@token_required
def get_industries():
    try:
        logging.info("Request to fetch all industries")
        industries = fetch_industries()
        return [
            industry.format()
            for industry in industries
        ]
    except Exception as ex:
        logging.error(ex)
        return {"message": "Unable to fetch industries", "error": str(ex)}, 500
