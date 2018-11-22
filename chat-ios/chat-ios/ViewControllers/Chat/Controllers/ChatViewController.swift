//
//  ChatViewController.swift
//  chat-ios
//
//  Created by zuber on 2018/8/13.
//  Copyright © 2018年 duzhe. All rights reserved.
//

import UIKit
import SnapKit


extension Date{
  // 时间转字符串
  func toString()->String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let str = dateFormatter.string(from: self)
    return str
  }
}

class ChatViewController: UIViewController {
  
}
