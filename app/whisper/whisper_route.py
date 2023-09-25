import os
from datetime import date
from os.path import join, abspath

from flask import request, jsonify, Blueprint

import openai
from werkzeug.utils import secure_filename

from app.configurations.configuration_service import get_open_ai_key

whisper_blueprint = Blueprint('whisper_blueprint', __name__)

UPLOAD_FOLDER = join('uploads', 'whisper')
ROOT_DIR = abspath(os.curdir)
UPLOADS_PATH = join(ROOT_DIR, UPLOAD_FOLDER)


@whisper_blueprint.route('/speech_to_text', methods=["POST"])
def convert_speech_to_text():

    openai.api_key = get_open_ai_key()

    if not request.files or 'file' not in request.files:
        return jsonify(code=404, message='request data is missing - required - {file : audio.mp4}'), 404

    try:
        file_obj = request.files['file']
        data_filename = secure_filename(file_obj.filename)
        new_path = join(UPLOADS_PATH, str(date.today()))
        file_path = join(new_path + '_' + data_filename)
        if not os.path.isdir(new_path):
            os.makedirs(new_path)
        file_obj.save(file_path)

        # TODO need to read file size(20MB) from constants
        if os.path.getsize(file_path) > 20971520:
            return jsonify(code=400, message='the file type should be less than 20 mb'), 400

        audio_file = open(file_path, "rb")
        transcription = openai.Audio.transcribe("whisper-1", audio_file, language="en")
        audio_file.close()
        return {'response': {
            'text': transcription['text']}
        }
    except Exception as e:
        return jsonify(code=500, message=e.__class__.__name__), 500
