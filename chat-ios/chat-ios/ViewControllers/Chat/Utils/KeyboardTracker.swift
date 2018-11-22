//
//  KeyboardTracker.swift
//  Chatty
//
//  Created by zuber on 2018/10/18.
//  Copyright © 2018年 zuber. All rights reserved.
//

import UIKit

public enum KeyboardStatus {
  case hiding
  case hidden
  case showing
  case shown
}

class KeyboardTracker {
  var keyboardStatus: KeyboardStatus = .hidden
  private let view: UIView
  var trackingView: UIView {
    return self.keyboardTrackerView
  }
  private lazy var keyboardTrackerView: KeyboardTrackingView = {
    let trackingView = KeyboardTrackingView()
    trackingView.positionChangedCallback = { [weak self] in
      guard let sSelf = self else { return }
      if !sSelf.isPerformingForcedLayout {
        sSelf.layoutInputAtTrackingViewIfNeeded()
      }
    }
    return trackingView
  }()
  
  var isTracking = false
  var inputContainer: UIView
  private var notificationCenter: NotificationCenter
  
  typealias LayoutBlock = (_ bottomMargin: CGFloat, _ status: KeyboardStatus) -> Void
  private var layoutBlock: LayoutBlock
  
  init(viewController: UIViewController, inputContainer: UIView, layoutBlock: @escaping LayoutBlock, notificationCenter: NotificationCenter) {
    self.view = viewController.view
    self.layoutBlock = layoutBlock
    self.inputContainer = inputContainer
    self.notificationCenter = notificationCenter
    self.notificationCenter.addObserver(self, selector: #selector(KeyboardTracker.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    self.notificationCenter.addObserver(self, selector: #selector(KeyboardTracker.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    self.notificationCenter.addObserver(self, selector: #selector(KeyboardTracker.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    self.notificationCenter.addObserver(self, selector: #selector(KeyboardTracker.keyboardDidHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    self.notificationCenter.addObserver(self, selector: #selector(KeyboardTracker.keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
  }
  
  deinit {
    self.notificationCenter.removeObserver(self)
  }
  
  func startTracking() {
    self.isTracking = true
  }
  
  func stopTracking() {
    self.isTracking = false
  }
  
  @objc
  private func keyboardWillShow(_ notification: Notification) {
    guard self.isTracking else { return }
    guard !self.isPerformingForcedLayout else { return }
    NotificationCenter.default.post(name: NSNotification.Name.kHideInputCommonViewNf , object: nil)  // 先隐藏底部
    let bottomConstraint = self.bottomConstraintFromNotification(notification)
    guard bottomConstraint > 0 else { return } // Some keyboards may report initial willShow/DidShow notifications with invalid positions
    self.keyboardStatus = .showing
    self.layoutInputContainer(withBottomConstraint: bottomConstraint)
  }
  
  @objc
  private func keyboardDidShow(_ notification: Notification) {
    guard self.isTracking else { return }
    guard !self.isPerformingForcedLayout else { return }
    
    let bottomConstraint = self.bottomConstraintFromNotification(notification)
    guard bottomConstraint > 0 else { return } // Some keyboards may report initial willShow/DidShow notifications with invalid positions
    self.keyboardStatus = .shown
    self.layoutInputContainer(withBottomConstraint: bottomConstraint)
    self.adjustTrackingViewSizeIfNeeded()
  }
  
  @objc
  private func keyboardWillChangeFrame(_ notification: Notification) {
    guard self.isTracking else { return }
    let bottomConstraint = self.bottomConstraintFromNotification(notification)
    if bottomConstraint == 0 {
      self.keyboardStatus = .hiding
      self.layoutInputAtBottom()
    }
  }
  
  @objc
  private func keyboardWillHide(_ notification: Notification) {
    guard self.isTracking else { return }
    self.keyboardStatus = .hiding
    self.layoutInputAtBottom()
  }
  
  @objc
  private func keyboardDidHide(_ notification: Notification) {
    guard self.isTracking else { return }
    self.keyboardStatus = .hidden
    self.layoutInputAtBottom()
  }
  
  private func bottomConstraintFromNotification(_ notification: Notification) -> CGFloat {
    guard let rect = ((notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return 0 }
    guard rect.height > 0 else { return 0 }
    let rectInView = self.view.convert(rect, from: nil)
    guard rectInView.maxY >=~ self.view.bounds.height else { return 0 } // Undocked keyboard
    return max(0, self.view.bounds.height - rectInView.minY - self.keyboardTrackerView.intrinsicContentSize.height)
  }
  
  private func bottomConstraintFromTrackingView() -> CGFloat {
    guard self.keyboardTrackerView.superview != nil else { return 0 }
    let trackingViewRect = self.view.convert(self.keyboardTrackerView.bounds, from: self.keyboardTrackerView)
    return max(0, self.view.bounds.height - trackingViewRect.maxY)
  }
  
  func adjustTrackingViewSizeIfNeeded() {
    guard self.isTracking && self.keyboardStatus == .shown else { return }
    self.adjustTrackingViewSize()
  }
  
  private func adjustTrackingViewSize() {
    let inputContainerHeight = self.inputContainer.bounds.height
    if self.keyboardTrackerView.preferredSize.height != inputContainerHeight {
      self.keyboardTrackerView.preferredSize.height = inputContainerHeight
      self.isPerformingForcedLayout = true
      self.keyboardTrackerView.window?.layoutIfNeeded()
      self.isPerformingForcedLayout = false
    }
  }
  
  private func layoutInputAtBottom() {
    self.keyboardTrackerView.bounds.size.height = 0
    self.layoutInputContainer(withBottomConstraint: 0)
  }
  
  var isPerformingForcedLayout: Bool = false
  func layoutInputAtTrackingViewIfNeeded() {
    guard self.isTracking && self.keyboardStatus == .shown else { return }
    self.layoutInputContainer(withBottomConstraint: self.bottomConstraintFromTrackingView())
  }
  
  private func layoutInputContainer(withBottomConstraint constraint: CGFloat) {
    self.isPerformingForcedLayout = true
    self.layoutBlock(constraint, self.keyboardStatus)
    self.isPerformingForcedLayout = false
  }
}

private class KeyboardTrackingView: UIView {
  
  var positionChangedCallback: (() -> Void)?
  var observedView: UIView?
  
  deinit {
    if let observedView = self.observedView {
      observedView.removeObserver(self, forKeyPath: "frame")
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.commonInit()
  }
  
  func commonInit() {
    self.autoresizingMask = .flexibleHeight
    self.isUserInteractionEnabled = false
    self.backgroundColor = UIColor.clear
    self.isHidden = true
  }
  
  var preferredSize: CGSize = .zero {
    didSet {
      if oldValue != self.preferredSize {
        self.invalidateIntrinsicContentSize()
        self.window?.setNeedsLayout()
      }
    }
  }
  
  override var intrinsicContentSize: CGSize {
    return self.preferredSize
  }
  
  override func willMove(toSuperview newSuperview: UIView?) {
    if let observedView = self.observedView {
      observedView.removeObserver(self, forKeyPath: "center")
      self.observedView = nil
    }
    
    if let newSuperview = newSuperview {
      newSuperview.addObserver(self, forKeyPath: "center", options: [.new, .old], context: nil)
      self.observedView = newSuperview
    }
    
    super.willMove(toSuperview: newSuperview)
  }
  
  override func observeValue(forKeyPath keyPath: String?,
                             of object: Any?,
                             change: [NSKeyValueChangeKey: Any]?,
                             context: UnsafeMutableRawPointer?) {
    guard let object = object as? UIView, let superview = self.superview else { return }
    if object === superview {
      guard let sChange = change else { return }
      let oldCenter = (sChange[NSKeyValueChangeKey.oldKey] as! NSValue).cgPointValue
      let newCenter = (sChange[NSKeyValueChangeKey.newKey] as! NSValue).cgPointValue
      if oldCenter != newCenter {
        self.positionChangedCallback?()
      }
    }
  }
}