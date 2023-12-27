import json
from collections import namedtuple
from threading import Thread

from app import logger
from app.evaluation.service import get_candidate_report_for_download
from flask import request, jsonify, Blueprint, copy_current_request_context, Response, make_response
from marshmallow import ValidationError
from app.candidate.candidate_service import get_candidate_by_id
from app.commons.custom_error import CustomError
from app.evaluation import evaluations_req
from app.evaluation import service as evaluations_service
from app.evaluation.service import get_all_candidate_status
from app.tenant.tenant_header_check import check_tenant_user
from app.user.user_routes import token_required, get_user_and_tenant_from_token

from flask import Blueprint, request

from app.commons.custom_error import CustomError
from app.socratic.service import get_next_chat_interview , candidate_interview_evaluation_report, get_next_chat_demo

socratic_blueprint = Blueprint('socratic_blueprint', __name__)


@socratic_blueprint.route("/chat/", methods=['POST'])
def socratic_chat():
    try:
        request_body = request.get_json()
        print('|||||||||||||||||||||||||||||||||', request_body)
        chat = request_body.get("chat")

        if not chat:
            raise CustomError("Chat not initiated!.", 400)

        return get_next_chat_demo(chat)

    except CustomError as e:
        return {"message": str(e), "error": "Failed to continue the chat."}, e.status_code
    except Exception as e:
        return {"message": "Unable to continue!.", "error": str(e)}, 500


@socratic_blueprint.route("/<c_id>/candidate/<i_id>/interview/generate", methods=['GET'])
def candidate_evaluation(c_id, i_id):
    @copy_current_request_context
    def report_generation_thread():
        candidate_evaluation_report_generation(c_id, i_id)

    Thread(target=report_generation_thread).start()
    return Response(response="Report Generation scheduled.", status=200)


def candidate_evaluation_report_generation(c_id, i_id):
    try:
        interview_candidate = get_candidate_by_id(c_id)
        if not interview_candidate:
            raise CustomError('Candidate does not exists', 404)
        candidate_interview_evaluation_report(c_id, i_id, interview_candidate)
        logger.info(r'Report generation completed for candidate {} and interview {}'.format(c_id, i_id))
    except CustomError as e:
        print(e)
        return {'message': 'error occurred',
                'error': str(e)}, e.status_code
    except Exception as e:
        print(e)
        return {'message': 'error occurred',
                'error': str(e)}


@socratic_blueprint.route("/update-answer", methods=['PATCH'])
def update_evaluations_with_candidate_answer():
    if request.method == 'PATCH':
        request_data = request.get_json()
        schema = evaluations_req.EvaluatorReq()
        try:
            # Validate request body against schema data types
            schema.load(request_data)
            evaluation_data = json.loads(request.get_data(),
                                         object_hook=lambda d: namedtuple('X', d.keys())(*d.values()))
            return evaluations_service.update_evaluation(evaluation_data), 201
        except ValidationError as err:
            return jsonify(err.messages), 400
        except Exception as ex:
            print(ex)
            return {"message": "unable to add data on table"}, 500
