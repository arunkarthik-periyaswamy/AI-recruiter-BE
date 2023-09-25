import logging

from sqlalchemy.orm import aliased

from app import db
from app.commons.custom_error import CustomError
from app.designation.designation import Designation
from app.domain.domain import Domain, DomainDesignation
from app.sub_domain.model import SubDomain


def save_sub_domain(request_data, user_id):
    try:
        logging.info("Creating sub-domain")
        domain = Domain.query.filter(Domain.d_id == request_data.domain_id).first()
        if not domain:
            raise CustomError("Given domain is not valid!.", 400)

        sub_domain = SubDomain.query.filter(SubDomain.name == request_data.name,
                                            SubDomain.domain_id == request_data.domain_id).first()
        if sub_domain:
            raise CustomError("Sub-domain already exists!.", 400)

        sub_domain = SubDomain(name=request_data.name,
                               domain_id=request_data.domain_id,
                               created_by=user_id)
        db.session.add(sub_domain)
        db.session.commit()

        return sub_domain.format()
    except Exception as ex:
        raise ex
    finally:
        db.session.close()


def fetch_sub_domain_for_domains(domain_id):
    try:
        logging.info("Fetching sub-domains for given domain id")
        domain = Domain.query.filter(Domain.d_id == domain_id).first()
        if not domain:
            raise CustomError("Given domain is not valid!.", 400)
        sub_domains = SubDomain.query.filter(SubDomain.domain_id == domain_id).all()
        return [
            sub_domain.format()
            for sub_domain in sub_domains
        ]
    except Exception as ex:
        raise ex
    finally:
        db.session.close()


def validate_sub_domain(designation, domain, sub_domain):
    try:
        if not(designation and domain and sub_domain):
            raise CustomError("Please provide all the required fields. Designation, Domain, Subdomain", 403)
        sd_alias = aliased(SubDomain)
        d_alias = aliased(Domain)
        dsg_alias = aliased(Designation)
        dd_alias = aliased(DomainDesignation)

        sub_domain = db.session.query(sd_alias.id, d_alias.name.label("domain_name"), dsg_alias.name.label("designation_name"))\
            .select_from(sd_alias)\
            .join(d_alias, sd_alias.domain_id == d_alias.d_id)\
            .join(dd_alias, dd_alias.d_id == sd_alias.domain_id)\
            .join(dsg_alias, dsg_alias.dsg_id == dd_alias.dsg_id)\
            .filter(sd_alias.name == sub_domain)\
            .first()

        if not sub_domain:
            raise CustomError("Given sub-domain is not valid!", 403)
        sub_domain = sub_domain._asdict()
        if sub_domain.get("domain_name") != domain:
            raise CustomError("Given domain doesn't match with the sub-domain!", 403)
        if sub_domain.get("designation_name") != designation:
            raise CustomError("Given designation doesn't match with the sub-domain!", 403)
        return sub_domain.get("id")
    except CustomError as e:
        raise e
    finally:
        db.session.close()
