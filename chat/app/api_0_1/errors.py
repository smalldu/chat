from flask import jsonify


def unauthorized(message):
    response = jsonify({'error':'未授权','message':message})
    response.status_code = 401
    return response

def forbidden_error(message):
    response = jsonify({'error': 'forbidden', 'message': message})
    response.status_code = 403
    return response