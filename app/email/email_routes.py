from flask import request, jsonify, Blueprint, render_template

from app.commons.custom_error import CustomError
from app.email import email_funcs
from app.email.service import send_invite_for_interview
from app.user.user_routes import token_required, get_user_and_tenant_from_token

email_blueprint = Blueprint('email_blueprint', __name__)


@email_blueprint.route('/send_notification', methods=['POST'])
def invoice_ready_notification():
    request_payload = request.json

    if 'invoice-root' not in request_payload:
        return jsonify(code=400,
                       message='invoice-root parameter is required. Example: {\'invoice-root\': \'IN201231\'}'), 400

    if 'org_id' not in request_payload:
        return jsonify(code=400, message='org_id parameter is required.'), 400

    if 'subject' not in request_payload:
        return jsonify(code=400, message='subject parameter is required.'), 400

    invoice_root = request_payload['invoice-root']
    org_id = request_payload['org_id']
    subject = request_payload['subject']
    invoice_number = '{}{}'.format(invoice_root, org_id)
    invoice_obj = {}
    if not invoice_obj:
        return jsonify(code=404, message='Invoice not found. Please provide a valid invoice root and org id.'), 404

    customer_name = '{} {}'.format(invoice_obj['FIRST_NAME'], invoice_obj['LAST_NAME'])
    invoice_url = 'https://test.com'

    email_template = render_template('email/invoice_ready_notification.email', customer_name=customer_name,
                                     invoice_url=invoice_url)
    email_funcs.invoice_ready_notification('test@gmail.com', subject='', html_content=email_template)

    return jsonify(code=200, message='Email sent')


@email_blueprint.route("/invite/<c_id>", methods=['POST'])
@token_required
def send_invite(c_id):
    try:
        user_id, tenant_id = get_user_and_tenant_from_token(request)
        return send_invite_for_interview(request, tenant_id, c_id)
    except CustomError as ce:
        return {"message": 'Failed to send invite for candidate', "error": str(ce.msg)}, ce.status_code
    except Exception as e:
        return {"message": "Failed to send invite", "error": str(e)}, 500

@email_blueprint.route("/invite/<u_id>", methods=['POST'])
@token_required
def send_invite_new_user(u_id):
    try:
        user_id, tenant_id = get_user_and_tenant_from_token(request)
        return send_invite_for_interview(request, tenant_id, c_id)
    except CustomError as ce:
        return {"message": 'Failed to send invite for candidate', "error": str(ce.msg)}, ce.status_code
    except Exception as e:
        return {"message": "Failed to send invite", "error": str(e)}, 500
