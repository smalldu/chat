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
  static let kMessageListChanged = Notification.Name("message.listChanged") // 聊天人数改变
}

var currentUID = "123"
var list: [String: String] = [:]
class DScoket {
  
  static let shared = DScoket()
  var manager = SocketManager(socketURL: URL(string: "http://chat.smalldu.top")!, config: [.log(true)])
  var client: SocketIOClient
  
  // socket 进行初始化
  init(){
    self.client = manager.socket(forNamespace: "/chat")
    
    client.on(clientEvent: .connect) { [weak self] data, ack in
      guard let `self` = self else { return }
      print(data)
      print("已连接")
      // 绑定用户
      self.client.emit("bind",["uid": currentUID])
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
    
    
    client.on("broad") { (data, eck) in
      print("收到服务器广播 \(data) , \(eck)")
      list.removeAll()
      for item in data {
        if let item = item as? [String: String] {
          list = item
        }
      }
      NotificationCenter.default.post(name: NSNotification.Name.kMessageListChanged , object: nil)
    }
    
    
  }
  
  // 发送消息
  func send(value: String , to: String ){
    self.client.emit("private_message",["content":value ,"uid": currentUID ,"to": to ])
  }
  
  func connect(){
    client.connect()
  }
  
  func disconnect(){
    self.client.disconnect()
  }
}



