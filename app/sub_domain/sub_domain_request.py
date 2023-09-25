from marshmallow import Schema, fields


class SubdomainReq(Schema):
    name = fields.String(required=True)
    domain_id = fields.Integer(required=True)
