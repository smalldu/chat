//
//  ReusableXibView.swift
//  ZuberChat
//
//  Created by duzhe on 2017/2/6.
//  Copyright © 2017年 duzhe. All rights reserved.
//
import UIKit


@objc open class ReusableXibView: UIView {
  
  func loadViewFromNib() -> UIView {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName:type(of: self).nibName(), bundle: bundle)
    let view = nib.instantiate(withOwner: nil, options: nil).first as! UIView
    return view
  }
  
  override open func awakeAfter(using aDecoder: NSCoder) -> Any? {
    if self.subviews.count > 0 {
      return self
    }
    
    let bundle = Bundle(for: type(of: self))
    if let loadedView = bundle.loadNibNamed(type(of: self).nibName(), owner: nil, options: nil)?.first as? UIView {
      loadedView.frame = frame
      loadedView.autoresizingMask = autoresizingMask
      loadedView.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
      for constraint in constraints {
        let firstItem = constraint.firstItem === self ? loadedView : constraint.firstItem
        let secondItem = constraint.secondItem === self ? loadedView : constraint.secondItem
        loadedView.addConstraint(NSLayoutConstraint(item: firstItem as Any, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: secondItem, attribute: constraint.secondAttribute, multiplier: constraint.multiplier, constant: constraint.constant))
      }
      return loadedView
    } else {
      return nil
    }
  }
  
  class func nibName() -> String {
    assert(false, "Must be overriden")
    return ""
  }
}
