from flask import Blueprint, request, flash, redirect

from app.resume_parser.service import upload_file
resume_parser_blueprint = Blueprint('resume_parser_blueprint', __name__)


@resume_parser_blueprint.route('/', methods=['GET','POST'])
def generate():
    if request.method == 'POST':

        if "file" in request.files:
            res = upload_file(request)
            return res
        else:    
            flash("No file part")
            return redirect(request.url)

        
        
