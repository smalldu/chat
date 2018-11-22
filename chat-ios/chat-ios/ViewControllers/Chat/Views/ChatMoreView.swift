//
//  ChatMoreView.swift
//  ZuberChat
//  选择更多View
//  Created by duzhe on 2017/2/10.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit
import Photos

fileprivate let CM_Margin: CGFloat = 0.0
fileprivate let CM_ButtonHeight: CGFloat = 80.0
fileprivate let CM_NumbersInRow: Int = 4
fileprivate let CM_TotalRows: Int = 2

let _sw: CGFloat = UIScreen.main.bounds.width
let _sh: CGFloat = UIScreen.main.bounds.width

protocol ChatMoreDelegate:class {
  
  func chatMoreView( _ view:ChatMoreView,didSelectAt index:Int )
  
}

class ChatMoreView: UIView {
  
  var isVisible = false // 是否处于显示状态
  fileprivate var spacing_Horizontal:CGFloat = 0 // 水平方向间距
  fileprivate var spacing_Vertical:CGFloat = 0 // 竖直方向间距
  weak var delegate:ChatMoreDelegate?
  weak var dataSource: ChatMoreDataSource?
  var itemWidth: CGFloat = 80
  override init(frame: CGRect) {
    super.init(frame: frame )
  }
  
  convenience init() {
    self.init(frame:CGRect.zero)
    DispatchQueue.main.async {
      self.initData()
      self.initUI()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func reload(){
//    self.removeAllSubviews()
    DispatchQueue.main.async {
      self.initData()
      self.initUI()
    }  
  }
  
  func initData(){
    itemWidth = _sw/CGFloat(CM_NumbersInRow)
    spacing_Horizontal = (inputCommonWidth - 2 * CM_Margin - CGFloat(CM_NumbersInRow) * itemWidth) / (CGFloat(CM_NumbersInRow) - 1)
    spacing_Vertical = (inputCommonWidth - 2 * CM_Margin - CGFloat(CM_TotalRows) * CM_ButtonHeight) / (CGFloat(CM_TotalRows) - 1)
  }
  
  func initUI(){
    guard let dataSource = dataSource else {
      return
    }
    let numbers = dataSource.numberForChatView()
    for i in 0..<numbers {
      let item = dataSource.chatMore(self, index: i)
      let title = item.name
      let image = item.image
      let row = i / CM_NumbersInRow
      let line = i % CM_NumbersInRow
      
      let temp =
        UIButton(frame:  CGRect(x: CM_Margin + CGFloat(line) * (itemWidth + self.spacing_Horizontal), y: 15 + CGFloat(row) * (CM_ButtonHeight + self.spacing_Vertical), width: itemWidth, height: CM_ButtonHeight))
      temp.setImage(image, for: UIControlState.normal )
      temp.setTitle(title, for: UIControlState.normal )
      temp.setTitleColor(UIColor.gray, for: .normal)
      temp.titleLabel?.font = UIFont.systemFont(ofSize: 12)
//      temp.layoutWith(style: .top, space: 10)
      temp.addTarget(self, action: #selector(selected(_:)), for: .touchUpInside)
      temp.tag = 888 + i
      self.addSubview(temp)
    }
  }
  
  @objc func selected(_ sender:UIButton){
    let index = sender.tag - 888
    delegate?.chatMoreView(self, didSelectAt: index)
  }
  
  
  func show(){
    self.isVisible = true
    UIView.animate(withDuration: inputCommonViewDuration) {
      self.transform = CGAffineTransform.identity
    }
  }
  
  func hide(animated: Bool = true ){
    self.isVisible = false
    UIView.animate(withDuration: animated ? inputCommonViewDuration:0.01) {
      self.transform = CGAffineTransform(translationX: 0, y: inputCommonViewHeight+50)
    }
  }
}
















