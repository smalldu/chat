//
//  ChatEmojiView.swift
//  ZuberChat
//
//  Created by duzhe on 2017/2/10.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

fileprivate let emoji_totalRows = 3 // 每页表情行。
fileprivate let emoji_numberInRow = 6 // 每行表情数。
fileprivate let emoji_maxPage = 8  // 表情最大页数。
fileprivate let emoji_btmHeight:CGFloat = 40.0 // 底部按钮高度
fileprivate let emoji_size = CGSize(width: 36, height: 36) //表情大小
fileprivate let emoji_margin:CGFloat =  12.0 //表情离边框的上、左和右的边距。

let inputCommonViewHeight: CGFloat = 210 // 底部自定义键盘高度
let inputCommonViewDuration: TimeInterval = 0.25
let inputCommonWidth: CGFloat = UIScreen.main.bounds.width

// 数据源
struct ChatMetedata {
  static var emojiArrs:[Any] = []
}

protocol ChatEmojiDelegate:class {
  func emojiViewDelete(_ view:ChatEmojiView )
  func emojiViewSend(_ view:ChatEmojiView )
  func emojiView(_ view:ChatEmojiView , emoji:String)
}

class ChatEmojiView: UIView {
  
  var isVisible = false
  
  fileprivate var emojiScrollView: UIScrollView!
  fileprivate var btnSend: UIButton!
  fileprivate var pageControll: UIPageControl!
  fileprivate var btnEmoji: UIButton!
  fileprivate var emojiArr: [Any] = []
  fileprivate var emojiSpacing_Horizontal: CGFloat = 0 // 表情水平方向间距
  fileprivate var emojiSpacing_Vertical: CGFloat = 0 // 表情竖直方向间距
  fileprivate var totalPage: Int = 0 // 总页数
  weak var delegate: ChatEmojiDelegate?
  
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
  func initData(){
    if ChatMetedata.emojiArrs.count > 0{
      self.emojiArr = ChatMetedata.emojiArrs
    }else{
      self.emojiArr = Emoji.allEmoji()
    }
    
    emojiSpacing_Horizontal = (inputCommonWidth - CGFloat(2) * emoji_margin - CGFloat(emoji_numberInRow) * emoji_size.width) / CGFloat(emoji_numberInRow - 1)
    
    emojiSpacing_Vertical = (inputCommonViewHeight - emoji_margin - emoji_btmHeight - 34.0 - CGFloat(emoji_totalRows) * emoji_size.height) / CGFloat(emoji_totalRows - 1)
    
    self.totalPage = (emoji_totalRows*emoji_numberInRow - 1) == 0 ? (self.emojiArr.count / (emoji_totalRows * emoji_numberInRow - 1)) : (self.emojiArr.count / (emoji_totalRows * emoji_numberInRow - 1) + 1)
    self.totalPage = self.totalPage >= emoji_maxPage ? emoji_maxPage : self.totalPage
  }
  
