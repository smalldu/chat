from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_socketio import SocketIO
from config import config
from flask_login import LoginManager

db = SQLAlchemy()
async_mode = 'eventlet'
socketio = SocketIO()
login_manager = LoginManager()
login_manager.session_protection = 'strong'
login_manager.login_view = 'auth.login'

def create_app(config_name):
    app = Flask(__name__)

    app.config.from_object(config[config_name])
    config[config_name].init_app(app=app)

    db.init_app(app=app)
    login_manager.init_app(app=app)
    socketio.init_app(app=app, async_mode=async_mode)

    # 注册蓝本
    from .main import main as main_blueprint
    app.register_blueprint(main_blueprint)
    from .auth import auth as auth_blueprint
    app.register_blueprint(auth_blueprint, url_prefix='/auth')
    from .api_0_1 import api as api_0_1_blueprint
    app.register_blueprint(api_0_1_blueprint , url_prefix='/api/v1.0')

    return app


