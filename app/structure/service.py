from app.domain import domain_service
from langchain.chat_models import ChatOpenAI
from langchain.schema import SystemMessage, HumanMessage, AIMessage

from app.commons.custom_error import CustomError
from app.configurations.configuration_service import get_open_ai_key
from app.question_bank.model import Question
from app.sub_domain.model import SubDomain
from sqlalchemy.orm import aliased
from sqlalchemy import func
from app import db
import json
# from app.domain.service import get_domains_and_subdomains_by_designation
from app.sub_domain.service import fetch_sub_domain_for_domain
from app.designation.designation_service import get_designation_by_dsg_id
from app.designation import designation_service
from app.domain.domain_service import get_domain_by_domain_id

q = aliased(Question)
s = aliased(SubDomain)

def get_domains_and_subdomains_by_designation(tenant_id, designation_id):
    try:
        designation = designation_service.get_designation_by_dsg_id(designation_id)
        result = (
            db.session.query(
                func.count(s.domain_id).label('domain_count'),
                s.domain_id.label('domain_id'),
                q.domain,
                s.id.label('sub_domain_id'),
                s.name.label('sub_domain')
            )
            .join(q, q.sub_domain == s.id)
            .filter(q.tenant_id == tenant_id, q.designation == designation.name)
            .group_by(s.domain_id, q.domain, s.id, s.name)
            # .order_by(func.count(s.domain_id).desc())
            .order_by(s.domain_id.desc())
            .all()
        )


        output = {}
        domains = domain_service.get_domain_by_dsg_id(designation_id)

        # Fetch the all sub-domains for each domain for a designation
        sub_domains = {}
        for domain in domains['domains']:
            domain_id = domain['d_id']
            sub_domains[domain_id] = fetch_sub_domain_for_domain(str(domain_id))

        for row in result:
            question_count = row.domain_count
            domain_id = row.domain_id
            domain_name = row.domain
            sub_domain_id = row.sub_domain_id
            sub_domain_name = row.sub_domain

            if domain_name not in output:
                output[domain_name] = {
                    "id": domain_id,
                    "sub_domains": []
                }

            output[domain_name]["sub_domains"].append({
                "id": sub_domain_id,
                "name": sub_domain_name,
                "question_count": question_count
            })

        final_output = {key: {"id": value["id"], "sub_domains": value["sub_domains"]} for key, value in output.items()}

        for domain_id, sub_domain_data in sub_domains.items():
            domain_name = get_domain_by_domain_id(domain_id=domain_id).name

            if domain_name not in final_output:
                final_output[domain_name] = {
                    "id": domain_id,
                    "sub_domains": []
                }

            for sub_domain in sub_domain_data['sub_domains']:
                sub_domain_id = sub_domain['id']
                if not any(sub['id'] == sub_domain_id for sub in final_output[domain_name]['sub_domains']):
                    final_output[domain_name]['sub_domains'].append({
                        "id": sub_domain_id,
                        "name": sub_domain['name'],
                        "question_count": 0
                    })

        result_json = json.dumps(final_output)

        return result_json

    except CustomError as e:
        raise e
    except Exception as e:
        raise e
