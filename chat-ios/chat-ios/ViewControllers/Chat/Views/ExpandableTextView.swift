//
//  ExpandableTextView.swift
//  ZuberChat
//
//  Created by duzhe on 2017/2/6.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit
open class ExpandableTextView: UITextView {
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.commonInit()
  }
  
  override public init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    self.commonInit()
  }
  
  override open var contentSize: CGSize {
    didSet {
      if oldValue != contentSize {
        // 值改变
        self.invalidateIntrinsicContentSize() // 通知系统改变内建大小
        
        NotificationCenter.default.post(name: NSNotification.Name.kTextViewContentSizeChanged , object: nil)
      }
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  private func commonInit() {
    NotificationCenter.default.addObserver(self, selector: #selector(ExpandableTextView.textDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: self)
  }
  
  override open func layoutSubviews() {
    super.layoutSubviews()
  }
  
  override open var intrinsicContentSize: CGSize {
    // 最大高度为100
    if self.contentSize.height > 100 {
      return CGSize(width: self.contentSize.width, height: 100)
    }else{
      return self.contentSize
    }
  }
  
  override open var text: String! {
    didSet {
      self.textDidChange()
    }
  }
  
  @objc func textDidChange() {
    self.scrollToCaret()
    
    if #available(iOS 9, *) {
      // Bugfix:
      // 1. Open keyboard
      // 2. Paste very long text (so it snaps to nav bar and shows scroll indicators)
      // 3. Select all and cut
      // 4. Paste again: Texview it's smaller than it should be
      self.isScrollEnabled = false
      self.isScrollEnabled = true
    }
  }
  
  private func scrollToCaret() {
    if let textRange = self.selectedTextRange {
      var rect = caretRect(for: textRange.end)
      rect = CGRect(origin: rect.origin, size: CGSize(width: rect.width, height: rect.height + textContainerInset.bottom))
      self.scrollRectToVisible(rect, animated: false)
    }
  }
  
}
