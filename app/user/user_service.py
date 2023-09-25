from flask import jsonify

from app.designation.designation import Designation
from app.roles.role_service import get_role_id_by_name
from app.tenant.tenant_model import TenantUser
from app.tenant.tenant_service import add_tenant_user
from app.user.model import User, UserDesignation
from app import db
from werkzeug.security import generate_password_hash, check_password_hash


def create_user(first_name, last_name, email, password, tenant, role=None):
    try:
        role = get_role_id_by_name(role)
        user = User(
            first_name=first_name,
            last_name=last_name,
            email=email,
            password=generate_password_hash(password),
            role_id=role
        )
        # insert user
        db.session.add(user)
        db.session.flush()
        add_tenant_user(tenant, user.user_id)
        db.session.commit()
        return user
    except Exception as e:
        return jsonify({'message': 'Exception occurred while adding user !!'}), 500
    finally:
        db.session.close()


def add_designation(user_id, designation_name):
    designation = Designation.query.filter(
        db.and_(Designation.name == designation_name)).first()
    user_designation = UserDesignation(user_id=user_id, dsg_id=designation.dsg_id)
    db.session.add(user_designation)
    db.session.commit()
    return user_designation.dsg_id


def check_user_has_designation(user, designation_name):
    designation = Designation.query.filter(
        db.and_(Designation.name == designation_name)).first()

    user_designation = UserDesignation.query.filter_by(
        user_id=user.user_id, dsg_id=designation.dsg_id).first()
    if not user_designation:
        user_designation = UserDesignation(user_id=user.user_id, dsg_id=designation.dsg_id)
        db.session.add(designation)
        db.session.commit()
        return user_designation.dsg_id
    elif user_designation:
        return user_designation.dsg_id
    else:
        return jsonify({'message': 'User doesnt has permission to add question for given Designation !!'}), 403


def update_user_token(user, token):
    user.jwt_token = token
    db.session.commit()


def user_exists_check(user_id):
    db.session.begin()
    exists = User.query.filter(
        db.and_(User.user_id == user_id)).first() is not None
    db.session.close()
    return exists


def get_user_by_user_id(user_id):
    try:
        db.session.begin()
        user = User.query.filter(
            db.and_(User.user_id == user_id)).first()
        if user:
            result = {
                'user_id': user.user_id,
                'first_name': user.first_name,
                'last_name': user.last_name,
                'email': user.email,
            }
            return result
        else:
            return None
    except Exception as e:
        raise e
    finally:
        db.session.close()


def get_user_list(tenant_id):
    try:
        return db.session.query(User) \
            .select_from(User) \
            .join(TenantUser, TenantUser.user_id == User.user_id) \
            .filter(TenantUser.tenant_id == tenant_id).all()
    except Exception as e:
        raise e
    finally:
        db.session.close()
