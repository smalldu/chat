//
//  ChatInputView.swift
//  ZuberChat
//  聊天的输入框
//  Created by duzhe on 2017/2/6.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit


let f8f8f8 = UIColor(red: 0xf8/255, green: 0xf8/255, blue: 0xf8/255, alpha: 1)
let dddddd = UIColor(red: 0xdd/255, green: 0xdd/255, blue: 0xdd/255, alpha: 1)
let b6b6b6 = UIColor(red: 0xb6/255, green: 0xb6/255, blue: 0xb6/255, alpha: 1)
let f0f0f0 = UIColor(red: 0xf0/255, green: 0xf0/255, blue: 0xf0/255, alpha: 1)
let e2e2e2 = UIColor(red: 0xe2/255, green: 0xe2/255, blue: 0xe2/255, alpha: 1)

protocol ChatInputViewDelegate: class {
  // 发送
  func chatInput(sendTextView textView:ExpandableTextView,text:String)
  func chatInput(chatInputView:ChatInputView,didClickEmojiSwitch:Bool)
  func chatInput(chatInputView:ChatInputView,didClickMoreViewSwitch:Bool)
  
  // 我的房源
  func chatInputDidClickMyRoom(chatInputView: ChatInputView)
  func chatInputDidClickPosition(chatInputView: ChatInputView)
  
  // 语音相关
  func chatInputStartRecord(_ view:ChatInputView)
  func chatInputEndRecord(_ view:ChatInputView)
  func chatInputCancelSend(_ view:ChatInputView)
  func chatInputCancel(_ view:ChatInputView)
  func chatInputCragInside(_ view:ChatInputView)
  
  // 操作相关
  func chatInputDidClickDeposite(_ view: ChatInputView)
  func chatInputDidClickContract(_ view: ChatInputView)
  func chatInputDidClickEvaluate(_ view: ChatInputView)
}

class ChatInputView: ReusableXibView {
  
  @IBOutlet weak var voiceBtn:UIButton! // 左边语音按钮
  @IBOutlet weak var emojBtn:UIButton! // 表情按钮
  @IBOutlet weak var utilityBtn:UIButton! // 工具按钮
  @IBOutlet weak var textView:ExpandableTextView! // 文本
  weak var delegate:ChatInputViewDelegate?
  
  @IBOutlet weak var evaluateBtn: UIButton!
  @IBOutlet weak var depositeBtn: UIButton!
  @IBOutlet weak var contractBtn: UIButton!
  @IBOutlet weak var opNameLabel: UILabel!
  
  @IBOutlet weak var topView:UIView!
  @IBOutlet weak var commonView:UIView! // 显示表情和工具箱的视图
  @IBOutlet weak var commonViewHeightConstraint:NSLayoutConstraint!
  @IBOutlet weak var recordBtn: ChatRecordButton! // 录音按钮
  
  @IBOutlet weak var textTopMargin: NSLayoutConstraint!
  @IBOutlet weak var voiceTopMargin: NSLayoutConstraint!
  
  lazy var emojiView: ChatEmojiView = ChatEmojiView()
  lazy var moreView: ChatMoreView = ChatMoreView()
  
  
  let originTextHeight:CGFloat = 34
  var changedTextHeight:CGFloat = 0
  var emojiSwitch:Bool = false
  var utilitySwitch:Bool = false
  var voiceSwitch:Bool = false
  
  class open func loadNib() -> ChatInputView {
    let view = Bundle(for: self).loadNibNamed(self.nibName(), owner: nil, options: nil)!.first as! ChatInputView
    view.translatesAutoresizingMaskIntoConstraints = false
    view.frame = CGRect.zero
    return view
  }
  
  var text: String? {
    set{
      self.textView.text = newValue
    }
    get{
      return self.textView.text
    }
  }
  
