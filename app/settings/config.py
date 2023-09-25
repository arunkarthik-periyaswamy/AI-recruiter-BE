class Config:
    # TODO: have to read this config from .env file

    API_VERSION = '2023.3'  # os.environ['API_VERSION']
    DB_HOST = 'localhost'  # os.environ['DB_HOST']
    DB_USER = 'root'  # os.environ['DB_USER']
    DB_PASSWORD = 'root'  # os.environ['DB_PASSWORD']
    DB_DATABASE = 'test'  # os.environ['DB_DATABASE']
    FLASK_ENV = 'development'  # os.environ['FLASK_ENV']
    USER = 'admin'  # os.environ['USER']
    PASS = 'admin'  # os.environ['PASS']
    SENDGRID_API_KEY = 'XXXXXXXXX'  # os.environ['SENDGRID_API_KEY']


class ProductionConfig(Config):
    SESSION_COOKIE_SECURE = True
    SESSION_COOKIE_HTTPONLY = True


class DevelopmentConfig(Config):
    DEBUG = True


class TestingConfig(Config):
    TESTING = True
