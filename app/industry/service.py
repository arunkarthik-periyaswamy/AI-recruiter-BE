import logging

from sqlalchemy import func

from app import db
from app.commons.custom_error import CustomError
from app.industry.model import Industry


def save_industry(request, user_id):
    try:
        logging.info("Creating a new industry")
        industry_name = request.args.get("industry", '').lower()
        if not industry_name:
            raise CustomError("Please provide the industry", 400)

        industry = Industry.query.filter(
            func.replace(func.lower(Industry.name), " ", "") == industry_name.replace(" ", "")).first()
        if industry:
            raise CustomError(f"Industry {industry_name} already exists!.", 403)

        industry = Industry(name=industry_name.title(), created_by=user_id)
        db.session.add(industry)
        db.session.commit()
        logging.info(f"Industry {industry_name} created")
        return {"name": industry.name, "id": industry.id}, 200
    except CustomError as e:
        raise e
    finally:
        db.session.close()


def fetch_industries():
    try:
        return Industry.query.all()
    except Exception as ex:
        raise ex
    finally:
        db.session.close()


def check_industry_exists(industry_id):
    try:
        return Industry.query.filter(Industry.id == industry_id).first()
    except Exception as ex:
        raise ex
    finally:
        db.session.close()
