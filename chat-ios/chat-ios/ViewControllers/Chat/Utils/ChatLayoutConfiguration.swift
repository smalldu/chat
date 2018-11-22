//
//  ChatLayoutConfiguration.swift
//  Chatty
//
//  Created by zuber on 2018/10/18.
//  Copyright © 2018年 zuber. All rights reserved.
//

import UIKit

public protocol ChatLayoutConfigurationProtocol {
  var contentInsets: UIEdgeInsets { get }
  var scrollIndicatorInsets: UIEdgeInsets { get }
}

public struct ChatLayoutConfiguration: ChatLayoutConfigurationProtocol {
  public let contentInsets: UIEdgeInsets
  public let scrollIndicatorInsets: UIEdgeInsets
  
  public init(contentInsets: UIEdgeInsets, scrollIndicatorInsets: UIEdgeInsets) {
    self.contentInsets = contentInsets
    self.scrollIndicatorInsets = scrollIndicatorInsets
  }
}

extension ChatLayoutConfiguration {
  static var defaultConfiguration: ChatLayoutConfiguration {
    let contentInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    let scrollIndicatorInsets = UIEdgeInsets.zero
    return ChatLayoutConfiguration(contentInsets: contentInsets,
                                   scrollIndicatorInsets: scrollIndicatorInsets)
  }
}
