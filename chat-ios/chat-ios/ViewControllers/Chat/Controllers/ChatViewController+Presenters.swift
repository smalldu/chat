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
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return UICollectionViewCell()
  }
  
}



// MARK: - UICollectionViewDelegateFlowLayout

extension ChatViewController: UICollectionViewDelegateFlowLayout {
  
  
}

