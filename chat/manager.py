from flask import Flask, render_template, session, request
from flask_socketio import SocketIO, emit , send
from datetime import datetime
app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret!'

socketio = SocketIO(app, async_mode='eventlet')
online_list = {}

@app.route('/')
def index():
    print(online_list)
    return render_template('index.html',lst = online_list)

# 绑定用户
@socketio.on('bind',namespace='/chat')
def bind(data):
    print('sid is {}'.format(request.sid))
    uid = data['uid']
    online_list[uid] = request.sid
    print("在线用户 {}".format(online_list))

@socketio.on('private_message',namespace='/chat')
def message(data):
    print('sid is {}'.format(request.sid))
    print("收到有个小子发来的信息{}".format(data))
    data['time'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    to_sid = online_list[data['to']]
    emit('private_message', data, room=to_sid)

@socketio.on('connect',namespace='/chat')
def connect():
    print("有个小子{}连接上了".format(request.sid))
    emit('my response', {'data': 'Connected'})

@socketio.on('disconnect',namespace='/chat')
def disconnect():
    # 翻转后删除key
    new_dict = {v: k for k, v in online_list.items()}
    keys = new_dict[request.sid]
    del online_list[keys]
    print(online_list)
    print("有个小子{}断开了连接".format(request.sid))

if __name__ == '__main__':
    socketio.run(app, debug=True)


