import json

from sqlalchemy import Column, Integer, String, Boolean
from sqlalchemy.dialects.postgresql import UUID


from app.commons.db.db_model import Base


class Question(Base):
    __tablename__ = 'question_bank'

    question_id = Column(UUID(as_uuid=True), primary_key=True)
    question = Column(String, nullable=False)
    question_type = Column(String)
    answer_type = Column(String)
    ai_answer = Column(String)
    user_id = Column(Integer)
    domain = Column(String)
    designation = Column(String)
    sub_domain = Column(Integer)
    max_answering_time = Column(Integer)
    preparation_time = Column(Integer)
    code_required = Column(Boolean)
    difficulty_index = Column(Integer)
    clues = Column(String)
    url = Column(String)
    flagged = Column(Boolean)
    flag_expectation = Column(String)
    tenant_id = Column(UUID)

    def __init__(self, question_id=None, question=None, question_type=None, user_id=None, domain=None,
                 designation=None, sub_domain=None, answer_type=None, ai_answer=None, max_answering_time=None,
                 preparation_time=None, code_required=None, difficulty_index=None, clues=None, url=None, flagged=None,
                 flag_expectation=None, tenant_id=None):
        self.question_id = question_id
        self.question = question
        self.question_type = question_type
        self.user_id = user_id
        self.domain = domain
        self.designation = designation
        self.sub_domain = sub_domain
        self.answer_type = answer_type
        self.ai_answer = ai_answer
        self.max_answering_time = max_answering_time
        self.preparation_time = preparation_time
        self.code_required = code_required
        self.difficulty_index = difficulty_index
        self.clues = clues
        self.url = url
        self.flagged = flagged
        self.flag_expectation = flag_expectation
        self.tenant_id = tenant_id

    def __repr__(self):
        return self

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}

    def format(self):
        return {
            'question_id': self.question_id,
            'question': self.question,
            'question_type': self.question_type,
            'user_id': self.user_id,
            'domain': self.domain,
            'designation': self.designation,
            'sub_domain': self.sub_domain,
            'answer_type': self.answer_type,
            'ai_answer': self.ai_answer,
            'max_answering_time': self.max_answering_time,
            'preparation_time': self.preparation_time,
            'url': self.url,
            'clues': self.clues,
            'flagged': self.flagged,
            'difficulty_index': self.difficulty_index,
            'flag_expectation': self.flag_expectation
        }

    def get_question_response(self):
        return {
            'question_id': self.question_id,
            'question': self.question,
            'question_type': self.question_type,
            'user_id': self.user_id,
            'domain': self.domain,
            'designation': self.designation,
            'sub_domain': self.sub_domain,
            'answer_type': self.answer_type,
            'max_answering_time': self.max_answering_time,
            'preparation_time': self.preparation_time,
            'url': self.url,
            'difficulty_index': self.difficulty_index,
        }

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)

