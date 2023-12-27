from app.commons.custom_error import CustomError
from  flask import redirect, flash
from werkzeug.utils import secure_filename

import os
from langchain.document_loaders import PyPDFLoader
from app.resume_parser.resume_parse import doc_parser


gpt_prompt = {"role": "system",
              "content": "you are designed for answer user questions."}

ALLOWED_EXTENSIONS = {"txt", "pdf"}

def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS

def upload_file(request):
    
    try:
        path = os.path.abspath(os.path.dirname(__file__))
        upload_folder = os.path.join(path.replace("/file_folder", ""), "resume_docs")
        os.makedirs(upload_folder, exist_ok=True)
        
        if ('file' not in request.files or request.files["file"].filename == ''):
            raise CustomError('Resume File not found', 400)
        file = request.files["file"]
        if ('given_role'  not in request.form or request.form['given_role'] == ''):
            raise CustomError('Role not provided', 400)
        if ('given_domain' not in request.form or request.form['given_domain'] == '' ):
            raise CustomError('Domain not provided', 400)
        if file and not allowed_file(file.filename):
            raise CustomError('File format not supported', 400)
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(upload_folder, filename))

        loader = PyPDFLoader(os.path.join(upload_folder, filename))
        documents = loader.load()
        return doc_parser(documents, request.form['given_role'], request.form["given_domain"])
    except CustomError as e:
        raise e
