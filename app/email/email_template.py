INVITE_CANDIDATE = """
<p>Dear <strong>{candidate_name}</strong>,</p>

    <p>We are pleased to inform you that we have received your application for the <em>{designation}</em> position at 
    <strong>{tenant_name}</strong>. Your skills and experience are impressive, and we are excited to move forward with the
     interview process.</p>

    <p>As part of our selection process, we have scheduled a video interview that you can commence at your convenience.
     Please note that while you have the flexibility to start the interview at any time that suits you, it must be completed 
     within 48 hours of receiving this invitation.</p>

    <p><strong>Interview Details:</strong></p>
    <ul>
        <li><strong>Company:</strong> {tenant_name}</li>
        <li><strong>Job Title:</strong> {designation}</li>
        <li><strong>Interview Platform:</strong> <a href="https://aiinterview.ideas2it.com">AI INTERVIEW</a></li>
        <li><strong>Duration:</strong> The interview will take approximately 1 hour to complete.</li>
    </ul>

    <p><strong>Instructions:</strong></p>
    <ol>
        <li>Visit <a href="{interview_link}">Here</a> to start your interview.</li>
        <li>Ensure you are in a quiet environment with a stable internet connection.</li>
        <li>Please have your identification and any relevant materials ready.</li>
        <li>Complete the interview process within 48 hours of this invitation.</li>
    </ol>

    <p>We understand your time is valuable, and we have designed this process to be as smooth as possible. 
    Should you encounter any technical difficulties or have questions, please do not hesitate to reach out.</p>

    <p>We look forward to learning more about you.</p>

    <p>Thanks and regards,<br>
    Team <em>AIInterview</em><br>
    On behalf of {tenant_name}</p>
"""

INVITE_QESTIONER_MANAGER = """
<p>Dear <strong>{user_name}</strong>,</p>

    <p>We hope this message finds you in the best of spirits and creativity.</p>

    <p>We at {tenant_name} believe that your expertise and passion for innovation in hiring aligns perfectly with us.
    As we continually strive to refine our selection process, we are excited to have a talented individual like you to join us as an <strong>Interview Designer</strong> for some of the roles we have.</p>

    <h3>Embark on the interesting journey of:</h3>
    <ul>
    <li><strong>Crafting a dynamic question bank,</strong> - Utilize your unique flair to formulate questions that challenge and engage.</li>
    <li><strong>Curating the perfect model interviews,</strong> - Architect model interviews that will serve as a benchmark for assessing the brightest minds.</li>
    <li><strong>and add more contributors who can add depth and diversity to our interview content.</strong> - Assemble a team of contributors who can bring fresh perspectives to our question bank.</li>
    </ul>
    <p>Your role is pivotal in sculpting the path to discovering future talent for {tenant_name}.</p>

    <p>We believe your expertise will be instrumental in enriching the candidate assessment experience and ensuring our interview process 
    not only identifies the most skilled applicants but also echoes the innovative spirit of {tenant_name}.</p>

    <p><strong>Your Credentials:</strong></p>
    <ol>
        <li><strong>Visit    :</strong> <a href="https://aiinterview.ideas2it.com">Interview Designer Dashboard</a> to start your interview.</li>
        <li><strong>Tenant   :</strong> {tenant_name}</li>
        <li><strong>Username :</strong> {email_id}</li>
        <li><strong>Password :</strong> {password_given}</li>
    </ol>

    <p>Let's redefine the art of interviewing together!</p>

    <p>Thanks and regards,<br>
    Team <em>AIInterview</em><br>
    On behalf of {tenant_name}</p>
"""

INVITE_QESTIONER_MANAGER_SUB = """Invitation to Collaborate as an Interview Designer at {tenant_name}"""

