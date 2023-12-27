import logging
import os

from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_migrate import Migrate
from flask_sqlalchemy import SQLAlchemy

from app.settings.config import Config, DevelopmentConfig, ProductionConfig, TestingConfig
from app.settings.decorators import public_endpoint
from app.utils.json_formatter import CustomJsonFormatter
import app.commons.config as config

# This sets the root logger to write to stdout (your console).
# Your script/app needs to call this somewhere at least once.
logging.basicConfig()

# By default the root logger is set to WARNING and all loggers you define
# inherit that value. Here we set the root logger to NOTSET. This logging
# level is automatically inherited by all existing and new sub-loggers
# that do not set a less verbose level.
logging.root.setLevel(logging.NOTSET)

# The following line sets the root logger level as well.
# It's equivalent to both previous statements combined:
logging.basicConfig(level=logging.NOTSET)

# create logger with 'app'
logger = logging.getLogger('my-t-app')

logger.setLevel(logging.INFO)
# create file handler which logs even debug messages
if not os.path.exists("log"):
    # if the log directory is not present then create it.
    os.makedirs("log")
fh = logging.FileHandler('log/application.log')
fh.setLevel(logging.INFO)
# create console handler with a higher log level
ch = logging.StreamHandler()
ch.setLevel(logging.INFO)

# create formatter and add it to the handlers
formatter = CustomJsonFormatter('%(timestamp)s %(level)s %(name)s %(message)s')
# formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
# formatter = json_log_formatter.JSONFormatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
fh.setFormatter(formatter)
# ch.setFormatter(formatter)
# add the handlers to the logger
logger.addHandler(fh)
# logger.addHandler(ch)
print("handlers={}".format(logger.handlers))


