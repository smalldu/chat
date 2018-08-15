
from flask_httpauth import HTTPBasicAuth
from flask import g
from app.models import User
auth = HTTPBasicAuth()

@auth.verify_password
def verify_password(email,password):
    # user = User.
    pass



