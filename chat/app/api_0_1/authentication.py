
from flask_httpauth import HTTPBasicAuth
from flask import g,jsonify
from app.models import User
from .errors import unauthorized,forbidden_error
from . import api

auth = HTTPBasicAuth()

@auth.error_handler
def auth_error():
    return unauthorized('Invalid credential')

@auth.verify_password
def verify_password(token_or_email,password):
    print('-----yes{},{}'.format(token_or_email,password))
    if password == '':
        g.current_user = User.verify_auth_token(token_or_email)
        g.token_used = True
        return g.current_user is not None
    user = User.query.filter_by(email=token_or_email).first()
    print('-----user is {}'.format(user.username))
    if not user:
        return False
    g.current_user = user
    g.token_used = False
    return user.verify_password(password)

@api.route('/token')
def get_token():
    if g.token_used:
        return unauthorized('Invalid credentials')
    token = g.current_user.generate_auth_token(
             expiration=3600)
    return jsonify({ 'token': token.decode('utf-8'), 'expiration': 3600 })

# 为了保护路由 可以使用修饰器

@api.route('/posts/')
@auth.login_required
def get_posts():
    pass


# 由于蓝本中所有路由都要使用相同的方式进行保护 可以放在befor_request

@api.before_request
@auth.login_required
def before_request():
    if not g.current_user:
        return forbidden_error('Unconfirmed account')





