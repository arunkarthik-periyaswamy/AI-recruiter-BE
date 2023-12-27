from marshmallow import Schema, fields


class PageComponentReq(Schema):
    page_components = fields.List(fields.String(), required=True)