def create_app(config_class='config.ProductionConfig'):
    app = Flask(__name__)
    if app.env == 'production':
        app.config.from_object(ProductionConfig)
    elif app.env == 'development':
        app.config.from_object(DevelopmentConfig)
    elif app.env == 'testing':
        app.config.from_object(TestingConfig)

    # db_uri = 'postgresql://postgres:root@127.0.0.1:5432/ai_recruitment'
    # db_uri = 'postgresql://postgres:mynewpassword@192.168.10.199:5432/ai_recruitment'
    db_uri = 'postgresql://postgres:mynewpassword@3.108.58.87:5432/ai_recruitment'


    app.config['SQLALCHEMY_DATABASE_URI'] = db_uri
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config['SQLALCHEMY_ENGINE_OPTIONS'] = {
        "pool_size": 10,
        "max_overflow": 100,
        "pool_recycle": 600,
        "pool_pre_ping": True,
        "pool_use_lifo": True,
        "connect_args": {
            "keepalives": 1,
            "keepalives_idle": 10,
            "keepalives_interval": 10,
            "keepalives_count": 5,
        }
    }

    CORS(app, origins="*")

    global db
    db = SQLAlchemy(app)
    migrate = Migrate(app, db)
    from app.user.user_routes import user_blueprint
    app.register_blueprint(user_blueprint, url_prefix="/{}/user".format(config.API_VERSION))
    from app.email.email_routes import email_blueprint
    app.register_blueprint(email_blueprint, url_prefix="/{}/email".format(config.API_VERSION))

    from app.ai_generator.routes import ai_blueprint
    app.register_blueprint(ai_blueprint, url_prefix="/{}/ai".format(config.API_VERSION))

    from app.question_bank.routes import question_blueprint
    app.register_blueprint(question_blueprint, url_prefix="/{}/question".format(config.API_VERSION))

    from app.roles.routes import roles_blueprint
    app.register_blueprint(roles_blueprint, url_prefix="/{}/roles".format(config.API_VERSION))

    from app.designation.designation_route import designation_blueprint
    app.register_blueprint(designation_blueprint, url_prefix="/{}/designation".format(config.API_VERSION))

    from app.permission.permission_route import permission_blueprint
    app.register_blueprint(permission_blueprint, url_prefix="/{}/permission".format(config.API_VERSION))

    from app.domain.domain_route import domain_blueprint
    app.register_blueprint(domain_blueprint, url_prefix="/{}/domain".format(config.API_VERSION))

    from app.candidate.candidate_route import candidate_blueprint
    app.register_blueprint(candidate_blueprint, url_prefix="/{}/candidate".format(config.API_VERSION))

    from app.evaluation.routes import evaluations_blueprint
    app.register_blueprint(evaluations_blueprint, url_prefix="/{}/evaluation".format(config.API_VERSION))

    from app.interview.interview_route import interview_blueprint
    app.register_blueprint(interview_blueprint, url_prefix="/{}/interview".format(config.API_VERSION))

    from app.whisper.whisper_route import whisper_blueprint
    app.register_blueprint(whisper_blueprint, url_prefix="/{}/whisper".format(config.API_VERSION))

    from app.configurations.configuration_route import configurations_blueprint
    app.register_blueprint(configurations_blueprint, url_prefix="/{}/config".format(config.API_VERSION))

    from app.tenant.tenant_route import tenant_blueprint
    app.register_blueprint(tenant_blueprint, url_prefix="/{}/tenant".format(config.API_VERSION))

    from app.industry.route import industry_blueprint
    app.register_blueprint(industry_blueprint, url_prefix="/{}/industry".format(config.API_VERSION))

    from app.sub_domain.route import sub_domain_blueprint
    app.register_blueprint(sub_domain_blueprint, url_prefix="/{}/sub-domain".format(config.API_VERSION))

    from app.page_component.route import page_component_blueprint
    app.register_blueprint(page_component_blueprint, url_prefix="/{}/page-component".format(config.API_VERSION))

    from app.resume_parser.route import resume_parser_blueprint
    app.register_blueprint(resume_parser_blueprint, url_prefix="/{}/resume-parser".format(config.API_VERSION))

    from app.analytics.route import analytics_blueprint
    app.register_blueprint(analytics_blueprint, url_prefix="/{}/analytics".format(config.API_VERSION))

    from app.socratic.route import socratic_blueprint
    app.register_blueprint(socratic_blueprint, url_prefix="/{}/socratic".format(config.API_VERSION))

    from app.structure.route import structure_blueprint
    app.register_blueprint(structure_blueprint, url_prefix="/{}/structure".format(config.API_VERSION))

    @app.route('/')
    @public_endpoint
    def site_index():
        return 'application started'

    @app.before_request
    def log_request():
        logger.info('REQUEST_ENDPOINT={}'.format(request.url))
        print('REQUEST_ENDPOINT={}'.format(request.url))

        logger.info('REQUEST_PAYLOAD={}'.format(request.get_data()))
        print('REQUEST_PAYLOAD={}'.format(request.get_data()))

    @app.after_request
    def log_response(response):
        logger.info('RESPONSE_STATUS_CODE={}'.format(response.status))
        logger.info('RESPONSE_HEADERS={}'.format(response.headers))
        logger.info('RESPONSE_PAYLOAD={}'.format(response.get_data()))
        print('RESPONSE_PAYLOAD={}'.format(response.get_data()))
        return response

    @app.before_request
    def validate_basic_auth():
        is_public_endpoint = False

        if request.endpoint in app.view_functions:
            view_func = app.view_functions[request.endpoint]
            is_public_endpoint = hasattr(view_func, '_public_endpoint')

        auth = request.authorization

        # For basic auth
        if hasattr(auth, 'username') and hasattr(auth, 'password') and not is_public_endpoint:
            # CHECK THAT THE BASIC AUTH USERNAME AND PASSWORD MATCHES THE ONES FROM THE FLASK CONFIG
            if auth.username != app.config['USER'] or auth.password != app.config['PASS']:
                # AUTH FAILED, RETURN 401 UNAUTHORIZED
                return jsonify(code=401, message='Unauthorized'), 401

    return app


logger.info("starting")
app = create_app()
