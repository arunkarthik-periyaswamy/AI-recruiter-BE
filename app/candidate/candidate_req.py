from marshmallow import Schema, fields


class CandidateReq(Schema):
    email = fields.Email(required=True)
    name = fields.String(required=True)
    password = fields.String(required=True)
    designation = fields.String(required=True)
    years_of_experience = fields.Float(required=True)
    expected_ctc = fields.Float(required=True)
    valid_id = fields.String(required=True)
    domains = fields.List(fields.Integer(), required=True)
    phone_number= fields.Integer(required=True)
