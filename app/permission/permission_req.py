from marshmallow import Schema, fields


class PermissionReq(Schema):
    name = fields.String(required=True)
    request_method = fields.String(required=True)
    path_url = fields.String(required=True)
