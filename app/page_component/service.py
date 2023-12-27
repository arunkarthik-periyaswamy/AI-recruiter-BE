import logging

from sqlalchemy import func
from sqlalchemy.orm import aliased

from app import db
from app.commons.custom_error import CustomError
from app.page_component.model import PageComponent, RolePageComponent
from app.roles.role_service import get_role_by_id


def save_page_component(request, user_id):
    try:
        logging.info("Creating a new page component")
        component_name = request.args.get("page_component", '').lower()
        if not component_name:
            raise CustomError("Please provide the page component", 400)

        page_component = PageComponent.query.filter(
            func.replace(func.lower(PageComponent.name), " ", "") == component_name.replace(" ", "")).first()
        if page_component:
            raise CustomError(f"Page component {component_name} already exists!.", 403)

        page_component = PageComponent(name=component_name.upper(), created_by=user_id)
        db.session.add(page_component)
        db.session.commit()
        logging.info(f"Page component {component_name} created")
        return {"name": page_component.name, "id": page_component.id}, 200
    except CustomError as e:
        raise e
    finally:
        db.session.close()


def fetch_all_page_components():
    try:
        return PageComponent.query.all()
    except Exception as ex:
        raise ex
    finally:
        db.session.close()


def fetch_page_components_for_role(role_id):
    try:
        return db.session.query(PageComponent) \
                .select_from(PageComponent) \
                .join(RolePageComponent, RolePageComponent.page_component_id == PageComponent.id) \
                .filter(RolePageComponent.role_id == role_id).all()
    except Exception as e:
        raise e
    finally:
        db.session.close()


def assign_page_components(role_page_comp_data, role_id):
    try:
        role = get_role_by_id(role_id)
        # creating a join query to fetch existing page components for role
        rp_alias = aliased(RolePageComponent)
        p_alias = aliased(PageComponent)

        existing_role_page_comps = db.session.query(p_alias.id, p_alias.name) \
            .select_from(rp_alias) \
            .join(p_alias, rp_alias.page_component_id == p_alias.id) \
            .filter(rp_alias.role_id == role.id)
        existing_role_page_comps = {rp.name: rp.id for rp in existing_role_page_comps}

        # Creating newly selected page components for role , neglecting existing ones.
        new_page_comps = []
        for page_component in role_page_comp_data.page_components:
            if page_component not in existing_role_page_comps:
                new_page_comps.append(page_component)

        page_comps = get_page_comps_by_name(new_page_comps)
        for page_comp in page_comps:
            new_rp = RolePageComponent(role_id=role.id, page_component_id=page_comp.id)
            db.session.add(new_rp)
            db.session.flush()

        # Removing page components that's not in the selected list
        page_comps_to_be_deleted = set(existing_role_page_comps.keys()) - set(role_page_comp_data.page_components)
        for page_comp in page_comps_to_be_deleted:
            del_permission = RolePageComponent.query.filter(
                RolePageComponent.page_component_id == existing_role_page_comps[page_comp],
                RolePageComponent.role_id == role.id).first()
            db.session.delete(del_permission)
            db.session.flush()

        db.session.commit()

        return {"message": "Page components updated for given role!."}, 200
    except Exception as e:
        raise e
    finally:
        db.session.close()


def get_page_comps_by_name(page_comps):
    try:
        return PageComponent.query.filter(PageComponent.name.in_(page_comps)).all()
    except Exception as e:
        raise e
    finally:
        db.session.close()
