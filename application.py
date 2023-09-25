from app import create_app
import logging
import os
from dotenv import load_dotenv

application = create_app(config_class='config.ProductionConfig')

# gunicorn setup
gunicorn_logger = logging.getLogger('gunicorn.error')
application.logger.handlers = gunicorn_logger.handlers
application.logger.setLevel(gunicorn_logger.level)

# loading from .env
load_dotenv()

application.config['SECRET_KEY'] = 'ai_recruitment_ideas2it'  # Secret key for JWT

# start application
application.run(host="0.0.0.0", debug=True)
