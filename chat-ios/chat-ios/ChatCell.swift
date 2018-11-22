//
//  ChatCell.swift
//  chat-ios
//
//  Created by zuber on 2018/8/13.
//  Copyright © 2018年 duzhe. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
  
  @IBOutlet weak var uidLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var ctLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func config(message: Message){
    if message.uid == currentUID {
//      自己
      uidLabel.textAlignment = .right
      timeLabel.textAlignment = .right
      ctLabel.textAlignment = .right
      contentView.backgroundColor = UIColor.lightGray
    }else{
      uidLabel.textAlignment = .left
      timeLabel.textAlignment = .left
      ctLabel.textAlignment = .left
      contentView.backgroundColor = UIColor.white
    }
    
    uidLabel.text = message.uid
    timeLabel.text = message.time
    ctLabel.text = message.content
  }
  
  
}

