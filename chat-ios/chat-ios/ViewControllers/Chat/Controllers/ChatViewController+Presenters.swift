//
//  ChatViewController+Presenters.swift
//  chat-ios
//
//  Created by zuber on 2018/11/22.
//  Copyright © 2018年 duzhe. All rights reserved.
//

import UIKit


// MARK: - UICollectionViewDataSource

extension ChatViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextMessageCell.reuseID , for: indexPath) as! TextMessageCell
    return cell
  }
  
}



// MARK: - UICollectionViewDelegateFlowLayout

extension ChatViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    var height: CGFloat = 100
    return CGSize(width: collectionView.bounds.width , height: height)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 15
  }
  
}

