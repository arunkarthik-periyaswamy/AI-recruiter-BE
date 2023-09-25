from marshmallow import Schema, fields


class DesignationReq(Schema):
    name = fields.String(required=True)
    industry_id = fields.Integer(required=True)
