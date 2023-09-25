import uuid

from flask import jsonify
from sqlalchemy.exc import IntegrityError
from werkzeug.security import generate_password_hash

from app import db, logger
from app.commons.custom_error import CustomError
from app.roles.constant import ROLE_ADMIN
from app.tenant.tenant_model import Tenant, TenantUser
from app.user.model import User


def create_tenant(tenant_req):
    tenant_name = tenant_req.name
    try:
        if tenant_exist_check(tenant_name):
            raise CustomError("Tenant already exists!.", 400)
        tenant = Tenant(tenant_id=uuid.uuid1(), name=tenant_name)
        db.session.add(tenant)
        create_admin_user_for_tenant(tenant_req.admin_first_name,
                                     tenant_req.admin_last_name,
                                     tenant_req.email,
                                     tenant_req.password,
                                     tenant)
        db.session.commit()
        return {'tenant_id': tenant.tenant_id, 'name': tenant_name, 'tenant_admin': tenant_req.email}, 201
    except IntegrityError as ee:
        db.session.rollback()
        if "23505" == ee.orig.pgcode:
            return {'message': 'Tenant already exists {}'.format(tenant_name)}, 400
    except CustomError as ce:
        return {"message": 'Failed', "error": ce.msg}, ce.status_code
    except Exception as e:
        logger.info('Error occurred while creating tenant={}'.format(e))
        return {'message': 'error occurred while creating tenant', 'Error': str(e)}, 500
    finally:
        db.session.close()


def tenant_exist_check(tenant_name):
    try:
        exists = Tenant.query.filter(
            db.and_(Tenant.name == tenant_name)).first() is not None
        return exists
    except Exception as e:
        logger.info('Error occurred while creating tenant={}'.format(e))
        return {'message': 'error occurred while fetching tenant'}, 500
    finally:
        db.session.close()


def tenant_exist_check_by_id(tenant_id):
    try:
        exists = Tenant.query.filter(
            db.and_(Tenant.tenant_id == tenant_id)).first() is not None
        return exists
    except Exception as e:
        logger.info('Error occurred while creating tenant={}'.format(e))
        return {'message': 'error occurred while fetching tenant'}, 500
    finally:
        db.session.close()


def get_tenant_by_name(tenant_name):
    try:
        tenant = Tenant.query.filter(
            db.and_(Tenant.name == tenant_name)).first()
        return tenant
    except Exception as e:
        logger.info('Error occurred while fetching tenant={}'.format(e))
        return {'message': 'error occurred while fetching tenant'}, 500
    finally:
        db.session.close()


def check_tenant_user_exist(user_id, tenant_name=None, t_id=None):
    try:

        if tenant_name:
            tenant = get_tenant_by_name(tenant_name)
            tenant_id = tenant.tenant_id
        elif t_id:
            tenant_id = t_id
        tenant_user = TenantUser.query.filter(
            db.and_(TenantUser.user_id == user_id, TenantUser.tenant_id == tenant_id)).first()
        if tenant_user is None:
            raise CustomError('User doesnt exist for the given tenant', 403)
    except CustomError as e:
        logger.info('Error occurred while fetching tenant user={}'.format(e))
        raise e
    finally:
        db.session.close()


def add_tenant_user(tenant, user_id):
    try:
        tenant_user = TenantUser(tenant_id=tenant.tenant_id, user_id=user_id)
        db.session.add(tenant_user)
    except Exception as e:
        logger.info('Error occurred while creating tenant={}'.format(e))
        raise e


def create_admin_user_for_tenant(first_name, last_name, email, password, tenant):
    try:
        user = User.query.filter(User.email == email).first()
        if user:
            raise CustomError("User already exists!.", 403)
        user = User(
            first_name=first_name,
            last_name=last_name,
            email=email,
            password=generate_password_hash(password),
            role_id=ROLE_ADMIN.id
        )
        # insert user
        db.session.add(user)
        db.session.flush()
        add_tenant_user(tenant, user.user_id)
        return user
    except CustomError as ce:
        raise ce
    except Exception as e:
        raise e

