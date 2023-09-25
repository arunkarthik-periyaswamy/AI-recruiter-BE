import json
from sqlalchemy.dialects.postgresql import UUID

from sqlalchemy import Column, Sequence
from app import db
from app.commons.db.db_model import Base


class Configuration(Base):
    __tablename__ = 'configurations'

    config_name = Column(db.String, primary_key=True)
    config_value = Column(db.String, primary_key=True)
    tenant_id = Column(UUID(as_uuid=True))

    def __init__(self, config_name=None, config_value=None, tenant_id=None):
        self.config_name = config_name,
        self.config_value = config_value,
        self.tenant_id = tenant_id

    def __repr__(self):
        return self

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}

    def format(self):
        return {
            'config_id': self.config_id,
            'config_name': self.config_name,
            'config_value': self.config_value,
            'tenant_id': self.tenant_id
        }

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)
