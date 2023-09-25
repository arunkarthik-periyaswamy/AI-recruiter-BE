from sqlalchemy.exc import IntegrityError

from app import db
from app.commons.custom_error import CustomError
from app.configurations.configuration import Configuration


def get_configurations():
    try:
        configs = Configuration.query.all()
        res = [{'name': config.config_name, 'value': config.config_value} for config in configs]
        return res
    except Exception as e:
        raise CustomError('Exception occurred while fetching configurations {}'.format(e), 500)
    finally:
        db.session.close()


def create_config(configs, tenant_id):
    try:
        for config in configs:
            configuration = Configuration(config_name=config['name'], config_value=config['value'], tenant_id=tenant_id)
            db.session.add(configuration)
            db.session.flush()
        db.session.commit()
    except IntegrityError as ee:
        if "23505" == ee.orig.pgcode:
            raise CustomError('config name already exists {}'.format(ee.params['config_name']), 400)
        db.session.rollback()
    except Exception as e:
        db.session.rollback()
        raise CustomError('Exception occurred while adding configuration {}'.format(e), 500)
    finally:
        db.session.close()


def update_config(configs, tenant_id):
    try:
        for config in configs:
            configuration = Configuration.query.filter(
                db.and_(Configuration.config_name == config['name'], Configuration.tenant_id == tenant_id)).first()
            if not configuration:
                raise CustomError('Config Name does not exist {}'.format(config['name']), 400)
            configuration.config_value = config['value']
            db.session.add(configuration)
            db.session.flush()
        db.session.commit()
    except IntegrityError as ee:
        if "23505" == ee.orig.pgcode:
            raise CustomError('config name already exists {}'.format(ee.params['config_name']), 400)
        db.session.rollback()
    except Exception as e:
        db.session.rollback()
        raise CustomError('Exception occurred while adding configuration {}'.format(e), 500)
    finally:
        db.session.close()


def get_open_ai_key():
    try:
        configuration = Configuration.query.filter(
            db.and_(Configuration.config_name == 'OPENAI_API_KEY')).first()
        if not configuration:
            raise CustomError('Config Name does not exist {}'.format('OPENAI_API_KEY'), 400)
        return configuration.config_value
    except Exception as e:
        db.session.rollback()
        raise CustomError('Exception occurred while adding configuration {}'.format(e), 500)
    finally:
        db.session.close()
