import json

from sqlalchemy import Column, Sequence, String, Integer, PrimaryKeyConstraint
from sqlalchemy.dialects.postgresql import UUID

from app.commons.db.db_model import Base


class Designation(Base):
    __tablename__ = 'designation'

    dsg_id = Column(Integer, Sequence('designation_dsg_id_seq', start=1, increment=1), primary_key=True)
    name = Column(String)
    tenant_id = Column(UUID(as_uuid=True))
    industry_id = Column(Integer)

    def __init__(self, name=None, tenant_id=None, industry_id=None):
        self.name = name,
        self.tenant_id = tenant_id,
        self.industry_id = industry_id

    def __repr__(self):
        return self

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}

    def format(self):
        return {
            'dsg_id': self.dsg_id,
            'name': self.name,
            'tenant_id': self.tenant_id,
            'industry_id': self.industry_id
        }

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)


class TenantDesignation(Base):
    __tablename__ = 'tenant_designation'
    __table_args__ = (
        PrimaryKeyConstraint('tenant_id', 'designation_id'),
    )

    tenant_id = Column(UUID)
    designation_id = Column(Integer)

    def __init__(self, designation_id=None, tenant_id=None):
        self.designation_id = designation_id,
        self.tenant_id = tenant_id

    def __repr__(self):
        return self

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}

    def format(self):
        return {
            'designation_id': self.designation_id,
            'tenant_id': self.d_id,
        }

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)
