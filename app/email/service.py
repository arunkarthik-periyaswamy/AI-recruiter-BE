from app.candidate.candidate_service import fetch_candidate_by_id
from app import db
from app.commons.custom_error import CustomError
from app.designation.designation_service import fetch_designation_by_id
from app.email import email_template
from app.email.email_funcs import send_mail
from app.tenant.tenant_service import fetch_tenant_by_id


def send_invite_for_interview(request_body, tenant_id, c_id):
    try:
        request_body = request_body.get_json()
        if "invitation_url" not in request_body:
            raise CustomError("invitation_url not provided", 400)
        candidate = fetch_candidate_by_id(c_id, tenant_id)
        tenant = fetch_tenant_by_id(tenant_id)
        designation = fetch_designation_by_id(candidate.dsg_id, tenant_id)
        subject = f"Invitation to Video Interview for {designation.name} Position - {tenant.name}"
        html_template = email_template.INVITE_CANDIDATE
        html_template = html_template.format(candidate_name=candidate.c_name,
                                             designation=designation.name,
                                             tenant_name=tenant.name,
                                             interview_link=request_body.get("invitation_url"))
        return send_mail(candidate.email, subject, html_template)
    except CustomError as ce:
        raise ce
    except Exception as e:
        raise e
    finally:
        db.session.close()

def send_invite_for_tool_users(first_name, email, password, tenant, role):
    try:
        #request_body = request_body.get_json()
        #if "invitation_url" not in request_body:
        #    raise CustomError("invitation_url not provided", 400)
        #candidate = fetch_candidate_by_id(c_id, tenant_id)
        #tenant = fetch_tenant_by_id(tenant_id)
        #designation = fetch_designation_by_id(candidate.dsg_id, tenant_id)
        if role == "Questioner manager":
            subject = email_template.INVITE_QESTIONER_MANAGER_SUB
            html_template = email_template.INVITE_QESTIONER_MANAGER
        elif role == "Questioner":
            subject = email_template.INVITE_QESTIONER_SUB
            html_template = email_template.INVITE_QESTIONER
        elif role == "Admin":
            subject = email_template.INVITE_ADMIN_SUB
            html_template = email_template.INVITE_ADMIN
        subject = subject.format(tenant_name = tenant.name)
        html_template = html_template.format(user_name=first_name,
                                             tenant_name=tenant.name,
                                             email_id=email,
                                             password_given=password)
        return send_mail(email, subject, html_template)
    except CustomError as ce:
        raise ce
    except Exception as e:
        raise e
    finally:
        db.session.close()
