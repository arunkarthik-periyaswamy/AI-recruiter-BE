import json

from sqlalchemy import Column, String, Integer, DateTime, PrimaryKeyConstraint
from sqlalchemy.dialects.postgresql import UUID

from app.commons.db.db_model import Base
from app import db


class Tenant(Base):
    __tablename__ = 'tenant'

    tenant_id = Column(UUID(as_uuid=True), primary_key=True)
    name = Column(String)
    created_at = Column(
        DateTime, default=db.func.now())

    def __init__(self, tenant_id=None, name=None, created_at=None):
        self.tenant_id = tenant_id,
        self.name = name,
        self.created_at = created_at

    def __repr__(self):
        return self

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}

    def format(self):
        return {
            'tenant_id': self.tenant_id,
            'name': self.name,
            'created_at': self.created_at
        }

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)


class TenantUser(Base):
    __tablename__ = 'tenant_user'
    __table_args__ = (
        PrimaryKeyConstraint('tenant_id', 'user_id'),
    )

    tenant_id = Column(UUID(as_uuid=True))
    user_id = Column(Integer)

    def __init__(self, tenant_id=None, user_id=None):
        self.tenant_id = tenant_id,
        self.user_id = user_id,

    def __repr__(self):
        return self

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}

    def format(self):
        return {
            'tenant_id': self.tenant_id,
            'user_id': self.user_id
        }

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)

