//
//  ChatViewController+Setting.swift
//  chat-ios
//
//  Created by zuber on 2018/11/22.
//  Copyright © 2018年 duzhe. All rights reserved.
//

import UIKit


extension ChatViewController {
  
  public struct Constants {
    public var updatesAnimationDuration: TimeInterval = 0.33
    public var autoloadingFractionalThreshold: CGFloat = 0.05 // in [0, 1]
  }
  
  // 设置contentinset
  func adjustCollectionViewInsets(shouldUpdateContentOffset: Bool) {
    let isInteracting = self.collectionView.panGestureRecognizer.numberOfTouches > 0
    let isBouncingAtTop = isInteracting && self.collectionView.contentOffset.y < -self.collectionView.contentInset.top
    if !self.placeMessagesFromBottom && isBouncingAtTop { return }
    
    let inputHeightWithKeyboard = self.view.bounds.height - self.inputContainer.frame.minY
    let newInsetBottom = self.layoutConfiguration.contentInsets.bottom + inputHeightWithKeyboard
    let insetBottomDiff = newInsetBottom - self.collectionView.contentInset.bottom
    var newInsetTop = self.topLayoutGuide.length + self.layoutConfiguration.contentInsets.top
    let contentSize = self.collectionView.collectionViewLayout.collectionViewContentSize
    
    let needToPlaceMessagesAtBottom = self.placeMessagesFromBottom && self.allContentFits
    if needToPlaceMessagesAtBottom {
      let realContentHeight = contentSize.height + newInsetTop + newInsetBottom
      newInsetTop += self.collectionView.bounds.height - realContentHeight
    }
    
    let insetTopDiff = newInsetTop - self.collectionView.contentInset.top
    let needToUpdateContentInset = self.placeMessagesFromBottom && (insetTopDiff != 0 || insetBottomDiff != 0)
    
    let prevContentOffsetY = self.collectionView.contentOffset.y
    
    let newContentOffsetY: CGFloat = {
      let minOffset = -newInsetTop
      let maxOffset = contentSize.height - (self.collectionView.bounds.height - newInsetBottom)
      let targetOffset = prevContentOffsetY + insetBottomDiff
      return max(min(maxOffset, targetOffset), minOffset)
    }()
    
    self.collectionView.contentInset = {
      var currentInsets = self.collectionView.contentInset
      currentInsets.bottom = newInsetBottom
      currentInsets.top = newInsetTop
      return currentInsets
    }()
    
    self.collectionView.scrollIndicatorInsets = {
      var currentInsets = self.collectionView.scrollIndicatorInsets
      currentInsets.bottom = self.layoutConfiguration.scrollIndicatorInsets.bottom + inputHeightWithKeyboard
      currentInsets.top = self.topLayoutGuide.length + self.layoutConfiguration.scrollIndicatorInsets.top
      return currentInsets
    }()
    
    guard shouldUpdateContentOffset else { return }
    
    let inputIsAtBottom = self.view.bounds.maxY - self.inputContainer.frame.maxY <= 0
    if isInteracting && (needToPlaceMessagesAtBottom || needToUpdateContentInset) {
      self.collectionView.contentOffset.y = prevContentOffsetY
    } else if self.allContentFits {
      self.collectionView.contentOffset.y = -self.collectionView.contentInset.top
    } else if !isInteracting || inputIsAtBottom {
      self.collectionView.contentOffset.y = newContentOffsetY
    }
  }
  
}



