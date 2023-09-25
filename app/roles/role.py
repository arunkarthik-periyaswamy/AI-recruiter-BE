import json

from sqlalchemy import Column, Integer, Sequence, String, DateTime, PrimaryKeyConstraint

from app import db
from app.commons.db.db_model import Base


class Role(Base):
    __tablename__ = 'role'

    id = Column(Integer, primary_key=True)
    name = Column(String)
    created_by = Column(Integer)
    updated_by = Column(Integer)
    created_at = Column(DateTime, default=db.func.now(), onupdate=db.func.now())

    def __init__(self, name=None, created_by=created_by):
        self.name = name,
        self.created_by = created_by

    def __repr__(self):
        return self

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}

    def format(self):
        return {
            'id': self.id,
            'name': self.name,
        }

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)


class RolePermission(Base):
    __tablename__ = 'role_permission'
    __table_args__ = (
        PrimaryKeyConstraint('role_id', 'permission_id'),
    )

    role_id = Column(Integer)
    permission_id = Column(Integer)

    def __init__(self, role_id=None, permission_id=None):
        self.role_id = role_id,
        self.permission_id = permission_id

    def __repr__(self):
        return self

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}

    def format(self):
        return {
            'role_id': self.role_id,
            'permission_id': self.permission_id,
        }

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)