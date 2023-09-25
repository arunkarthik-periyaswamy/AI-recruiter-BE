import logging

from sqlalchemy import func
from sqlalchemy.orm import aliased

from app.commons.custom_error import CustomError
from app.designation.designation import Designation, TenantDesignation
from app import db
from app.industry.service import check_industry_exists


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
