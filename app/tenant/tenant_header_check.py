from functools import wraps

import jwt
from flask import request, jsonify
from datetime import datetime
from functools import wraps
from app.commons.custom_error import CustomError
from app.tenant.tenant_service import tenant_exist_check_by_id, check_tenant_user_exist
from app.user import user_routes as user_routes
from app.user.user_service import user_exists_check
import app.commons.config as config



def check_tenant_user(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        try:
            user_id, tenant_id = user_routes.get_user_and_tenant_from_token(request)
            if not tenant_exist_check_by_id(tenant_id):
                raise CustomError('Invalid Tenant')
            check_tenant_user_exist(user_id, None, tenant_id)
        except CustomError as e:
            return jsonify({
                'message': e.msg
            }), 403
        return f(*args, **kwargs)

    return decorated


def is_super_user(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        if 'Authorization' in request.headers:
            token = request.headers['Authorization']
        if not token:
            return jsonify({'message': 'Token is missing !!'}), 403

        try:
            payload = jwt.decode(token, "ai_recruitment_ideas2it", algorithms=['HS256'])
            if 'exp' in payload and datetime.utcnow() > datetime.fromtimestamp(payload['exp']):
                raise jwt.ExpiredSignatureError('Token Expired')
            email = payload['email']
            if email != config.RECRUITMENT_ADMIN_EMAIL:
                return jsonify({'message': 'Not Authorized!!'}), 401
        except jwt.ExpiredSignatureError as e:
            return {'error': 'Token has expired !!'}, 403
        except jwt.InvalidTokenError as e:
            return {'error': 'Token is invalid !!'}, 403
        return f(*args, **kwargs)

    return decorated
