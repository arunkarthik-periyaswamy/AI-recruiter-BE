import logging

from sqlalchemy import func, text
from sqlalchemy.orm import aliased

from app import db
from app.commons.custom_error import CustomError
from app.permission.permission import Permission
from app.permission.permission_service import get_permissions_by_name, get_permission_by_id
from app.roles.role import Role, RolePermission


def role_exists_check(role):
    return Role.query.filter(
        db.and_(Role.name == role)).first() is not None


def get_role_id_by_name(role):
    role = Role.query.filter(
        db.and_(Role.name == role)).first()
    return role.id


def get_all_role():
    try:
        return Role.query.all()
    except Exception as e:
        raise e
    finally:
        db.session.close()


def add_role(role_req, user_id):
    try:
        role = Role.query.filter(Role.name == role_req.name).first()
        if not role:
            role = Role(name=role_req.name, created_by=user_id)
            db.session.add(role)
            db.session.flush()
            db.session.commit()
            db.session.refresh(role)

        if role_req.permissions:
            # creating a join query to fetch existing permissions for role
            rp_alias = aliased(RolePermission)
            p_alias = aliased(Permission)

            existing_role_permissions = db.session.query(p_alias.id, p_alias.name) \
                .select_from(rp_alias) \
                .join(p_alias, rp_alias.permission_id == p_alias.id) \
                .filter(rp_alias.role_id == role.id)
            existing_role_permissions = {rp.name: rp.id for rp in existing_role_permissions}

            new_permissions = []
            for role_permission in role_req.permissions:
                if role_permission not in existing_role_permissions:
                    new_permissions.append(role_permission)

            permissions = get_permissions_by_name(new_permissions)
            for permission in permissions:
                new_rp = RolePermission(role_id=role.id, permission_id=permission.id)
                db.session.add(new_rp)
                db.session.flush()

            permissions_to_be_deleted = set(existing_role_permissions.keys()) - set(role_req.permissions)
            for permission in permissions_to_be_deleted:
                del_permission = RolePermission.query.filter(
                    RolePermission.permission_id == existing_role_permissions[permission],
                    RolePermission.role_id == role.id).first()
                db.session.delete(del_permission)
                db.session.flush()

            db.session.commit()

        return {"name": role.name, "id": role.id}
    except Exception as e:
        raise e
    finally:
        db.session.close()


def get_role_by_id(role_id):
    try:
        return Role.query.get(role_id)
    except Exception as e:
        raise e
    finally:
        db.session.close()


def check_role_permission(role_id, path, request_method):
    try:
        in_query = f"""Select permission.id from permission where ('{path}' ~ permission.path_url ) and 
        permission.request_method='{request_method}' """

        return db.session.query(RolePermission)\
            .filter(RolePermission.permission_id.in_(text(in_query)) &
                    (RolePermission.role_id == role_id)).first() is not None
    except Exception as e:
        raise e
    finally:
        db.session.close()


def add_permission(role_id, permission_id):
    try:
        role = Role.query.filter(Role.id == role_id).first()
        if not role:
            raise CustomError("Given role is not valid", 400)
        permission = get_permission_by_id(permission_id)
        if not permission:
            raise CustomError("Given permission is not valid", 400)

        role_permission = RolePermission(role_id=role_id, permission_id=permission_id)
        print("DB saving.")
        db.session.add(role_permission)
        db.session.commit()
        return {"message": f"Successfully added permission {permission.name} to role {role.name}"}, 200
    except CustomError as ce:
        raise ce
    except Exception as e:
        raise e
    finally:
        db.session.close()


def verify_role(role_id):
    try:
        return Role.query.filter(Role.id == role_id).first()
    except Exception as e:
        raise e
    finally:
        db.session.close()
