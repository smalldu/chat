from flask import Flask,render_template
from flask_socketio import SocketIO

from server.chat import Chat
app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret!'

socketio = SocketIO(app, async_mode='eventlet')
online_list = {}

@app.route('/')
def index():
    print(online_list)
    return render_template('index.html',lst = online_list)


@socketio.on_error('/chat')
def error_handler_chat(e):
    print('发生错误{}'.format(e))

socketio.on_namespace(Chat('/chat'))

if __name__ == '__main__':
    socketio.run(app, debug=True)



























