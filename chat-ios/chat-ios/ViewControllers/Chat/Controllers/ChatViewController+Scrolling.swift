//
//  ChatViewController+Scrolling.swift
//  chat-ios
//
//  Created by 杜哲 on 2018/11/22.
//  Copyright © 2018 duzhe. All rights reserved.
//

import UIKit

extension ChatViewController {
  
  @objc
  func scrollToBottom(animated: Bool) {
    // 取消当前的滚动
    self.collectionView.setContentOffset(self.collectionView.contentOffset, animated: false)
    
    // Note that we don't rely on collectionView's contentSize. This is because it won't be valid after performBatchUpdates or reloadData
    // After reload data, collectionViewLayout.collectionViewContentSize won't be even valid, so you may want to refresh the layout manually
    let offsetY = max(-self.collectionView.contentInset.top, self.collectionView.collectionViewLayout.collectionViewContentSize.height - self.collectionView.bounds.height + self.collectionView.contentInset.bottom)
    
    // Don't use setContentOffset(:animated). If animated, contentOffset property will be updated along with the animation for each frame update
    // If a message is inserted while scrolling is happening (as in very fast typing), we want to take the "final" content offset (not the "real time" one) to check if we should scroll to bottom again
    if animated {
      UIView.animate(withDuration: self.constants.updatesAnimationDuration, animations: { () -> Void in
        self.collectionView.contentOffset = CGPoint(x: 0, y: offsetY)
      })
    } else {
      self.collectionView.contentOffset = CGPoint(x: 0, y: offsetY)
    }
  }
  
}

