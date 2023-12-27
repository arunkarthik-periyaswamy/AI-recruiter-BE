import json

from sqlalchemy import Column, Sequence, String, Integer, PrimaryKeyConstraint
from werkzeug.security import generate_password_hash, check_password_hash

from app import db
from app.commons.db.db_model import Base


class User(Base):
    __tablename__ = 'user'

    user_id = Column(db.Integer, Sequence('user_user_id_seq', start=1, increment=1), primary_key=True)
    first_name = Column(db.String)
    last_name = Column(db.String)
    email = Column(db.String)
    password = Column(db.String)
    jwt_token = Column(db.String)
    role_id = Column(db.Integer)

    def __init__(self, first_name=None, last_name=None, email=None, password=None, jwt_token=None, role_id=None):
        self.password = password,
        self.first_name = first_name,
        self.last_name = last_name,
        self.email = email,
        self.jwt_token = jwt_token,
        self.role_id = role_id

    def __repr__(self):
        return self

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}

    def format(self):
        return {
            'user_id': self.user_id,
            'first_name': self.first_name,
            'last_name': self.last_name,
            'email': self.email,
            'role_id': self.role_id
        }

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)

    def set_password(self, password):
        self.password = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password, password)


class UserDesignation(Base):
    __tablename__ = 'user_designation'
    __table_args__ = (
        PrimaryKeyConstraint('dsg_id', 'user_id'),
    )

    user_id = Column(Integer)
    dsg_id = Column(Integer)

    def __init__(self, dsg_id=None, user_id=None):
        self.dsg_id = dsg_id,
        self.user_id = user_id

    def __repr__(self):
        return self

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}

    def format(self):
        return {
            'dsg_id': self.dsg_id,
            'user_id': self.user_id,
        }

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)
