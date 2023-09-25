from marshmallow import Schema, fields


class EvaluatorReq(Schema):

    c_id = fields.String(required=True)
    q_id = fields.String(required=True)
    candidate_answer = fields.String(required=True)
    is_clue_used = fields.Boolean()
    time_taken = fields.Integer(required=True)
    is_flagged = fields.Boolean()
    interview_id = fields.String(required=True)
    