import os


class Config:
    SECRET_KEY = 'WWUI1329329001OOLWNLERWKJKLJR19P'
    MAIL_SERVER = 'smtp.163.com'
    MAIL_PORT = 465
    MAIL_USE_TLS = False
    MAIL_USE_SSL = True
    MAIL_USERNAME = 'stonedu04@163.com'  # os.environ.get('MAIL_USERNAME')
    MAIL_PASSWORD = 'smalldu223'  # os.environ.get('MAIL_PASSWORD')
    SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://root:root123@39.106.15.69/chat'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_COMMIT_ON_TEARDOWN = True

    @staticmethod
    def init_app(app):
        pass


config = {
    'development': Config,
    'default': Config
}