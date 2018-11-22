//
//  BaseChatViewControllerView.swift
//  chat-ios
//
//  Created by 杜哲 on 2018/11/22.
//  Copyright © 2018 duzhe. All rights reserved.
//

import UIKit


// If you wish to use your custom view instead of BaseChatViewControllerView, you must implement this protocol.
public protocol BaseChatViewControllerViewProtocol: class {
  var bmaInputAccessoryView: UIView? { get set }
}

// http://stackoverflow.com/questions/24596031/uiviewcontroller-with-inputaccessoryview-is-not-deallocated
final class ChatViewControllerView: UIView, BaseChatViewControllerViewProtocol {
  
  var bmaInputAccessoryView: UIView?
  
  override var inputAccessoryView: UIView? {
    return self.bmaInputAccessoryView
  }
}

