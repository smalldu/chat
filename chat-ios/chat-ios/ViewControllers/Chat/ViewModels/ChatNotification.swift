//
//  ChatNotification.swift
//  ZuberChat
//
//  Created by duzhe on 2017/2/8.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import Foundation


extension Notification.Name {
  
  static let kTextViewContentSizeChanged = Notification.Name("chat.notification.contentsize.changed")
  static let kHideInputCommonViewNf = Notification.Name("chat.notification.kHideInputCommonViewNf")
  static let kStartRecordNotification = Notification.Name("chat.notification.kStartRecordNotification")
  static let kEndVoiceNotification = Notification.Name("chat.notification.kEndVoiceNotification")
  
}
