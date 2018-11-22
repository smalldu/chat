//
//  ChatMoreDataSource.swift
//  ZuberLetter
//
//  Created by duzhe on 2017/7/28.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit


protocol ChatMoreItemProtocal {
  
  var name: String {
    set get
  }
  
  var image: UIImage? {
    set get
  }
}

protocol ChatMoreDataSource: class {
  func numberForChatView() -> Int
  func chatMore(_ charMoreView:ChatMoreView , index : Int) -> ChatMoreItemProtocal
}














