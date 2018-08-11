//
//  ViewController.swift
//  chat-ios
//
//  Created by 杜哲 on 2018/8/10.
//  Copyright © 2018年 duzhe. All rights reserved.
//

import UIKit
import SocketIO

class ViewController: UIViewController {
  
  @IBOutlet weak var valueField: UITextField!
  
  var manager: SocketManager!
  var socketIOClient: SocketIOClient!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  
  @IBAction func sendMsg(_ sender: Any) {
    valueField.resignFirstResponder()
    let value = valueField.text ?? ""
    socketIOClient.emit("client_event",["data":value,"user":2])
  }
  
  @IBAction func connectSocket(_ sender: Any) {
    manager = SocketManager(socketURL: URL(string: "http://localhost:5000")!, config: [.log(true)])
    socketIOClient = manager.defaultSocket
    socketIOClient.on(clientEvent: .connect) {data, ack in
      print(data)
      print("已连接")
    }
    
    socketIOClient.on(clientEvent: .error) { (data, eck) in
      print(data)
      print("发生错误")
    }
    
    socketIOClient.on(clientEvent: .disconnect) { (data, eck) in
      print(data)
      print("已断开")
    }
    
    socketIOClient.on(clientEvent: .reconnect) { (data, eck) in
      print(data)
      print("重新连接")
    }
    
    socketIOClient.on("client_event") { (data, eck) in
      print("收到服务器端回的信息\(data)")
    }
    
    socketIOClient.connect()
  }
  
  @IBAction func dissconnect(_ sender: Any) {
    socketIOClient.disconnect()
  }
}


