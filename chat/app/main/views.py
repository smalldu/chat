from flask import  render_template
from . import main
from flask_login import login_required
from server.chat import *

@main.route('/')
@login_required
def index():
    return render_template('index.html',lst = online_list)