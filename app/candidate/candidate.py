import json
from sqlalchemy.dialects.postgresql import UUID

from sqlalchemy import Column, String, Integer, PrimaryKeyConstraint

from app.commons.db.db_model import Base


class Candidate(Base):
    __tablename__ = 'candidates'

    c_id = Column(UUID(as_uuid=True), primary_key=True)
    c_name = Column(String)
    email = Column(String)
    phone_number = Column(Integer)
    valid_id = Column(Integer)
    dsg_id = Column(Integer)
    years_of_experience = Column(Integer)
    expected_ctc = Column(Integer)

    def __init__(self, c_id=None, c_name=None, phone_number=None, email=None, password=None, valid_id=None, dsg_id=None, years_of_experience=None, expected_ctc=None):
        self.c_id = c_id,
        self.c_name = c_name,
        self.phone_number = phone_number,
        self.valid_id = valid_id,
        self.email = email,
        self.dsg_id = dsg_id,
        self.years_of_experience = years_of_experience,
        self.expected_ctc=expected_ctc,
        self.password=password

    def __repr__(self):
        return self

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}

    def format(self):
        return {
            'c_id': self.c_id,
            'c_name': self.c_name,
            'email': self.email,
            'phone_number': self.phone_number,
            'valid_id': self.valid_id,
            'dsg_id': self.dsg_id,
            'years_of_experience': self.years_of_experience,
            'expected_ctc': self.expected_ctc
        }

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)


class CandidateDomains(Base):
    __tablename__ = 'candidate_domain'
    __table_args__ = (
        PrimaryKeyConstraint('candidate_id', 'domain_id'),
    )

    domain_id = Column(Integer)
    candidate_id = Column(String)

    def __init__(self, candidate_id=None, domain_id=None):
        self.candidate_id = candidate_id,
        self.domain_id = domain_id

    def __repr__(self):
        return self

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}

    def format(self):
        return {
            'domain_id': self.domain_id,
            'candidate_id': self.candidate_id,
        }

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__,
                          sort_keys=True, indent=4)

