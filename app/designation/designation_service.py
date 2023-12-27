import logging
from threading import Thread

import openai
from sqlalchemy import func
from sqlalchemy.orm import aliased

from app.commons.constants import EVAL_STATUS_CODE
from app.commons.custom_error import CustomError
from app.commons.db_constant import QUESTIONER_MANAGER, QUESTIONER
from app.configurations.configuration_service import get_open_ai_key
from app.designation.ai_domain_generate import generate_domains_for_industry
from app.designation.designation import Designation, TenantDesignation
from app import db
from app.domain.domain_service import get_domain_by_domain_names, create_and_map_domains_to_designation
from app.industry.service import check_industry_exists
from app.roles.role_service import get_roles, get_role_by_id
from app.tenant.tenant_service import verify_user_and_tenant
from app.user.model import UserDesignation
from app.user.user_service import fetch_questioner_list_for_designation, fetch_user_by_id


def add_designation(designation_data, tenant_id=None):
    try:
        db.session.begin()
        industry = check_industry_exists(designation_data.industry_id)
        if not industry:
            raise CustomError("Industry not valid!.", 403)
        designation_name = designation_data.name.lower()
        designation = Designation.query.filter(
            func.replace(func.lower(Designation.name), " ", "") == designation_name.replace(" ", "")).first()

        if designation:
            tenant_designation = TenantDesignation.query.filter(TenantDesignation.designation_id == designation.dsg_id,
                                                                TenantDesignation.tenant_id == tenant_id).first()
            if tenant_designation:
                logging.error(f"Designation:{designation_data} Designation already Exist")
                raise CustomError('Designation already Exist', 403)
        else:
            designation = Designation(name=designation_name.title(), tenant_id=tenant_id, industry_id=industry.id)
            db.session.add(designation)
            db.session.flush()
            db.session.refresh(designation)

            def domain_generation_thread():
                generate_domain_for_designation(designation.dsg_id, industry.name)

            Thread(target=domain_generation_thread).start()

        tenant_designation = TenantDesignation(tenant_id=tenant_id, designation_id=designation.dsg_id)
        db.session.add(tenant_designation)
        db.session.commit()
        return {"name": designation.name, "id": designation.dsg_id}, 200
    except CustomError as e:
        return {"message": 'Failed', "error": e.msg}, e.status_code
    except Exception as e:
        logging.error(e)
        return {"message": 'Failed', "error": str(e)}, 500
    finally:
        db.session.close()


def get_all_designation(tenant_id):
    try:
        db.session.begin()
        d_alias = aliased(Designation)
        td_alias = aliased(TenantDesignation)
        return db.session.query(d_alias).select_from(d_alias)\
            .join(td_alias, (td_alias.designation_id == d_alias.dsg_id) & (td_alias.tenant_id == tenant_id)) \
            .filter().all()
    except Exception as e:
        raise e
    finally:
        db.session.close()

def designation_exists_check(designation):
    db.session.begin()
    result = Designation.query.filter(
        db.and_(Designation.name == designation)).first() is not None
    db.session.close()
    return result


def get_designation_by_dsg_id(dsg_id):
    designation = Designation.query.filter(
        db.and_(Designation.dsg_id == dsg_id)).first()
    return designation


def fetch_designation_by_industry(industry_id, tenant_id):
    try:
        d_alias = aliased(Designation)
        td_alias = aliased(TenantDesignation)
        designations = db.session.query(d_alias).select_from(d_alias)\
            .join(td_alias, (td_alias.designation_id == d_alias.dsg_id) & (td_alias.tenant_id == tenant_id)) \
            .filter(d_alias.industry_id == industry_id).all()
        return [
            designation.format()
            for designation in designations
        ]
    except Exception as e:
        raise e
    finally:
        db.session.close()


def verify_designation(dsg_id, tenant_id):
    try:
        d_alias = aliased(Designation)
        td_alias = aliased(TenantDesignation)
        return db.session.query(d_alias).select_from(d_alias)\
            .join(td_alias, (td_alias.designation_id == d_alias.dsg_id) & (td_alias.tenant_id == tenant_id)) \
            .filter(d_alias.dsg_id == dsg_id).first() is not None
    except Exception as e:
        raise e
    finally:
        db.session.close()


def assign_user_to_designation(dsg_id, user_id, tenant_id):
    try:
        if not verify_designation(dsg_id, tenant_id):
            raise CustomError("Given designation does not exist for this tenant!.", 400)
        if not verify_user_and_tenant(user_id, tenant_id):
            raise CustomError("Given user is not under this organisation.", 400)

        db.session.begin()
        user_dsg = UserDesignation.query.filter(UserDesignation.user_id == user_id,
                                                UserDesignation.dsg_id == dsg_id).first()
        if user_dsg:
            raise CustomError("User already added", 400)
        user_designation = UserDesignation(dsg_id=dsg_id, user_id=user_id)
        db.session.add(user_designation)
        db.session.commit()
        return user_designation.format()
    except CustomError as e:
        raise e
    except Exception as e:
        raise e
    finally:
        db.session.close()


