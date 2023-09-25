import json

from sqlalchemy import Column, Integer, String, DateTime

from app import db
from app.commons.db.db_model import Base


class Industry(Base):
    __tablename__ = 'industry'

    id = Column(Integer, primary_key=True)
    name = Column(String)
    created_by = Column(Integer)
    updated_by = Column(Integer)
    created_at = Column(DateTime, default=db.func.now(), onupdate=db.func.now())

    def __init__(self, name=None, created_by=None):
        self.name = name
        self.created_by = created_by

    def __repr__(self):
        return self

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}

    def format(self):
        return {
            'id': self.id,
            'name': self.name
        }

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)
