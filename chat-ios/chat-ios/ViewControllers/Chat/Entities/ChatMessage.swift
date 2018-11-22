//
//  ChatMessage.swift
//  chat-ios
//
//  Created by zuber on 2018/11/22.
//  Copyright © 2018年 duzhe. All rights reserved.
//

import Foundation
import RealmSwift


@objcMembers
class ChatMessage: Object {
  
  enum MessageStatus: Int {
    case success = 0
    case fail = 1
    case sending = 2
  }
  
  dynamic var id: Int64 = 0    //私信ID
  dynamic var letter_id: Int64 = 0
  dynamic var chat_uid: String = ""
  dynamic var self_uid: String = ""
  dynamic var text: String = "" //私信内容
  dynamic var category: String = ""  //0 私信  text , image , audio , video , location , time 时间
  dynamic var create_timestamp: String = "" // 创建时间
  dynamic var create_time_unix: Int = 0 // unix 时间戳
  
  dynamic var media_read: Bool = false
  dynamic var messageStatus: Int = 0 // 信息状态 0 正常 1 发送失败 2 发送中
  
  // 主键
  override static func primaryKey() -> String? {
    return "id"
  }
  
  // 忽略属性
  override static func ignoredProperties() -> [String] {
    return []
  }
}
