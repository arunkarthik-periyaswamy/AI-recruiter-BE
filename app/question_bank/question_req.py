from marshmallow import Schema, fields


class QuestionReq(Schema):
    question = fields.String(required=True)
    question_type = fields.String(required=True)
    designation = fields.String(required=True)
    domain = fields.String(required=True)
    sub_domain = fields.String(required=True)
    answer_type = fields.String(required=True)
    ai_answer = fields.String(required=False)
    max_answering_time = fields.Integer(required=True)
    preparation_time = fields.Integer(required=True)
    url = fields.String(required=False)
    clues = fields.String(required=False)
    difficulty_index = fields.Integer(required=True)
    code_required = fields.Boolean(default=False, required=False)
    flagged = fields.Boolean(default=False, required=False)
    flag_expectation = fields.String(required=False)
    user_id = fields.Integer(required=True)


class QuestionGenerateDTO(Schema):
    question = fields.String(required=False)
    industry = fields.String(required=True)
    designation = fields.String(required=True)
    domain = fields.String(required=True)
    sub_domain = fields.String(required=True)
    difficulty = fields.Integer(required=True)
    code_based = fields.Boolean(required=True)


class AnswerGenerateDTO(Schema):
    question = fields.String(required=True)
    designation = fields.String(required=True)
