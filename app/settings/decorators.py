"""
Authentication layer
Implemented the basic auth based on the User and Pass word set in .env
"""

from functools import wraps

from flask import request, jsonify

from app.settings.config import Config


def public_endpoint(f):
    f._public_endpoint = True
    return f


def interactive_auth_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        # GET THE BASIC AUTH FROM THE REQUEST
        auth = request.authorization

        if auth is None:
            return 'Unauthorized', 401, {'WWW-Authenticate': 'Basic realm="Login Required"'}

        # CHECK THAT THE BASIC AUTH USERNAME AND PASSWORD MATCHES THE ONES FROM THE FLASK CONFIG
        if auth.username != Config.USER or auth.password != Config.PASS:
            # AUTH FAILED, RETURN 401 UNAUTHORIZED
            return jsonify(code=401, message='Unauthorized'), 401

        return f(*args, **kwargs)

    return decorated_function
