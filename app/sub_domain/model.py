import json

from sqlalchemy import Column, Integer, String, DateTime

from app import db
from app.commons.db.db_model import Base


class SubDomain(Base):
    __tablename__ = 'sub_domain'

    id = Column(Integer, primary_key=True)
    name = Column(String)
    domain_id = Column(Integer)
    created_by = Column(Integer)
    updated_by = Column(Integer)
    created_at = Column(DateTime, default=db.func.now(), onupdate=db.func.now())

    def __init__(self, name=None, domain_id=None, created_by=None):
        self.name = name
        self.domain_id = domain_id
        self.created_by = created_by

    def __repr__(self):
        return self

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}

    def format(self):
        return {
            'id': self.id,
            'name': self.name,
            'domain_id': self.domain_id
        }

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)
