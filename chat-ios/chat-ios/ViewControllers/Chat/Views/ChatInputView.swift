//
//  ChatInputView.swift
//  ZuberChat
//  聊天的输入框
//  Created by duzhe on 2017/2/6.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

protocol ChatInputViewDelegate: class{
  func chatInputView(_ view: ChatInputView , didSend text: String)
}


class ChatInputView: ReusableXibView {
  
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var lineView: UIView!
  @IBOutlet weak var textView: ExpandableTextView!
  
  weak var delegate: ChatInputViewDelegate?
  
  override class func nibName() -> String {
    return "ChatInputView"
  }
  
  class open func loadNib() -> ChatInputView {
    let view = Bundle(for: self).loadNibNamed(self.nibName(), owner: nil, options: nil)!.first as! ChatInputView
    view.translatesAutoresizingMaskIntoConstraints = false
    view.frame = CGRect.zero
    return view
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  
  private func setup() {
    backgroundColor = .white
    topView.backgroundColor = .white
    layer.borderColor = UIColor.lightBorder.cgColor
    layer.borderWidth = 0.5
    setupTextView()
  }
  
  // 配置 textView
  private func setupTextView(){
    textView.scrollsToTop = false
    textView.delegate = self
    textView.font = UIFont.systemFont(ofSize: 15)
    textView.backgroundColor = UIColor.white
    textView.contentInset = UIEdgeInsets.zero
    textView.returnKeyType = .send
    textView.enablesReturnKeyAutomatically = true
  }
  
}

// MARK: - UITextViewDelegate

extension ChatInputView: UITextViewDelegate {
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if text != "\n" {
      return true
    }else{
      // 发送按钮
      delegate?.chatInputView(self, didSend: textView.text)
      textView.text = ""
      return false
    }
  }
  
}






















