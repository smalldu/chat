//
//  DSocket.swift
//  chat-ios
//
//  Created by zuber on 2018/8/13.
//  Copyright © 2018年 duzhe. All rights reserved.
//

import Foundation
import SocketIO

extension Notification.Name {
  static let kMessageRecieved = Notification.Name("message.recieved") // 收到消息
    
}

class DScoket {
  
  static let shared = DScoket()
  var manager = SocketManager(socketURL: URL(string: "http://localhost:5000")!, config: [.log(true)])
  var client: SocketIOClient
  
  
  // socket 进行初始化
  init(){
    self.client = manager.socket(forNamespace: "/chat")
    
    client.on(clientEvent: .connect) { [weak self] data, ack in
      guard let `self` = self else { return }
      print(data)
      print("已连接")
      // 绑定用户
      self.client.emit("bind",["uid":self.uid])
    }
    
    client.on(clientEvent: .error) { (data, eck) in
      print(data)
      print("发生错误")
    }
    
    client.on(clientEvent: .disconnect) { (data, eck) in
      print(data)
      print("已断开")
    }
    
    client.on(clientEvent: .reconnect) { (data, eck) in
      print(data)
      print("重新连接")
    }
    
    
    client.on("private_message") { (data, eck) in
      print("收到服务器端回的信息\(data)")
      for item in data{
        print(item)
        if let item = item as? [String: Any] {
          if let uid = item["uid"] as? String,let toUid = item["to"] as? String, let content = item["content"] as? String,
            let time = item["time"] as? String{
            let message = Message(time: time, uid: uid, toUid: toUid, content: content)
            messages.append(message)
            NotificationCenter.default.post(name: NSNotification.Name.kMessageRecieved , object: nil)
          }
        }
      }
    }
  }
  
  var uid: String = "123"
  
  // 发送消息
  func send(value: String , to: String ){
    self.client.emit("private_message",["content":value ,"uid": uid ,"to": to ])
  }
  
  func connect(){
    client.connect()
  }
  
  func disconnect(){
    self.client.disconnect()
  }
  
}



