from marshmallow import Schema, fields


class DomainReq(Schema):
    dsg_id = fields.Integer(required=True)
    name = fields.String(required=True)
