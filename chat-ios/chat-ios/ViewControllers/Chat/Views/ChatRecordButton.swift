//
//  ChatRecordButton.swift
//  ZuberChat
//  语音按钮
//  Created by duzhe on 2017/2/12.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit
import AVFoundation

protocol ChatRecordButtonDelegate:class {
  func startRecord()
  func endRecord()
  func cancelSend()
  func cancel()
  func dragInside()
}

class ChatRecordButton: UIButton {
  
  private var isRecording = false
  fileprivate var canRecord = true // 是否有相关权限
  weak var delegate:ChatRecordButtonDelegate?
  
  fileprivate var contentLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.black
    label.font = UIFont.systemFont(ofSize: 15)
    label.textAlignment = .center
    return label
  }()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.backgroundColor = UIColor.green
    self.layer.cornerRadius = 4
    self.layer.borderWidth = 0.5
    self.layer.borderColor = b6b6b6.cgColor
//    self.normal_color = UIColor.black

    addSubview(contentLabel)
    contentLabel.text = "按下 说话"
    
    self.setTitle("", for: .normal)
    self.addTarget(self, action: #selector(startRecord), for: .touchDown)
    self.addTarget(self, action: #selector(endRecord), for: .touchUpInside)
    self.addTarget(self, action: #selector(cancelSend), for: .touchDragOutside)
    self.addTarget(self, action: #selector(cancel), for: .touchUpOutside)
    self.addTarget(self, action: #selector(dragInside), for: .touchDragInside)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    contentLabel.frame = self.bounds
  }
  
  // 开始记录
  @objc func startRecord(){
    if isRecording {
      return
    }
    isRecording = true
    self.backgroundColor = UIColor.lightGray
    contentLabel.text = "松开 结束"
    AVAudioSession.sharedInstance().requestRecordPermission { [weak self] (b) -> Void in
      guard let strongSelf = self else { return }
      if b{
        strongSelf.canRecord = true
        strongSelf.delegate?.startRecord()
      }else{
        strongSelf.canRecord = false
        DispatchQueue.main.async(execute: { () -> Void in
          let alertController = UIAlertController(title:"未获取到麦克风权限",
                                                  message:"请在手机设置中开启麦克风使用权限" ,
                                                  preferredStyle: .alert)
          let cancelAction = UIAlertAction(title:"取消", style: .cancel, handler:{ _ in
          })
          let settingsAction = UIAlertAction(title: "立即开启", style: .default, handler: { (action) -> Void in
            if let url = URL(string: UIApplicationOpenSettingsURLString){
              if UIApplication.shared.canOpenURL(url){
                UIApplication.shared.openURL(url)
              }
            }
          })
          alertController.addAction(cancelAction)
          alertController.addAction(settingsAction)
//          self?.responderViewController()?.present(alertController, animated: true, completion: nil)
        })
      }
    }
  }
  
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    let inside = super.point(inside: point, with: event)
    if inside && !self.isHighlighted {
      self.isHighlighted = true
      
      print("record button state: \(self.state)")
      // 手动调用touchdown
      self.sendActions(for: .touchDown)
    }
    return inside
  }
  
  @objc func endRecord(){
    if !self.canRecord && !isRecording{
      delegate?.cancel()
      return
    }
    contentLabel.text = "按下 说话"
    self.backgroundColor = UIColor.green
    // 上传数据
    delegate?.endRecord()
    endRecording()
  }
  
  @objc func cancelSend(){
    if !self.canRecord && !isRecording{
      delegate?.cancel()
      return
    }
    // 放手就取消操作
    delegate?.cancelSend()
  }
  
  @objc func cancel(){
    if !self.canRecord && !isRecording{
      delegate?.cancel()
      return
    }
    contentLabel.text = "按下 说话"
    self.backgroundColor = UIColor.green
    // 取消发送
    delegate?.cancel()
    endRecording()
  }
  
  @objc func dragInside(){
    if !self.canRecord && !isRecording{
      delegate?.cancel()
      return
    }
    // 重新回来
    delegate?.dragInside()
  }
  
  func endRecording(){
    
  }
  
}
