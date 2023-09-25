import dataclasses

from sqlalchemy import Column, DateTime

from app import db


@dataclasses.dataclass
class Base(db.Model):
    __abstract__ = True

    last_updated = Column(
        DateTime, default=db.func.now(), onupdate=db.func.now())