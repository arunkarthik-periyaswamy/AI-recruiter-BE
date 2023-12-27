from app.candidate.candidate_service import get_candidates_for_tenant
from app.commons.constants import INTERVIEW_STATUS, EVALUATION_STATUS
from app.commons.custom_error import CustomError
from app.designation.designation_service import get_all_designation
from app.interview.interview_service import get_interview_for_tenant
from app.question_bank.service import get_questions_for_tenant
from app.user.user_service import get_questioner_list, fetch_questioner_list_for_designation


def fetch_analytics(tenant_id, dsg_id):
    try:
        designations = get_all_designation(tenant_id) if not dsg_id else [dsg_id]
        questioners = get_questioner_list(tenant_id) if not dsg_id else fetch_questioner_list_for_designation(dsg_id, tenant_id)
        questions = get_questions_for_tenant(tenant_id, dsg_id)
        candidates = get_candidates_for_tenant(tenant_id, dsg_id)
        interviews = get_interview_for_tenant(tenant_id, dsg_id)
        interviews_pending = 0
        evaluations_completed = 0
        for interview in interviews:
            if interview.status == INTERVIEW_STATUS.PENDING.name:
                interviews_pending += 1
            if interview.evaluation_status == EVALUATION_STATUS.COMPLETED.name:
                evaluations_completed += 1

        return {
            "no_of_designations": len(designations) if designations else 0,
            "no_of_questioners": len(questioners) if questioners else 0,
            "no_of_questions": len(questions) if questions else 0,
            "no_of_candidates": len(candidates) if candidates else 0,
            "no_of_interviews": len(interviews) if interviews else 0,
            "no_of_interviews_pending": interviews_pending,
            "no_of_evaluations": evaluations_completed,
        }
    except CustomError as ce:
        raise ce
    except Exception as e:
        raise e
