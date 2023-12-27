import logging
from app.commons.custom_error import CustomError
from flask import Blueprint, request, flash, redirect

from app.resume_parser.service import upload_file
resume_parser_blueprint = Blueprint('resume_parser_blueprint', __name__)


@resume_parser_blueprint.route('/', methods=['POST'])
def generate():
    try:
        return upload_file(request)
    except CustomError as e:
        logging.error(e)
        return {"message": 'Failed to parse resume', "error": str(e.msg)}, e.status_code
    except Exception as e:
        logging.error(e)
        return {"message": "unable to parse the resume", "error": str(e.msg)}, 500
   
