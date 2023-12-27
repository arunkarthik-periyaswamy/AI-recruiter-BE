""""
Routes to handle the configurations of user module level
route and resource mapping
"""
import json
from collections import namedtuple
from datetime import datetime, timedelta
from functools import wraps

import jwt
from flask import request, jsonify, Blueprint, make_response
from werkzeug.security import check_password_hash

from app import db, logger
from app.commons import config
from app.commons.custom_error import CustomError
from app.designation.designation_service import fetch_designations_for_user
from app.page_component.service import fetch_page_components_for_role
from app.question_bank.service import get_question_bank_designation_for_user
from app.roles.role_service import role_exists_check, get_role_by_id, check_role_permission
from app.settings.decorators import public_endpoint
from app.tenant.tenant_header_check import check_tenant_user
from app.tenant.tenant_service import get_tenant_by_name, tenant_exist_check, check_tenant_user_exist, \
    fetch_tenant_by_id
from app.user import user_req
from app.user.model import User
from app.user.user_service import get_user_by_user_id, \
    user_exists_check, create_user, get_user_list, get_questioner_list
from app.email.service import send_invite_for_tool_users

user_blueprint = Blueprint('user_blueprint', __name__)


@user_blueprint.route("/hello-world")
@public_endpoint
def hello_world():
    return "Hello World"


@user_blueprint.route('/<user_id>', methods=['GET'])
def get_user_info(user_id):
    user = get_user_by_user_id(user_id)
    if user:
        return user
    return jsonify({'message': 'User Doesnt exist for the given id !!'}), 404


@user_blueprint.route('/login', methods=['POST'])
def login():
    try:
        if 'X-tenant-name' in request.headers:
            tenant_name = request.headers['X-tenant-name']
        else:
            return jsonify({'message': 'Tenant Header is missing !!'}), 403
        request_data = request.get_json()
        schema = user_req.UserReq()
        schema.load(request_data)
        user_data = json.loads(request.get_data(), object_hook=lambda d: namedtuple('X', d.keys())(*d.values()))

        if not user_data.email and not user_data.password:
            return make_response('Could not verify', 401)

        user = User.query.filter_by(email=user_data.email).first()
        if not user:
            raise CustomError(f'User does not exit for email: {user_data.email}.', 401)
        if not check_password_hash(user.password, user_data.password):
            raise CustomError('Could not verify', 401)

        try:
            check_tenant_user(user.user_id, tenant_name)
        except Exception as e:
            return jsonify({
                'message': e.msg
            }), 403
        tenant = get_tenant_by_name(tenant_name)
        role = get_role_by_id(user.role_id)
        token = jwt.encode({
            'user_id': user.user_id,
            'exp': datetime.utcnow() + timedelta(minutes=60),
            'email': user.email,
            'tenant_id': str(tenant.tenant_id),
            'user_role': role.name if role else None,
            'user_role_id': user.role_id
        }, 'ai_recruitment_ideas2it')

        designations = get_question_bank_designation_for_user(user.user_id)
        return make_response(jsonify({'token': token,
                                      'user_id': user.user_id,
                                      'email': user.email,
                                      'first_name': user.first_name,
                                      'last_name': user.last_name,
                                      'designations': designations,
                                      'user_role': role.name if role else None,
                                      'user_role_id': user.role_id
                                      }),
                             201)
    except CustomError as e:
        logger.info(r'exception while user logging in {}'.format(e.msg))
        return make_response(jsonify({'error': 'Invalid Credentials'})), 401
    except Exception as e:
        logger.info(r'exception while user logging in {}'.format(e))
        return make_response(jsonify({'error': 'exception while user logging in'})), 500
    finally:
        db.session.close()


def check_tenant_user(user_id, tenant_name=None):
    try:
        if not tenant_exist_check(tenant_name):
            raise CustomError('Invalid Tenant', 403)
        check_tenant_user_exist(user_id, tenant_name, None)
    except CustomError as e:
        raise e


def token_required(f):
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
            user_id = payload['user_id']
            if not user_exists_check(user_id):
                raise jwt.InvalidTokenError('Invalid Token')
            path = request.path.replace(config.API_VERSION, "", 1).strip("/")
            request_method = request.method
            if not check_role_permission(payload.get("user_role_id"), path, request_method):
                return {'error': f'Not Authorized to access this resource , path= {path}'}, 403
        except jwt.ExpiredSignatureError as e:
            return {'error': 'Token has expired !!'}, 403
        except jwt.InvalidTokenError as e:
            return {'error': 'Token is invalid !!'}, 403
        return f(*args, **kwargs)

    return decorated