  override class func nibName() -> String {
    return "ChatInputView"
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.backgroundColor = UIColor.white
    self.layer.borderWidth = 0.5
    self.layer.borderColor = UIColor.lightGray.cgColor
    let tapTop = UITapGestureRecognizer(target: self, action: #selector(clickCommon) )
    self.topView.addGestureRecognizer(tapTop)
    self.topView.backgroundColor = UIColor.white
    setupTextView()
    setupEmoji()
    setupMoreView()
    setupOtherView()
  }
  
  // 设置 textview
  func setupTextView(){
    self.textView.scrollsToTop = false
    self.textView.delegate = self
    self.textView.font = UIFont.systemFont(ofSize: 15)
    self.textView.backgroundColor = UIColor.white
    self.textView.layer.cornerRadius = 4
    self.textView.layer.borderColor = UIColor.gray.cgColor
    self.textView.layer.borderWidth = 0.5
    self.textView.contentInset = UIEdgeInsets.zero
    textView.returnKeyType = .send
    textView.enablesReturnKeyAutomatically = true
  }
  
  // 设置emoji
  func setupEmoji(){
    self.commonView.addSubview(self.emojiView)
    self.emojiView.backgroundColor = UIColor.white
    self.emojiView.delegate = self
    self.emojiView.snp.makeConstraints { (make) in
      make.left.right.top.bottom.equalToSuperview()
    }
    self.emojiView.hide()
    commonViewHeightConstraint.constant = 0
    commonView.isHidden = true
    commonView.backgroundColor = UIColor.clear
    let tapCommon = UITapGestureRecognizer(target: self, action: #selector(clickCommon) )
    self.commonView.addGestureRecognizer(tapCommon)
    NotificationCenter.default.addObserver(self, selector: #selector(hideCommonView) , name: NSNotification.Name.kHideInputCommonViewNf , object: nil)
    self.emojBtn.addTarget(self, action: #selector(clickEmoji(_:) ), for: UIControlEvents.touchUpInside )
  }

  func setupMoreView(){
    self.commonView.addSubview(self.moreView)
    self.moreView.backgroundColor = UIColor.white
    self.moreView.dataSource = self
    self.moreView.hide()
    self.moreView.delegate = self
    self.moreView.snp.makeConstraints { (make) in
      make.left.right.top.bottom.equalToSuperview()
    }
    self.utilityBtn.addTarget( self, action: #selector(clickAddMore(_:) ), for: .touchUpInside )
  }
  
  func reloadMoreView(){
    self.moreView.reload()
  }
  
  func setupOtherView(){
    voiceBtn.addTarget(self, action: #selector(clickRecord(_:)) , for: .touchUpInside)
//    self.recordBtn.delegate = self
    self.recordBtn.isHidden = true
    opNameLabel.font = UIFont.systemFont(ofSize: 12)
    opNameLabel.textColor = UIColor.lightGray
//    evaluateBtn.normal_title = "评价/投诉"
//    depositeBtn.normal_title = "签定金协议"
//    contractBtn.normal_title = "签租赁合同"
    opbuttonStyle(evaluateBtn)
    opbuttonStyle(depositeBtn)
    opbuttonStyle(contractBtn)
    evaluateBtn.addTarget(self, action: #selector(evaluateClick), for: .touchUpInside)
    depositeBtn.addTarget(self, action: #selector(depositeClick), for: .touchUpInside)
    contractBtn.addTarget(self, action: #selector(contractClick), for: .touchUpInside)
  }
  
  func opbuttonStyle(_ button: UIButton){
//    button.cornerRadius(12).border(0.5).border(UIColor.d9d9d9)
//    button.titleLabel?.font = UIFont.regularOf(12)
//    button.normal_color = UIColor.secondaryText
  }
  
  // 顶部操作栏显示状态
  func configOp(_ isBiz: Bool,isOffcial: Bool){
    if isOffcial {
      opNameLabel.isHidden = true
      evaluateBtn.isHidden = true
      depositeBtn.isHidden = true
      contractBtn.isHidden = true
      textTopMargin.constant = 6
      voiceTopMargin.constant = 11
      layoutIfNeeded()
    }else if isBiz{
      depositeBtn.isHidden = true
      contractBtn.isHidden = true
    }
  }
  
  @objc func evaluateClick(){
    delegate?.chatInputDidClickEvaluate(self)
  }
  @objc func depositeClick(){
    delegate?.chatInputDidClickDeposite(self)
  }
  @objc func contractClick(){
    delegate?.chatInputDidClickContract(self)
  }
  
  func isCommonViewShow () -> Bool {
    return commonViewHeightConstraint.constant > 0
  }
  
  @objc func hideCommonView(){
    if commonViewHeightConstraint.constant > 0 {
      setEmojSwitch( false )
      setMoreViewSwitch( false )
      commonViewHeightConstraint.constant = 0
      commonView.isHidden = true
      UIView.animate(withDuration: 0.25, animations: {
        self.layoutIfNeeded()
      })
    }
  }
  
  func selfHideCommonView(anamiated: Bool = true){
    if commonViewHeightConstraint.constant > 0 {
      handleSwitch()
      commonViewHeightConstraint.constant = 0
      commonView.isHidden = true
      UIView.animate(withDuration: anamiated ? 0.25:0.01, animations: {
        self.layoutIfNeeded()
      })
    }
  }
  func showCommonViewShow(){
    handleSwitch()
    commonViewHeightConstraint.constant = inputCommonViewHeight
    commonView.isHidden = false
    UIView.animate(withDuration: 0.25, animations: {
      self.layoutIfNeeded()
    })
  }
  
  // 处理隐藏标志
  func handleSwitch(){
    setEmojSwitch(self.emojiView.isVisible)
    setMoreViewSwitch(self.moreView.isVisible)
  }
  
  func stopEdit(){
    self.textView.resignFirstResponder()
  }
  @objc func clickCommon(){}
  func clickTop(){}
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

// MARK: UITextViewDelegate
extension ChatInputView: UITextViewDelegate {
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    textView.contentInset = UIEdgeInsets.zero
    setEmojSwitch( false )
    setMoreViewSwitch( false )
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if text != "\n" {
      return true
    }else{
      // 发送
      DispatchQueue.main.async {
        self.delegate?.chatInput(sendTextView: self.textView , text: textView.text)
        textView.text = ""
      }
      return false
    }
  }
}


extension ChatInputView:ChatEmojiDelegate{
  
  // 点击emoj
  @objc func clickEmoji(_ sender:UIButton){
    self.hideVoiceRecord(isSelf: false)
    self.setEmojSwitch(!self.emojiSwitch)
    self.moreView.hide()
    
    if self.emojiSwitch {
      self.emojiView.show()
      self.showCommonViewShow()
      self.textView.resignFirstResponder()
    }else{
      self.emojiView.hide()
      self.selfHideCommonView()
      self.textView.becomeFirstResponder()
    }
    delegate?.chatInput(chatInputView: self, didClickEmojiSwitch: self.emojiSwitch)
  }
  
  func setEmojSwitch( _ value:Bool) {
    self.emojiSwitch = value
    if self.emojiSwitch {
      self.emojBtn.setImage(UIImage(named: "input_normal"), for: UIControlState.normal)
    }else{
      self.emojBtn.setImage(UIImage(named: "input_emotion"), for: UIControlState.normal)
    }
  }
  
  
  // 发送
  func emojiViewSend(_ view: ChatEmojiView) {
    delegate?.chatInput(sendTextView: self.textView , text: textView.text)
    textView.text = ""
  }
  
  // 删除
  func emojiViewDelete(_ view: ChatEmojiView) {
    
    if self.textView.text.count == 0{
      return
    }
    if self.textView.text.count == 1 {
      self.textView.text = ""
    }
    if self.textView.text.count > 0 {
      let endIndex = self.textView.text.index(before: self.textView.text.endIndex )
      self.textView.text = self.textView.text.substring(to: endIndex )
    }else{
      self.textView.text = ""
    }
  }
  
  // 添加emoji
  func emojiView(_ view: ChatEmojiView, emoji: String) {
//    let string = self.textView.text
//    self.textView.text = "\(string.noNil)\(emoji)"
  }
}

// 点击语音
extension ChatInputView{
  
  @objc func clickRecord(_ sender:UIButton){
    if !voiceSwitch{
      self.showVoiceRecord()
    }else{
      self.hideVoiceRecord()
    }
  }
  
  func setRecordSwitch( _ value:Bool) {
    self.voiceSwitch = value
    if self.voiceSwitch {
      self.voiceBtn.setImage(UIImage(named: "input_normal"), for: .normal)
    }else{
      self.voiceBtn.setImage(UIImage(named: "zz_record_normal"), for: .normal)
    }
  }
  // 显示语音
  func showVoiceRecord(){
    textView.resignFirstResponder()
    hideCommonView()
    changedTextHeight = self.textView.contentSize.height
    textView.contentSize.height = self.originTextHeight
    recordBtn.isHidden = false
    textView.isHidden = true
    setRecordSwitch(true)
  }
  // 隐藏语音
  func hideVoiceRecord(isSelf:Bool = true){
    if changedTextHeight != 0 {
      self.textView.contentSize.height = changedTextHeight
    }
    if isSelf {
      self.textView.becomeFirstResponder()
    }
    recordBtn.isHidden = true
    self.textView.isHidden = false
    setRecordSwitch(false)
  }
  
}



