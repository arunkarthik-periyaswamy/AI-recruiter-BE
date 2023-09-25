import logging

from sqlalchemy import func

from app.designation.designation import Designation
from app.domain.domain import Domain, DomainDesignation
from app import db


def add_domain(domain_req, user_id):
    try:
        designation = Designation.query.filter(
            db.and_(Designation.dsg_id == domain_req.dsg_id)).first()

        if not designation:
            logging.error(f"Designation:{domain_req.dsg_id} Designation doesn't Exist")
            raise Exception('Designation doesnt Exist')

        domain = Domain.query.filter(
            func.lower(Domain.name) == domain_req.name.lower()).first()

        if domain:
            domain_designation = DomainDesignation.query.filter(
                d_id=domain.d_id, dsg_id=designation.dsg_id
            )
            if domain_designation:
                logging.error(f"Domain:{domain_req.name} already Exist")
                raise Exception('Domain already Exist')
        else:
            domain = Domain(name=domain_req.name.title(), created_by=user_id)
            db.session.add(domain)
            db.session.commit()
            db.session.flush()
            db.session.refresh(domain)

        domain_designation = DomainDesignation(dsg_id=designation.dsg_id, d_id=domain.d_id)
        db.session.add(domain_designation)
        db.session.commit()
        return {"name": domain.name, "id": domain.d_id}
    except Exception as e:
        raise Exception('Domain already exist')
    finally:
        db.session.close()


def get_all_domain():
    db.session.begin()
    result = Domain.query.all()
    db.session.close()
    return result


def get_domain_by_dsg_id(dsg_id):
    try:
        domain_designation = DomainDesignation.query.filter(DomainDesignation.dsg_id == dsg_id).all()
        if domain_designation:
            domain_ids = [domain.d_id for domain in domain_designation]
            domains = Domain.query.filter(Domain.d_id.in_(domain_ids)).all()
            return [domain.format() for domain in domains]
        else:
            return None
    except Exception as e:
        raise e
    finally:
        db.session.close()


def get_domain_by_domain_id(domain_id):
    try:
        domain = Domain.query.filter(db.and_(Domain.d_id == domain_id)).first()
        return domain
    except Exception as e:
        raise Exception('Failed Retrieving Domains')
    finally:
        db.session.close()

