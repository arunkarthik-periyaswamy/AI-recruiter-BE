import logging

from app import db
from app.permission.permission import Permission
from app.roles.role import RolePermission


def save_permission(permission_req, user_id):
    try:
        permission = Permission.query.filter(
            db.and_(Permission.name == permission_req.name)).first()

        if permission:
            logging.error(f"Permission:{permission_req.name} Permission already Exist")
            raise Exception('Permission already Exist')
        permission = Permission(name=permission_req.name,
                                request_method=permission_req.request_method,
                                path_url=permission_req.path_url,
                                created_by=user_id)

        db.session.add(permission)
        db.session.commit()
        db.session.flush()
        db.session.refresh(permission)
        return {"name": permission.name, "id": permission.id}
    except Exception as e:
        raise Exception('Unable to add Permission')
    finally:
        db.session.close()


def get_all_permission():
    try:
        db.session.begin()
        return Permission.query.all()
    except Exception as e:
        raise e
    finally:
        db.session.close()


def get_permissions_by_name(permission_names):
    try:
        return Permission.query.filter(Permission.name.in_(permission_names)).all()
    except Exception as e:
        raise e
    finally:
        db.session.close()


def get_permission_by_id(permission_id):
    try:
        return Permission.query.get(permission_id)
    except Exception as e:
        raise e
    finally:
        db.session.close()


def fetch_permissions_for_role(role_id):
    try:
        return db.session.query(Permission) \
                .select_from(Permission) \
                .join(RolePermission, RolePermission.permission_id == Permission.id) \
                .filter(RolePermission.role_id == role_id).all()
    except Exception as e:
        raise e
    finally:
        db.session.close()
