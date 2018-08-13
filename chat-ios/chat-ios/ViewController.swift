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
  
  @IBOutlet weak var tableView: UITableView!
  
  var items = ["456"]
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "聊天列表"
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = 50
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }
  
  
  @IBAction func connect(_ sender: Any) {
    DScoket.shared.connect()
  }
  
  @IBAction func dissconnect(_ sender: Any) {
    DScoket.shared.disconnect()
  }
}

extension ViewController: UITableViewDataSource,UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = items[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let chatUid = items[indexPath.row]
    let chatController = ChatViewController(chatUid: chatUid)
    self.navigationController?.pushViewController(chatController, animated: true)
  }
  
}

























