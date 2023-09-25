from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail, MailSettings, SandBoxMode

from app.settings.config import Config


def send_notification(email, subject, html_content):
    message = Mail(
        from_email=('noreply@gmail.com', 'No Reply'),
        to_emails=[email],
        subject=subject,
        html_content=html_content)

    try:
        mail_settings = MailSettings()
        mail_settings.sandbox_mode = SandBoxMode(True)
        message.mail_settings = mail_settings
        sg = SendGridAPIClient(Config.SENDGRID_API_KEY)
        response = sg.send(message)
        print('SENDGRID INVOICE_READY_NOTIFICATION SENT STATUS CODE={}'.format(response.status_code))
        print('SENDGRID INVOICE_READY_NOTIFICATION SENT BODY={}'.format(response.body))
        print('SENDGRID INVOICE_READY_NOTIFICATION SENT HEADERS={}'.format(response.headers))
    except Exception as e:
        print('SENDGRID INVOICE_READY_NOTIFICATION EXCEPTION={}'.format(e))
        raise e
