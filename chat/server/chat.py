from flask import request
from flask_socketio import emit,Namespace
from datetime import datetime

online_list = {}

class Chat(Namespace):

    def on_connect(self):
        print("有个小子{}连接上了".format(request.sid))

    def on_disconnect(self):
        # 翻转后删除key
        new_dict = {v: k for k, v in online_list.items()}
        keys = new_dict[request.sid]
        del online_list[keys]
        emit('broad', online_list, namespace='/chat', broadcast=True)
        print("有个小子{}断开了连接".format(request.sid))

    def on_private_message(self,data):
        print('sid is {}'.format(request.sid))
        print("收到有个小子发来的信息{}".format(data))
        data['time'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        to_sid = online_list[data['to']]
        emit('private_message', data, room=to_sid)

    def on_bind(self,data):
        print('sid is {}'.format(request.sid))
        uid = data['uid']
        online_list[uid] = request.sid
        emit('broad', online_list , namespace='/chat' , broadcast=True) # 给所有用户
        print("在线用户 {}".format(online_list))