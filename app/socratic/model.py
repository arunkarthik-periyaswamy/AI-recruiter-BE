import json

from sqlalchemy import Column, Integer, String, Boolean, JSON
from sqlalchemy.dialects.postgresql import UUID

from app.commons.db.db_model import Base


class Evaluations(Base):
    __tablename__ = 'evaluations'

    c_id = Column(Integer, primary_key=True)
    q_id = Column(String, primary_key=True)
    interview_id = Column(String, primary_key=True)
    ai_answer = Column(String)
    candidate_answer = Column(String)
    score = Column(Integer)
    is_clue_used = Column(Boolean)
    time_taken = Column(Integer)
    is_flagged = Column(Boolean)
    question_number = Column(Integer)
    tenant_id = Column(UUID)
    conversations = Column(JSON)

    def __init__(self, c_id=None, q_id=None, ai_answer=None, candidate_answer=None, score=None, is_clue_used=None,
                 time_taken=None, is_flagged=None, interview_id=None, question_number=None, tenant_id=None, conversations=None):
        self.c_id = c_id
        self.q_id = q_id
        self.ai_answer = ai_answer
        self.candidate_answer = candidate_answer
        self.score = score
        self.is_clue_used = is_clue_used
        self.time_taken = time_taken
        self.is_flagged = is_flagged
        self.interview_id = interview_id
        self.question_number = question_number
        self.tenant_id = tenant_id
        self.conversations = conversations

    def __repr__(self):
        return self

    def as_dict(self):
        return {(self.c_id, self.q_id): getattr(self, self.c_id, self.q_id) for c in self.__table__.columns}

    def format(self):
        return {'c_id': self.c_id,
                'q_id': self.q_id,
                'ai_answer': self.ai_answer,
                'candidate_answer': self.candidate_answer,
                'score': self.score,
                'is_clue_used': self.is_clue_used,
                'time_taken': self.time_taken,
                'is_flagged': self.is_flagged,
                'interview_id': self.interview_id,
                'question_number': self.question_number,
                'tenant_id': self.tenant_id, 
                'conversations': self.conversations
                }

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)
