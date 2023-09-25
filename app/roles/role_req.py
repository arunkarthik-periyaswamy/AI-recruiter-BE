from marshmallow import Schema, fields


class RoleReq(Schema):
    name = fields.String(required=True)
    permissions = fields.List(fields.String(), required=False)
