import json

from sqlalchemy import Column, Sequence, String, Integer, PrimaryKeyConstraint, DateTime

from app import db
from app.commons.db.db_model import Base


class Domain(Base):
    __tablename__ = 'domain'

    d_id = Column(Integer, Sequence('domain_d_id_seq', start=1, increment=1), primary_key=True)
    name = Column(String)
    created_by = Column(Integer)
    created_at = Column(DateTime, default=db.func.now(), onupdate=db.func.now())

    def __init__(self, name=None, created_by=None):
        self.name = name,
        self.created_by = created_by

    def __repr__(self):
        return self

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}

    def format(self):
        return {
            'd_id': self.d_id,
            'name': self.name
        }

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)


class DomainDesignation(Base):
    __tablename__ = 'domain_designation'
    __table_args__ = (
        PrimaryKeyConstraint('dsg_id', 'd_id'),
    )

    d_id = Column(Integer)
    dsg_id = Column(Integer)

    def __init__(self, dsg_id=None, d_id=None):
        self.dsg_id = dsg_id,
        self.d_id = d_id

    def __repr__(self):
        return self

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}

    def format(self):
        return {
            'dsg_id': self.dsg_id,
            'd_id': self.d_id,
        }

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)