  func initUI(){
    emojiScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: inputCommonWidth , height: inputCommonViewHeight - emoji_btmHeight ))
    emojiScrollView.backgroundColor = UIColor.clear
    emojiScrollView.showsHorizontalScrollIndicator = false
    emojiScrollView.showsVerticalScrollIndicator = false
    emojiScrollView.delegate = self
    emojiScrollView.isPagingEnabled = true
    emojiScrollView.contentSize = CGSize(width: emojiScrollView.frame.size.width * CGFloat(totalPage) , height: emojiScrollView.frame.size.height )
    self.addSubview(emojiScrollView)
    
    // 发送按钮
    btnSend = UIButton(frame: CGRect(x: inputCommonWidth - 60 , y: inputCommonViewHeight - emoji_btmHeight , width: 60, height: emoji_btmHeight  ))
    btnSend.setTitle(NSLocalizedString("发送", comment: "") , for: UIControlState.normal)
    btnSend.setTitleColor(UIColor.darkGray , for: UIControlState.highlighted)
    btnSend.backgroundColor = UIColor(red: 26/255.0, green: 148/255, blue: 213/255, alpha: 1)
    btnSend.addTarget(self, action: #selector(send(_:)) , for: UIControlEvents.touchUpInside )
    self.addSubview(btnSend)
    
    // 分割线
    let bottomLine = UIView()
    bottomLine.frame = CGRect(x: 0, y: inputCommonViewHeight - emoji_btmHeight, width:inputCommonWidth, height: 0.5)
    bottomLine.backgroundColor = UIColor(red: 188/255.0, green: 188/255, blue: 188/255, alpha: 1)
    self.addSubview(bottomLine)
    
    // 页码
    pageControll = UIPageControl(frame: CGRect(x: 0, y: inputCommonViewHeight - emoji_btmHeight - 20 , width: inputCommonWidth, height: 14 ))
    pageControll.backgroundColor = UIColor.clear
    pageControll.pageIndicatorTintColor = UIColor.gray
    pageControll.currentPageIndicatorTintColor = UIColor.black
    pageControll.numberOfPages = self.totalPage
    pageControll.currentPage = 0
    self.addSubview(pageControll)
    
    // 展示emoj
    self.showEmoji()
  }
  
  func showEmoji(){
    let numbersInPage = emoji_totalRows * emoji_numberInRow - 1 //每页最大表情数。
    let amount = self.emojiArr.count >= emoji_maxPage * numbersInPage ? emoji_maxPage * numbersInPage : self.emojiArr.count
    
    // 表情按钮
    for i in 0..<amount {
      let page = i / numbersInPage
      let row = ( i - page*numbersInPage ) / emoji_numberInRow
      let line = ( i - page*numbersInPage ) % emoji_numberInRow
      
      let temp = UIButton()
      let origin_x = CGFloat(page) * emojiScrollView.frame.width + emoji_margin + CGFloat(line) * ( emoji_size.width + emojiSpacing_Horizontal )
      let origin_y = emoji_margin + CGFloat(row) * (emoji_size.height + emojiSpacing_Vertical)
      temp.frame = CGRect(x: origin_x , y: origin_y , width: emoji_size.width , height: emoji_size.height )
      
      temp.setTitle(self.emojiArr[i] as? String , for: UIControlState.normal )
      temp.titleLabel?.font = UIFont.systemFont(ofSize: 30)
      temp.addTarget(self, action: #selector(clickEmoji(_:)) , for: UIControlEvents.touchUpInside )
      temp.tag = 100+i
      
      emojiScrollView.addSubview(temp)
    }
    
    // 删除按钮
    for i in 0..<self.totalPage {
      let temp = UIButton()
      let origin_x = CGFloat(i) * emojiScrollView.frame.size.width + emoji_margin + CGFloat(emoji_numberInRow - 1) * (emoji_size.width + emojiSpacing_Horizontal)
      let origin_y = emoji_margin + CGFloat(emoji_totalRows - 1) * (emoji_size.height + emojiSpacing_Vertical)
      
      temp.setImage(UIImage(named:"zz_emoji_delete") , for: UIControlState.normal )
      temp.addTarget(self, action: #selector(emojiDelete(_:)) , for: UIControlEvents.touchUpInside )
      temp.frame = CGRect(x: origin_x, y: origin_y, width: emoji_size.width, height: emoji_size.height)
      emojiScrollView.addSubview(temp)
    }
  }
  
  // 发送按钮
  @objc func send(_ sender:UIButton){
    delegate?.emojiViewSend(self)
  }
  
  @objc func clickEmoji(_ sender:UIButton){
    let tag = sender.tag - 100
    if tag >= 0{
      if let emoji = self.emojiArr[tag] as? String {
        delegate?.emojiView(self, emoji: emoji)
      }
    }
  }
  
  @objc func emojiDelete(_ sender:UIButton){
    delegate?.emojiViewDelete(self)
  }
  
  func show(){
    self.isVisible = true
    UIView.animate(withDuration: inputCommonViewDuration) {
      self.transform = CGAffineTransform.identity
    }
  }
  
  func hide(){
    self.isVisible = false
    UIView.animate(withDuration: inputCommonViewDuration) {
      self.transform = CGAffineTransform(translationX: 0, y: inputCommonViewHeight + 50)
    }
  }
}

extension ChatEmojiView:UIScrollViewDelegate {
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    self.pageControll.currentPage = Int(scrollView.contentOffset.x / inputCommonWidth)
  }
  
}


