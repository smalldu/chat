//
//  ChatViewController.swift
//  chat-ios
//
//  Created by zuber on 2018/8/13.
//  Copyright © 2018年 duzhe. All rights reserved.
//

import UIKit
import SnapKit

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

class ChatViewController: UIViewController {
  
  var tableView: UITableView!
  
  public private(set) var inputContainer: UIView!
  public private(set) var bottomSpaceView: UIView!
  private var inputContainerBottomConstraint: Constraint!
  
  var items: [Message] {
    return messages.filter({ ($0.uid == chatUid && $0.toUid == currentUID) || ($0.uid == currentUID && $0.toUid == chatUid) })
  }
  
  let chatUid: String
  init(chatUid: String) {
    self.chatUid = chatUid
    super.init(nibName: nil , bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private var notificationCenter: NotificationCenter!
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableViewAutomaticDimension
    notificationCenter = NotificationCenter.default
    tableView.register(UINib(nibName: "ChatCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
    addInputViews()
    addBottomSpaceView()
    addTableView()
    
    notificationCenter.addObserver(self, selector: #selector(reloadSelf), name: NSNotification.Name.kMessageRecieved, object: nil)
    setupNotificationCenter()
  }
  
  func setupNotificationCenter(){
    self.notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    self.notificationCenter.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    self.notificationCenter.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    self.notificationCenter.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    self.notificationCenter.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
  }
  
  func createChatInputView() -> ChatInputView {
    let chatInputView = ChatInputView.loadNib()
    chatInputView.delegate = self
    return chatInputView
  }
  
  func addTableView(){
    view.addSubview(tableView)
    tableView.snp.makeConstraints { (make) in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.left.right.equalToSuperview()
      make.bottom.equalTo(inputContainer.snp.top)
    }
  }
  
  func addInputViews() {
    inputContainer = UIView(frame: CGRect.zero)
    inputContainer.autoresizingMask = UIView.AutoresizingMask()
    view.addSubview(inputContainer)
    inputContainer.snp.makeConstraints { (make) in
      make.right.left.equalToSuperview()
      make.top.greaterThanOrEqualTo(view.safeAreaLayoutGuide.snp.top)
      inputContainerBottomConstraint = make.bottom.equalToSuperview().constraint
    }
    let chatInputView = self.createChatInputView()
    inputContainer.addSubview(chatInputView)
    chatInputView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  func addBottomSpaceView() {
    self.bottomSpaceView = UIView(frame: CGRect.zero)
    self.bottomSpaceView.autoresizingMask = UIView.AutoresizingMask()
    self.bottomSpaceView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(self.bottomSpaceView)
    bottomSpaceView.snp.makeConstraints { (make) in
      make.left.right.equalToSuperview()
      make.bottom.equalToSuperview()
      make.top.greaterThanOrEqualTo (inputContainer.snp.bottom)
    }
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
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    Helper.hideKeyboard()
  }
  
}

extension ChatViewController {
  
  @objc
  private func keyboardWillShow(_ notification: Notification) {
//    NotificationCenter.default.post(name: NSNotification.Name.kHideInputCommonViewNf , object: nil)  // 先隐藏底部
    let bottomConstraint = self.bottomConstraintFromNotification(notification)
    guard bottomConstraint > 0 else { return } // Some keyboards may report initial willShow/DidShow notifications with invalid positions
    inputContainerBottomConstraint.update(inset: bottomConstraint)
  }
  
  @objc
  private func keyboardDidShow(_ notification: Notification) {
    let bottomConstraint = self.bottomConstraintFromNotification(notification)
    guard bottomConstraint > 0 else { return } // Some keyboards may report initial willShow/DidShow notifications with invalid positions
    inputContainerBottomConstraint.update(inset: bottomConstraint)
  }
  
  @objc
  private func keyboardWillChangeFrame(_ notification: Notification) {
  }
  
  @objc
  private func keyboardWillHide(_ notification: Notification) {
    inputContainerBottomConstraint.update(inset: 0)
  }
  
  @objc
  private func keyboardDidHide(_ notification: Notification) {
    inputContainerBottomConstraint.update(inset: 0)
  }
  
  private func bottomConstraintFromNotification(_ notification: Notification) -> CGFloat {
    guard let rect = ((notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return 0 }
    guard rect.height > 0 else { return 0 }
    let rectInView = self.view.convert(rect, from: nil)
    return max(0, self.view.bounds.height - rectInView.minY)
  }
  
}

extension ChatViewController: ChatInputViewDelegate {
  
  func chatInput(sendTextView textView: ExpandableTextView, text: String) {
    if text.isEmpty{
      return
    }
    DScoket.shared.send(value: text, to: chatUid)
    let message = Message(time: Date().toString() , uid: currentUID, toUid: chatUid, content: text)
    messages.append(message)
    self.tableView.reloadData()
  }
  
  func chatInput(chatInputView: ChatInputView, didClickEmojiSwitch: Bool) {
    
  }
  
  func chatInput(chatInputView: ChatInputView, didClickMoreViewSwitch: Bool) {
    
  }
  
  func chatInputDidClickMyRoom(chatInputView: ChatInputView) {
    
  }
  
  func chatInputDidClickPosition(chatInputView: ChatInputView) {
    
  }
  
  func chatInputStartRecord(_ view: ChatInputView) {
    
  }
  
  func chatInputEndRecord(_ view: ChatInputView) {
    
  }
  
  func chatInputCancelSend(_ view: ChatInputView) {
    
  }
  
  func chatInputCancel(_ view: ChatInputView) {
    
  }
  
  func chatInputCragInside(_ view: ChatInputView) {
    
  }
  
  func chatInputDidClickDeposite(_ view: ChatInputView) {
    
  }
  
  func chatInputDidClickContract(_ view: ChatInputView) {
    
  }
  
  func chatInputDidClickEvaluate(_ view: ChatInputView) {
    
  }
  
  
}


