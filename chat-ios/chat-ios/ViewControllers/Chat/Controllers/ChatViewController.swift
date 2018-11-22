//
//  ChatViewController.swift
//  chat-ios
//
//  Created by zuber on 2018/8/13.
//  Copyright © 2018年 duzhe. All rights reserved.
//

import UIKit
import SnapKit

class ChatViewController: UIViewController {
  
  lazy var layout: ChatLayout = {
    let layout = ChatLayout()
    layout.sectionInset = .zero
    return layout
  }()
  
  public var constants = Constants()
  
  public var collectionView: UICollectionView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  
  
  
}



// MARK: - setup

extension ChatViewController {
  
  func setup(){
    view.backgroundColor = UIColor.lightGray
    
  }
  
  private func addCollectionView() {
    collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), collectionViewLayout: layout)
    collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    collectionView.scrollIndicatorInsets = .zero
    collectionView.alwaysBounceVertical = true
    collectionView.backgroundColor = UIColor.lightGray
    collectionView.keyboardDismissMode = .interactive
    collectionView.showsVerticalScrollIndicator = true
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.allowsSelection = false
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.chatty_setContentInsetAdjustment(enabled: false, in: self)
  }
  
}





