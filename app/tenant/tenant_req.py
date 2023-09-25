from marshmallow import Schema, fields


class TenantReq(Schema):
    admin_first_name = fields.String(required=True)
    admin_last_name = fields.String(required=True)
    email = fields.Email(required=True)
    name = fields.String(required=True)
    password = fields.String(required=True)
