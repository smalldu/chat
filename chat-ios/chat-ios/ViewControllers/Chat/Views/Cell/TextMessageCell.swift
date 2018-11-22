//
//  TextMessageCell.swift
//  chat-ios
//
//  Created by 杜哲 on 2018/11/22.
//  Copyright © 2018 duzhe. All rights reserved.
//

import UIKit

class TextMessageCell: UICollectionViewCell {
  
  static let reuseID = "TextMessageCell"
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupViews()
  }
  
  func setupViews(){
    contentView.backgroundColor = UIColor.blue
    
  }
  
}
