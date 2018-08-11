from flask import Flask, render_template, session, request
from flask_socketio import SocketIO, emit , send

app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret!'

socketio = SocketIO(app, async_mode='eventlet')

@app.route('/')
def index():
    return render_template('index.html')

@socketio.on('client_event')
def test_message(message):
    print("收到有个小子发来的信息{}".format(message))
    if message["user"] == 1:
        emit('client_event', {'data': message['data']})

    else:
        emit('client_event', {'data': message['data']})

@socketio.on('my broadcast event')
def test_message(message):
    emit('my response', {'data': message['data']}, broadcast=True)

@socketio.on('connect')
def test_connect():
    print("有个小子连接上了")
    emit('my response', {'data': 'Connected'})

@socketio.on('disconnect')
def test_disconnect():
    print("有个小子断开了连接")
    print('Client disconnected')


if __name__ == '__main__':
    socketio.run(app, debug=True)
