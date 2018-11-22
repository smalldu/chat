import os

from app import create_app, db, socketio
from server.chat import Chat
from flask_script import Manager, Shell
from flask_migrate import Migrate, MigrateCommand

app = create_app('development')
manager = Manager(app=app)
socketio.on_namespace(Chat('/chat'))

def make_shell_context():
    return dict(app=app, db=db)

manager.add_command("shell", Shell(make_context=make_shell_context))
manager.add_command('run', socketio.run(app=app, host='127.0.0.1', port=8000,debug=True))

if __name__ == '__main__':
    manager.run()

