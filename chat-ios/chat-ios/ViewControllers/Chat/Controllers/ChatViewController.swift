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
  
  public var placeMessagesFromBottom = false {
    didSet {
      self.adjustCollectionViewInsets(shouldUpdateContentOffset: false)
    }
  }
  
  public var collectionView: UICollectionView!
  
  /// about inputview
  public private(set) var inputContainer: UIView!
  public private(set) var bottomSpaceView: UIView!
  var chatInputView: ChatInputView!
  
  private var inputContainerBottomConstraint: Constraint!
  var keyboardTracker: KeyboardTracker!
  var notificationCenter = NotificationCenter.default
  var isAdjustingInputContainer: Bool = false
  
  public var endsEditingWhenTappingOnChatBackground = true
  public var substitutesMainViewAutomatically = true
  
  public var allContentFits: Bool {
    let inputHeightWithKeyboard = self.view.bounds.height - self.inputContainer.frame.minY
    let insetTop = self.topLayoutGuide.length + self.layoutConfiguration.contentInsets.top
    let insetBottom = self.layoutConfiguration.contentInsets.bottom + inputHeightWithKeyboard
    let availableHeight = self.collectionView.bounds.height - (insetTop + insetBottom)
    let contentSize = self.collectionView.collectionViewLayout.collectionViewContentSize
    return availableHeight >= contentSize.height
  }
  
  open var layoutConfiguration: ChatLayoutConfigurationProtocol = ChatLayoutConfiguration.defaultConfiguration {
    didSet {
      self.adjustCollectionViewInsets(shouldUpdateContentOffset: false)
    }
  }
  
  override func loadView() {
    if substitutesMainViewAutomatically {
      self.view = ChatViewControllerView() // http://stackoverflow.com/questions/24596031/uiviewcontroller-with-inputaccessoryview-is-not-deallocated
      self.view.backgroundColor = UIColor.white
    } else {
      super.loadView()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.keyboardTracker.startTracking()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.keyboardTracker.stopTracking()
  }
  
  
  public private(set) var isFirstLayout: Bool = true
  override open func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.adjustCollectionViewInsets(shouldUpdateContentOffset: true)
    self.keyboardTracker.adjustTrackingViewSizeIfNeeded()
    
    if self.isFirstLayout {
      self.isFirstLayout = false
      self.setupInputContainerBottomConstraint()
      self.scrollToBottom(animated: false)
    }
  }
  
}


// MARK: - setup

extension ChatViewController: UIGestureRecognizerDelegate {
  
  func setup(){
    view.backgroundColor = UIColor.lightGray
    addCollectionView()
    addInputViews()
    addBottomSpaceView()
    setupKeyboardTracker()
    setupTapGestureRecognizer()
  }
  
  // 配置 collectionview
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
    
    collectionView.register(TextMessageCell.self, forCellWithReuseIdentifier: TextMessageCell.reuseID)
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.chatty_setContentInsetAdjustment(enabled: false, in: self)
  }
  
  func createChatInputView() -> ChatInputView {
    let chatInputView = ChatInputView.loadNib()
    chatInputView.delegate = self
    return chatInputView
  }
  
  func addInputViews() {
    inputContainer = UIView(frame: CGRect.zero)
    inputContainer.autoresizingMask = UIView.AutoresizingMask()
    view.addSubview(inputContainer)
    inputContainer.snp.makeConstraints { (make) in
      make.right.left.equalToSuperview()
      make.top.greaterThanOrEqualTo(self.topLayoutGuide.snp.bottom)
      inputContainerBottomConstraint = make.bottom.equalToSuperview().constraint
    }
    chatInputView = self.createChatInputView()
    inputContainer.addSubview(chatInputView)
    chatInputView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  func addBottomSpaceView() {
    self.bottomSpaceView = UIView(frame: CGRect.zero)
    self.bottomSpaceView.autoresizingMask = UIView.AutoresizingMask()
    self.bottomSpaceView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(self.bottomSpaceView)
    bottomSpaceView.snp.makeConstraints { (make) in
      make.left.right.equalToSuperview()
      make.bottom.equalToSuperview()
      make.top.greaterThanOrEqualTo(inputContainer.snp.bottom)
    }
  }
  
  func setupKeyboardTracker() {
    let layoutBlock = { [weak self] (bottomMargin: CGFloat, keyboardStatus: KeyboardStatus) in
      guard let `self` = self else { return }
      self.handleKeyboardPositionChange(bottomMargin: bottomMargin, keyboardStatus: keyboardStatus)
    }
    self.keyboardTracker = KeyboardTracker(viewController: self, inputContainer: self.inputContainer, layoutBlock: layoutBlock, notificationCenter: self.notificationCenter)
    
    (self.view as? BaseChatViewControllerViewProtocol)?.bmaInputAccessoryView = self.keyboardTracker?.trackingView
  }
  
  func handleKeyboardPositionChange(bottomMargin: CGFloat, keyboardStatus: KeyboardStatus) {
    self.isAdjustingInputContainer = true
    self.inputContainerBottomConstraint.update(inset: max(bottomMargin, 0))
    self.view.layoutIfNeeded()
    self.isAdjustingInputContainer = false
  }
  
  func setupTapGestureRecognizer() {
    let tapBack = UITapGestureRecognizer(target: self, action: #selector( clickBack ))
    tapBack.delegate = self
    self.view.addGestureRecognizer(tapBack)
  }
  
  @objc
  func clickBack(){
    if self.endsEditingWhenTappingOnChatBackground {
      self.view.endEditing(true)
    }
  }
  
  // 解决手势冲突
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    //如果键盘在展示 响应tap事件  如果没有展示不响应
    if self.keyboardTracker.keyboardStatus == .shown {
      return true
    }else{
      return false
    }
  }
  
  func setupInputContainerBottomConstraint() {
    if #available(iOS 11.0, *) {
      self.inputContainerBottomConstraint.update(inset: 0)
    } else {
      // If we have been pushed on nav controller and hidesBottomBarWhenPushed = true, then ignore bottomLayoutMargin
      // because it has incorrect value when we actually have a bottom bar (tabbar)
      // Also if instance of BaseChatViewController is added as childViewController to another view controller, we had to check all this stuf on parent instance instead of self
      // UPD: Fixed in iOS 11.0
      let navigatedController: UIViewController
      if let parent = self.parent, !(parent is UINavigationController || parent is UITabBarController) {
        navigatedController = parent
      } else {
        navigatedController = self
      }
      
      if navigatedController.hidesBottomBarWhenPushed && (navigationController?.viewControllers.count ?? 0) > 1 && navigationController?.viewControllers.last == navigatedController {
        self.inputContainerBottomConstraint.update(inset: 0)
      } else {
        self.inputContainerBottomConstraint.update(inset: self.bottomLayoutGuide.length)
      }
    }
  }
  
}





