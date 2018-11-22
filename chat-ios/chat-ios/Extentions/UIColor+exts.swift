//
//  UIColor+exts.swift
//  chat-ios
//
//  Created by zuber on 2018/11/22.
//  Copyright © 2018年 duzhe. All rights reserved.
//

import UIKit

extension UIColor {
  
  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }
  
  convenience init(rgb: Int) {
    self.init(
      red: (rgb >> 16) & 0xFF,
      green: (rgb >> 8) & 0xFF,
      blue: rgb & 0xFF
    )
  }
  
  
  static let lightBorder = UIColor(rgb: 0xebebeb)
  
  
  
}




