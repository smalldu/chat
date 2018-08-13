//
//  ChatViewController.swift
//  chat-ios
//
//  Created by zuber on 2018/8/13.
//  Copyright © 2018年 duzhe. All rights reserved.
//

import UIKit

struct Message {
  var time: String
  var uid: String
  var toUid: String
  var content: String
}

extension Date{
  
  // 时间转字符串
  func toString()->String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let str = dateFormatter.string(from: self)
    return str
  }
  
}

var messages: [Message] = []
let uid = "123"


class ChatViewController: UIViewController {
  
  @IBOutlet weak var bottomView: UIView!
  @IBOutlet weak var sendButton: UIButton!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var tableView: UITableView!
  
  var items: [Message] {
    return messages.filter({ ($0.uid == chatUid && $0.toUid == uid) || ($0.uid == uid && $0.toUid == chatUid) })
  }
  
  let chatUid: String
  init(chatUid: String) {
    self.chatUid = chatUid
    super.init(nibName: "ChatViewController", bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableViewAutomaticDimension
    
    tableView.register(UINib(nibName: "ChatCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
    sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
    NotificationCenter.default.addObserver(self, selector: #selector(reloadSelf), name: NSNotification.Name.kMessageRecieved, object: nil)
  }
  
  @objc func send(){
    textField.resignFirstResponder()
    let value = textField.text ?? ""
    if value.isEmpty{
      return
    }
    DScoket.shared.send(value: value, to: chatUid)
    let message = Message(time: Date().toString() , uid: uid, toUid: chatUid, content: value)
    messages.append(message)
    self.tableView.reloadData()
  }
  
  @objc func reloadSelf(){
    self.tableView.reloadData()
  }
  
}

extension ChatViewController: UITableViewDataSource,UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatCell
    cell.config(message: items[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
}

