import json

from sqlalchemy import Integer, Column, String, DateTime, PrimaryKeyConstraint

from app import db
from app.commons.db.db_model import Base


class PageComponent(Base):
    __tablename__ = 'page_component'

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


class RolePageComponent(Base):
    __tablename__ = 'role_page_component'
    __table_args__ = (
        PrimaryKeyConstraint('role_id', 'page_component_id'),
    )

    role_id = Column(Integer)
    page_component_id = Column(Integer)

    def __init__(self, role_id=None, page_component_id=None):
        self.role_id = role_id,
        self.page_component_id = page_component_id

    def __repr__(self):
        return self

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}

    def format(self):
        return {
            'role_id': self.role_id,
            'page_component_id': self.permission_id,
        }

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)