def fetch_designations_for_user(user, tenant_id):
    try:
        # For users with roles Questioner and Questioner Manager,
        # they can only access their assigned designations.
        if user.get("role_id") in (QUESTIONER_MANAGER.id, QUESTIONER.id):
            user_dsgs = UserDesignation.query.filter(UserDesignation.user_id == user.get("user_id")).all()
            user_dsg_ids = [user_dsg.dsg_id for user_dsg in user_dsgs]
            designations = Designation.query.filter(Designation.dsg_id.in_(user_dsg_ids)).all()
        else:
            designations = get_all_designation(tenant_id)
        return [{"id": designation.dsg_id,
                 "name": designation.name} for designation in designations]

    except Exception as e:
        raise e
    finally:
        db.session.close()


def fetch_questioners_for_designation(dsg_id, tenant_id):
    try:
        if not verify_designation(dsg_id, tenant_id):
            raise CustomError("Given designation does not exist under your tenant!.", 400)

        questioners = fetch_questioner_list_for_designation(dsg_id, tenant_id)
        role_ids = {questioner.role_id for questioner in questioners}
        roles = get_roles(role_ids)
        roles = {role.id: role.name for role in roles}
        return {"count": len(questioners),
                "questioners": [
                    {
                        "name": questioner.first_name+" "+questioner.last_name,
                        "user_id": questioner.user_id,
                        "role_name": roles.get(questioner.role_id),
                        "role_id": questioner.role_id
                    } for questioner in questioners
                ]
                }
    except CustomError as e:
        raise e
    except Exception as e:
        raise e
    finally:
        db.session.close()


def remove_questioner(dsg_id, user_id, current_user_id):
    try:
        user_dsg = UserDesignation.query.filter(UserDesignation.user_id == user_id,
                                                UserDesignation.dsg_id == dsg_id).first()
        if not user_dsg:
            raise CustomError("User is not assigned to this designation!.", 400)

        current_user = fetch_user_by_id(current_user_id)
        user_to_be_removed = fetch_user_by_id(user_id)
        user_role = get_role_by_id(user_to_be_removed.role_id)

        if current_user.role_id not in user_role.superior_roles:
            raise CustomError("Cannot remove superior roles. Please contact Admin!.", 400)

        db.session.delete(user_dsg)
        db.session.commit()
        return {"message": f"Questioner {user_id} removed from designation {dsg_id}"}
    except CustomError as e:
        raise e
    except Exception as e:
        raise e
    finally:
        db.session.close()


def generate_domain_for_designation(dsg_id, industry_name):
    try:
        logging.info("Generating Domains")
        openai.api_key = get_open_ai_key()
        domains = generate_domains_for_industry(industry_name)
        print(domains)
        domains = [domain.title() for domain in domains]
        existing_domains = get_domain_by_domain_names(domains)
        existing_domains = {domain.name: domain.d_id for domain in existing_domains}

        domains_to_be_created = set(domains) - existing_domains.keys()
        create_and_map_domains_to_designation(dsg_id, existing_domains, domains_to_be_created)
        print("Domains successfully created and mapped!.")
    except openai.error.RateLimitError as e:
        print(f"Rate limit exceeded....: {e}")
        raise CustomError(e, EVAL_STATUS_CODE.RATE_LIMIT_ERROR.value)
    except openai.error.APIError as e:
        print(f"API error occurred....: {e}")
        raise CustomError(e, EVAL_STATUS_CODE.API_ERROR.value)
    except openai.error.APIConnectionError as e:
        print(f"Connection error occurred: {e}")
        raise CustomError(e, EVAL_STATUS_CODE.API_CONNECTION_ERROR.value)
    except openai.error.ServiceUnavailableError as e:
        print(f"ServiceUnavailable error occurred: {e}")
        raise CustomError(e, EVAL_STATUS_CODE.SERVICE_UNAVAILABLE_ERROR.value)
    except openai.error.InvalidRequestError as e:
        print(f"InvalidRequestError error occurred: {e}")
        raise CustomError(e, EVAL_STATUS_CODE.INVALID_REQUEST_ERROR.value)
    except openai.error.Timeout as e:
        print(f"Timeout error occurred: {e}")
        raise CustomError(e, EVAL_STATUS_CODE.TIME_OUT_ERROR.value)
    except CustomError as e:
        print(f"Domain generation error occurred: {e.msg}")
        raise CustomError(e, EVAL_STATUS_CODE.EVALUATION_ERROR.value)
    except Exception as e:
        print(f"Domain generation error occurred: {e}")
        raise CustomError(e, EVAL_STATUS_CODE.EVALUATION_ERROR.value)


def fetch_designation_by_id(dsg_id, tenant_id):
    try:
        d_alias = aliased(Designation)
        td_alias = aliased(TenantDesignation)
        designation = db.session.query(d_alias).select_from(d_alias)\
            .join(td_alias, (td_alias.designation_id == d_alias.dsg_id) & (td_alias.tenant_id == tenant_id)) \
            .filter(d_alias.dsg_id == dsg_id).first()
        if not designation:
            raise CustomError("Designation does not exist for the given id", 400)
        return designation
    except CustomError as ce:
        raise ce
    except Exception as e:
        raise e
    finally:
        db.session.close()