INVITE_ADMIN = """
<p>Dear <strong>{user_name},</strong></p>
    
    <p>Warm greetings from the {tenant_name} family!</p>

    <p>We are delighted to extend to you an exclusive invitation to join our innovative team as an Interview Administrator. This unique role is designed to harness your organizational prowess and keen insight into talent acquisition, shaping the future of hiring at {tenant_name}.</p>

    <h3>Your New Adventure Awaits!</h3>

    <p>As an Interview Administrator, you will be the architect behind our interviewing landscape. Your journey will begin at the helm of our designation directory, where you will lay the groundwork by identifying and adding vacant positions that beckon top-tier talent.</p>

    <h4>Your Role:</h4>
    <ul>
      <li>Addition of positions, paving the way for potential candidates.</li>
      <li>Appoint and oversee Interview Design Managers, ensuring our interview content is nothing short of exceptional.</li>
      <li>Enlist Question Contributors who can infuse the interview process with their expertise.</li>
      <li>Expand our administrative circle by bringing on board adept individuals like yourself.</li>
      <li>Craft and refine model interviews that encapsulate the essence of each role.</li>
      <li>Extend interview invitations to candidates and orchestrate their journey towards becoming part of {tenant_name}.</li>
      <li>Make the critical call on candidate selection, sculpting the bedrock of our company with each decision.</li>
    </ul>

    <h4>Your Toolkit Awaits:</h4>
    <p>Your personalized <a href="https://aiinterview.ideas2it.com" target="_blank">Administrator Dashboard</a> is ready and waiting for you to take the reins and steer us towards next-gen talent discovery.</p>
    <ol>
    <li><strong>Username :</strong> {email_id}</li>
    <li><strong>Password :</strong> {password_given}</li>
    </ol>
    
    <p>Dive in at: <a href="https://aiinterview.ideas2it.com" target="_blank">https://aiinterview.ideas2it.com</a></p>

    <h4>The {tenant_name} Odyssey:</h4>
    <p>At {tenant_name}, we are not just a team; we are explorers in the realm of possibilities, enablers of innovation, and creators of a future where every interview is an avenue of potential and every candidate interaction, a step towards excellence.</p>

    <h4>Embrace Your Role:</h4>
    <p>This is not just an invitation; it's a gateway to influence the trajectory of careers and the growth of {tenant_name}. Your expertise and decisions will echo through the corridors of potential and resonate with the aspirations of countless professionals.</p>

    <p>We are thrilled at the prospect of you bringing your unique strengths to our quest for excellence. Together, let's shape the future of {tenant_name}, one interview at a time.</p>

    <p>Thanks and regards,<br>
    Team <em>AIInterview</em><br>
    On behalf of {tenant_name}</p>
"""

INVITE_ADMIN_SUB = """Exclusive Invitation to Become an Interview Administrator at {tenant_name}"""

INVITE_QESTIONER = """
<p>Dear <strong>{user_name}</strong>,</p>

    <p>We are thrilled to extend a very special invitation for you to join the {tenant_name} family in a pivotal role that shapes the future: as a Question Contributor for a given designation on our esteemed recruitment platform.</p>

    <p>As a steward of our question bank, your expertise will be the beacon that guides aspiring candidates through the intricate dance of interviews. Your crafted questions will not only gauge the proficiency of candidates but will also kindle the fires of challenge and innovation.</p>

    <h3>Here's what you're stepping into:</h3>
    <ul>
      <li><strong>Role:</strong> Question Contributor for a given role</li>
      <li><strong>Platform:</strong> <a href="http://aiinterview.ideas2it.com" target="_blank">aiinterview.ideas2it.com</a></li>
      <li><strong>Mission:</strong> Infuse the interview process with questions that mirror the perfect balance of difficulty and discernment, ensuring a robust and fair evaluation of each candidate's prowess.</li>
    </ul>

    <h3>Your Canvas:</h3>
    <p><strong>Login at:</strong> <a href="http://aiinterview.ideas2it.com" target="_blank">aiinterview.ideas2it.com</a><br>
    <strong>Username:</strong> {email_id}<br>
    <strong>Password:</strong> {password}</p>

    <h3>Crafting the Experience:</h3>
    <p>Your questions will be the milestones in a candidate's journey to join {tenant_name}. They should be thought-provoking, challenging yet fair, and aim to draw out the best in each interviewee, providing a clear picture of their capabilities.</p>

    <h3>Your Impact:</h3>
    <p>As a Question Contributor, you are not just creating questions; you are curating an experience, an encounter that candidates will approach with determination and leave with insights into their own potential.</p>

    <h3>Next Steps:</h3>
    <p>We're eager to see the ingenuity you'll bring to our platform and the ways in which you will challenge the minds of our candidates.</p>

    <p>Together, we will create the ultimate interview experience that discovers talent and fosters growth.</p>

    <p>Thanks and regards,<br>
    Team <em>AIInterview</em><br>
    On behalf of {tenant_name}</p>
"""

INVITE_QESTIONER_SUB = """Join Us as a Question Contributor for Interviews at {tenant_name}"""