def get_user_and_tenant_from_token(request_obj):
    token = request_obj.headers['Authorization']
    payload = jwt.decode(token, "ai_recruitment_ideas2it", algorithms=['HS256'])
    return payload['user_id'], payload['tenant_id']


@user_blueprint.route('/signup', methods=['POST'])
@token_required
def signup():
    try:
        if 'X-tenant-name' in request.headers:
            tenant_name = request.headers['X-tenant-name']
        else:
            return jsonify({'message': 'Tenant Header is missing !!'}), 403

        tenant = get_tenant_by_name(tenant_name)
        if not tenant:
            return jsonify({'message': 'Tenant doesnot Exist !!'}), 403

        data = request.get_json()

        first_name, email, last_name, role = data.get('first_name'), data.get('email'), data.get('last_name'), data.get("role")
        password = data.get('password')

        user = User.query.filter(
            db.and_(User.email == email)).first()

        if not user:
            if not role_exists_check(role):
                raise CustomError("Given role is not valid!.", 400)
            user = create_user(first_name, last_name, email, password, tenant, role)
            # Need to add email code here
            if role in ["Admin","Questioner manager","Questioner"]:
                send_invite_for_tool_users(first_name, email, password, tenant, role)
            return user.format(), 200
        else:
            return jsonify({'message': 'User already Exist !!'}), 403
    except CustomError as ce:
        db.session.rollback()
        return {"message": 'Failed to create user', "error": str(ce.msg)}, ce.status_code
    except Exception as e:
        db.session.rollback()
        return {"message": 'Failed to create user', "error": str(e)}, 500
    finally:
        db.session.close()


@user_blueprint.route('/status', methods=['GET'])
def logged_in_user_status():
    token = request.headers.get('Authorization')  # Get JWT token from request headers
    if not token:
        return {'error': 'Authorization token not found'}, 403
    try:
        payload = jwt.decode(token, "ai_recruitment_ideas2it", algorithms=['HS256'])
        user_id = payload['user_id']
        tenant_id = payload.get('tenant_id')
        if not user_exists_check(user_id):
            raise jwt.InvalidTokenError('Invalid Token')
        if 'exp' in payload and datetime.utcnow() > datetime.fromtimestamp(payload['exp']):
            raise jwt.ExpiredSignatureError('Token Expired')
        user = get_user_by_user_id(user_id)
        designations = fetch_designations_for_user(user, tenant_id)
        tenant = fetch_tenant_by_id(tenant_id)
        page_components = fetch_page_components_for_role(user['role_id'])
        return make_response(jsonify({'token': token,
                                      'user_id': user['user_id'],
                                      'email': user['email'],
                                      'first_name': user['first_name'],
                                      'last_name': user['last_name'],
                                      'tenant_name': tenant.name,
                                      'designations': designations,
                                      'page_permissions': [page_component.name for page_component in page_components]
                                      }), 200)
    except jwt.ExpiredSignatureError:
        return {'error': 'Token has expired'}, 403
    except jwt.InvalidTokenError:
        return {'error': 'Invalid token'}, 403
    except CustomError as ce:
        return {"message": 'Failed to fetch user status', "error": str(ce.msg)}, ce.status_code
    except Exception as e:
        return {"message": 'Failed', "error": str(e)}, 500
    finally:
        db.session.close()


@user_blueprint.route('', methods=['GET'])
@token_required
def user_list():
    try:
        user_id, tenant_id = get_user_and_tenant_from_token(request)
        users = get_user_list(tenant_id)
        return {
            "count": len(users),
            "users": [user.format() for user in users]
        }
    except Exception as e:
        return {"message": 'Failed', "error": str(e)}, 500


@user_blueprint.route('/questioner', methods=['GET'])
@token_required
def questioner_list():
    try:
        user_id, tenant_id = get_user_and_tenant_from_token(request)
        users = get_questioner_list(tenant_id)
        return {
            "count": len(users),
            "users": [user.format() for user in users]
        }
    except Exception as e:
        return {"message": 'Failed', "error": str(e)}, 500
