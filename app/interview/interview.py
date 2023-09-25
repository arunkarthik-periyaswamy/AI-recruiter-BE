import json

from sqlalchemy import Column, String, Integer, DateTime
from sqlalchemy.dialects.postgresql import UUID

from app.commons.db.db_model import Base


class Interview(Base):
    __tablename__ = 'interview'

    i_id = Column(UUID(as_uuid=True), primary_key=True)
    c_id = Column(String)
    dsg_id = Column(Integer)
    no_of_questions = Column(Integer)
    status = Column(String)
    evaluation_status = Column(String)
    date_of_interview = Column(DateTime)
    eval_status_code = Column(Integer)
    created_by = Column(Integer)

    def __init__(self, i_id=None, c_id=None, dsg_id=None, no_of_questions=None, status=None, evaluation_status=None,
                 date_of_interview=None, created_by=None):
        self.i_id = i_id,
        self.c_id = c_id,
        self.dsg_id = dsg_id,
        self.no_of_questions = no_of_questions,
        self.status = status,
        self.evaluation_status = evaluation_status,
        self.date_of_interview = date_of_interview,
        self.created_by = created_by

    def __repr__(self):
        return self

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}

    def format(self):
        return {
            'i_id': self.i_id,
            'c_id': self.c_id,
            'dsg_id': self.dsg_id,
            'no_of_questions': self.no_of_questions,
            'status': self.status,
            'evaluation_status': self.evaluation_status,
            'date_of_interview': self.date_of_interview,
            'created_by': self.created_by
        }

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)
