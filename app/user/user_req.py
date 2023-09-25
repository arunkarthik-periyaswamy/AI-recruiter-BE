from marshmallow import Schema, fields


class UserReq(Schema):
    email = fields.Email(required=True)
    # first_name = fields.String(required=True)
    # last_name = fields.String(required=True)
    password = fields.String(required=True)
    # designation = fields.String(required=True)
    role_id = fields.String(required=False)
