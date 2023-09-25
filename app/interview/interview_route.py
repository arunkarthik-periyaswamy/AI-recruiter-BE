import os
from os.path import join, abspath

from flask import request, Blueprint, make_response, Response

from app.commons.constants import INTERVIEW_STATUS
from app.interview import interview_service
from app.tenant.tenant_header_check import check_tenant_user
from app.user.user_routes import token_required, get_user_and_tenant_from_token

interview_blueprint = Blueprint('interview_blueprint', __name__)
UPLOAD_FOLDER = join('uploads', 'question_bank')
ROOT_DIR = abspath(os.curdir)
UPLOADS_PATH = join(ROOT_DIR, UPLOAD_FOLDER)


@interview_blueprint.route("/begin", methods=['POST'])
@token_required
@check_tenant_user
def create_candidate_schedule_interview():
    if request.method == 'POST':
        request_data = request.form.to_dict()
        user_id, tenant_id = get_user_and_tenant_from_token(request)
        email_id = request_data['email']
        designation = request_data['designation']
        phone_number = request_data['phone_number']
        name = request_data['name']

        if not email_id:
            return make_response('Email Id is required', 403)

        if not designation:
            return make_response('Designation is required', 403)

        if not phone_number:
            return make_response('phone_number is required', 403)

        if not name:
            return make_response('name is required', 403)

        return interview_service.start_interview_for_candidate(designation, email_id, 1,
                                                               phone_number, name, 3, user_id)


@interview_blueprint.route("/<i_id>/info", methods=['GET'])
def get_interview_info(i_id):
    return interview_service.get_interview_by_id(i_id)


@interview_blueprint.route("/<i_id>", methods=['PATCH'])
def update_interview_status(i_id):
    try:

        args = request.args
        interview_status = args.get("status", default="", type=INTERVIEW_STATUS)
        interview_service.update_interview_status(i_id, interview_status.name)
        return Response(response='Updated', status=202)
    except AttributeError as e:
        print(e)
        return Response(response='In-valid status provided', status=400)
    except FileNotFoundError as e:
        print(e)
        return Response(response=str(e), status=404)
    except Exception as e:
        print(e)
        return Response(response=str(e), status=500)
