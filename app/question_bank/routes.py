import logging
import os
from datetime import date
from os.path import join, abspath

from flask import request, jsonify, Blueprint, make_response, Response
from marshmallow import ValidationError

from app.commons.custom_error import CustomError
from app.question_bank import question_req
from app.question_bank import service
import json
from collections import namedtuple
from werkzeug.utils import secure_filename

from app.question_bank.service import add_questions_from_file, get_question_list_for_designation, \
    generate_question_and_answer, generate_answer_for_ques
from app.tenant.tenant_header_check import check_tenant_user
from app.user.user_routes import token_required, get_user_and_tenant_from_token
from app.user.user_service import get_user_by_user_id

question_blueprint = Blueprint('question_blueprint', __name__)

UPLOAD_FOLDER = join('uploads', 'question_bank')
ROOT_DIR = abspath(os.curdir)
UPLOADS_PATH = join(ROOT_DIR, UPLOAD_FOLDER)


@question_blueprint.route("/", methods=["POST"])
@token_required
def add_question():
    if request.method == 'POST':
        user_id, tenant_id = get_user_and_tenant_from_token(request)
        request_data = request.get_json()
        print("request_data", request_data)
        schema = question_req.QuestionReq()
        try:
            # Validate request body against schema data types
            schema.load(request_data)
            question_data = json.loads(request.get_data(), object_hook=lambda d: namedtuple('X', d.keys())(*d.values()))
            question = service.add_question(question_data, tenant_id)
            return {"question_id": question["question_id"]}, 201
        except ValidationError as err:
            return jsonify(err.messages), 400
        except CustomError as e:
            return {"message": 'Failed to add question', "error": str(e.msg)}, e.status_code
        except Exception as ex:
            print(ex)
            return {"message": "unable to create question"}, 500


@question_blueprint.route("/candidate/<c_id>", methods=['GET'])
def get_question_for_candidate(c_id):
    question = service.get_question_for_candidate(c_id)
    return question


@question_blueprint.route("/<q_id>/clue", methods=['GET'])
def get_clues_for_question(q_id):
    return service.get_clues_for_question(q_id)
# @token_required


@question_blueprint.route("/<q_id>", methods=['GET'])
def get_question_by_question_id(q_id):
    question = service.get_question_by_question_id(q_id)
    return question


@question_blueprint.route("/candidate/<c_id>/interview/<i_id>", methods=['GET'])
def get_question_for_candidate_from_interview(c_id, i_id):
    question = service.get_question_for_candidate_interview(c_id, i_id)
    if not question:
        return {"message": "no questions found for candidate"}, 404
    return question


@question_blueprint.route("/upload", methods=['POST'])
@token_required
@check_tenant_user
def upload_questions():
    user_id, tenant_id = get_user_and_tenant_from_token(request)
    if request.method == 'POST':
        request_data = request.form.to_dict()

        file = request.files.get('file')
        designation = request_data['designation']
        user = get_user_by_user_id(user_id)
        if not file:
            return make_response('file is required', 403)
        if not designation:
            return make_response('Designation is required', 403)

        data_filename = secure_filename(file.filename)
        new_path = join(UPLOADS_PATH, str(date.today()))
        file_path = join(new_path, user['email'] + '_' + data_filename)
        if not os.path.isdir(new_path):
            os.makedirs(new_path)
        file.save(file_path)
        add_questions_from_file(file_path, designation, user_id, tenant_id)
        return Response(response="File Uploaded", status=201)


@question_blueprint.route("", methods=['GET'])
@token_required
def list_questions_for_designation():
    user_id, tenant_id = get_user_and_tenant_from_token(request)
    return get_question_list_for_designation(request, tenant_id)


@question_blueprint.route("/generate", methods=['POST'])
@token_required
def generate_question():
    try:
        request_data = request.get_json()
        logging.info("Request to generate question. Request_data: ", request_data)
        schema = question_req.QuestionGenerateDTO()
        schema.load(request_data)
        question_generate_data = json.loads(request.get_data(), object_hook=lambda d: namedtuple('X', d.keys())(*d.values()))
        return generate_question_and_answer(question_generate_data)
    except CustomError as e:
        logging.error(e)
        return {"message": 'Failed to generate question', "error": str(e.msg)}, e.status_code
    except Exception as ex:
        logging.error(ex)
        return {"message": "unable to create question"}, 500


@question_blueprint.route("/generate-answer", methods=['POST'])
@token_required
def generate_answer():
    try:
        request_data = request.get_json()
        logging.info("Request to generate answer. Request_data: ", request_data)
        schema = question_req.AnswerGenerateDTO()
        schema.load(request_data)
        answer_generate_data = json.loads(request.get_data(), object_hook=lambda d: namedtuple('X', d.keys())(*d.values()))
        return generate_answer_for_ques(answer_generate_data), 200
    except ValidationError as err:
        # Return a nice message if validation fails
        return jsonify(err.messages), 400
    except CustomError as e:
        logging.error(e)
        return {"message": 'Failed to generate answer', "error": str(e.msg)}, e.status_code
    except Exception as ex:
        logging.error(ex)
        return {"message": "unable to generate answer"}, 500
