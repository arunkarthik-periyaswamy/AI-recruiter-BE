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
from app.evaluation.service import candidate_interview_evaluation_report, get_all_candidate_status
from app.tenant.tenant_header_check import check_tenant_user
from app.user.user_routes import token_required, get_user_and_tenant_from_token

evaluations_blueprint = Blueprint('evaluations_blueprint', __name__)


@evaluations_blueprint.route("/<c_id>/candidate/<i_id>/interview/download", methods=['GET'])
@token_required
@check_tenant_user
def candidate_evaluation_download_report(c_id, i_id):
    args = request.args
    email = args.get('email')
    if not email:
        return make_response('Email is required', 403)
    content, filename = get_candidate_report_for_download(c_id, email, i_id)
    return Response(content, mimetype="text/csv", headers={"Content-disposition":"attachment; filename="+filename})


@evaluations_blueprint.route("/candidate/status", methods=['GET'])
@token_required
@check_tenant_user
def candidate_evaluation_status():
    user_id, tenant_id = get_user_and_tenant_from_token(request)
    all_candidate_status = get_all_candidate_status(tenant_id)
    return all_candidate_status, 200


@evaluations_blueprint.route("/<c_id>/candidate/<i_id>/interview/generate", methods=['GET'])
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


@evaluations_blueprint.route("/score", methods=['POST'])
def get_ai_evaluation_for_qa():
    if request.method == 'POST':
        request_data = request.get_json()
        question = request_data['question']
        answer = request_data['answer']
        evaluated_answer, score, accuracy = evaluations_service.evaluate_question_answer(question, answer)
        result = {'question': question,
                  'user_answer': answer,
                  'reason': evaluated_answer,
                  'grade': score,
                  'accuracy': accuracy}

        return result, 200


@evaluations_blueprint.route("/answer", methods=['POST', 'PATCH'])
def add_evaluations():
    request_data = request.get_json()
    schema = evaluations_req.EvaluatorReq()
    try:
        # Validate request body against schema data types
        schema.load(request_data)
        evaluation_data = json.loads(request.get_data(),
                                     object_hook=lambda d: namedtuple('X', d.keys())(*d.values()))
        if request.method == 'POST':
            return evaluations_service.add_evaluation(evaluation_data), 201
        if request.method == 'PATCH':
            return evaluations_service.update_evaluation(evaluation_data), 200
    except ValidationError as err:
        return jsonify(err.messages), 400
    except Exception as ex:
        print(ex)
        return {"message": "unable to add data on table"}, 500


@evaluations_blueprint.route("/update-answer", methods=['PATCH'])
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
