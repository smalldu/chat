//
//  ChatInputView+chatMoreDataSource.swift
//  ZuberLetter
//
//  Created by duzhe on 2017/7/28.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit
import Photos

extension ChatInputView: ChatMoreDataSource {
  
  func numberForChatView() -> Int {
    return 0
  }
  
  func chatMore(_ charMoreView: ChatMoreView, index: Int) -> ChatMoreItemProtocal {
    switch index {
    case 0:
      return ChatMoreNormalItem(name: "相册", image: #imageLiteral(resourceName: "v2_photo_normal"))
    case 1:
      return ChatMoreNormalItem(name: "拍照", image: #imageLiteral(resourceName: "v2_shoot_normal") )
    case 2:
      return ChatMoreNormalItem(name: "我的房源", image: #imageLiteral(resourceName: "chat_home_normal"))
    case 3:
      
      return ChatMoreNormalItem(name: "位置", image: UIImage(named: "chat_location_input"))
    default:
      return ChatMoreNormalItem(name: "", image: #imageLiteral(resourceName: "v2_contract_normal"))
    }
  }
}

// 点击➕
extension ChatInputView: ChatMoreDelegate {
  
  @objc func clickAddMore(_ sender: UIButton){
    self.hideVoiceRecord(isSelf: false)
    self.setMoreViewSwitch(!self.utilitySwitch)
    self.emojiView.hide()
    if self.utilitySwitch {
      self.moreView.show()
      self.showCommonViewShow()
      self.textView.resignFirstResponder()
    }else{
      self.moreView.hide()
      self.selfHideCommonView()
      self.textView.becomeFirstResponder()
    }
    delegate?.chatInput(chatInputView: self, didClickMoreViewSwitch: self.utilitySwitch)
  }
  
  func setMoreViewSwitch( _ value:Bool) {
    self.utilitySwitch = value
  }
  
  
  func chatMoreView(_ view: ChatMoreView, didSelectAt index: Int) {
    switch index {
    case 0:
      // 照片
      print("拍照")
    case 1:
      // 拍照
      print("拍照")
    case 2:
      // 我的房源
      delegate?.chatInputDidClickMyRoom(chatInputView: self)
    case 3:
      delegate?.chatInputDidClickPosition(chatInputView: self)
    default:
      break
    }
  }
}


class ChatMoreNormalItem: ChatMoreItemProtocal {
  var name: String
  var image: UIImage?
  
  init(name:String,image: UIImage?) {
    self.name = name
    self.image = image
  }
}



