from flask import Flask, render_template, session, request
from flask_socketio import SocketIO, emit

app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret!'

socketio =  SocketIO(app, async_mode='eventlet')


@app.route('/')
def index():
    return render_template('index.html')


@socketio.on('message')
def handle_message(message):
    print('received message: ' + message)

@socketio.on('client_event')
def client_msg(msg):
    print('msg client = {}'.format(msg))
    emit('server_response', {'data': msg['data']})


@socketio.on('connect_event')
def connected_msg(msg):
    print('msg = {}'.format(msg))
    emit('server_response', {'data': msg['data']})


if __name__ == '__main__':
    socketio.run(app, debug=True)
