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
                DomainDesignation.d_id == domain.d_id, DomainDesignation.dsg_id == designation.dsg_id
            ).first()
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
        return {"name": domain.name, "id": domain.d_id}, 200
    except Exception as e:
        db.session.rollback()
        return {"message": "Unable to create Domain!.", "error": str(e)}, 500
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
            domains = [domain.format() for domain in domains]
        else:
            domains = []
        return {
            "count": len(domains),
            "domains": domains
        }
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


def get_domain_by_domain_names(domain_names):
    try:
        domain = Domain.query.filter(Domain.name.in_(domain_names)).all()
        return domain
    except Exception as e:
        raise e
    finally:
        db.session.close()


def create_and_map_domains_to_designation(dsg_id, existing_domains, domains_to_be_created):
    try:
        for domain in domains_to_be_created:
            domain = Domain(name=domain.title())
            db.session.add(domain)
            db.session.flush()
            db.session.refresh(domain)
            existing_domains[domain.name] = domain.d_id
        print("Successfully created domains!.")

        for domain_id in existing_domains.values():
            domain_designation = DomainDesignation(dsg_id=dsg_id, d_id=domain_id)
            db.session.add(domain_designation)
            db.session.flush()
        db.session.commit()
        print("Mapped the domains with designation!.")
    except Exception as e:
        db.session.rollback()
        raise e
    finally:
        db.session.close()
