from flask import request, jsonify, Blueprint, current_app, render_template

from app.email import email_funcs
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
