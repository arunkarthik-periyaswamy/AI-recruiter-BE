from flask import Blueprint, jsonify, request

from app.ai_generator.service import generate_response
from app.settings.decorators import public_endpoint

ai_blueprint = Blueprint('ai_blueprint', __name__)


@ai_blueprint.route('/')
@public_endpoint
def home():
    return 'Welcome to AI Generator Service'


@ai_blueprint.route('/generate', methods=['POST'])
def generate():
    if request.method == 'POST':

        question = request.get_json().get('question')
        if question:
            resp = generate_response(question)
            return jsonify({'response': resp}), 200

        else:
            return jsonify({'response': 'Provide question'}), 400
