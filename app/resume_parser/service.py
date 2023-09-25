from  flask import redirect, flash
from werkzeug.utils import secure_filename

import os
from langchain.document_loaders import PyPDFLoader
from app.resume_parser.resume_parse import doc_parser


gpt_prompt = {"role": "system",
              "content": "you are designed for answer user questions."}

ALLOWED_EXTENSIONS = {"txt", "pdf", "png", "jpg", "jpeg", "gif"}

def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS

def upload_file(request):
    
    try:
        path = os.path.abspath(os.path.dirname(__file__))
        upload_folder = os.path.join(path.replace("/file_folder", ""), "resume_docs")
        os.makedirs(upload_folder, exist_ok=True)
        
        file = request.files["file"]
        if file.filename == "":
            flash("No selected file")
            return redirect(request.url)
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(upload_folder, filename))

        loader = PyPDFLoader(os.path.join(upload_folder, filename))
        global documents
        documents = loader.load()
        global given_role
        given_role = request.form['given_role']

        global given_domain
        given_domain = request.form["given_domain"]
        return doc_parser(documents, given_role, given_domain)
    except Exception as e:
        return f'exception error {e}'
