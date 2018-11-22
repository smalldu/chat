//
//  LoginViewController.swift
//  chat-ios
//
//  Created by zuber on 2018/11/22.
//  Copyright © 2018年 duzhe. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  @IBOutlet weak var userNameField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
  }
  
  @objc
  func login(){
    guard let uid = userNameField.text else { return }
    currentUID = uid
    DScoket.shared.connect()
    if let navController = self.storyboard?.instantiateViewController(withIdentifier: "chatListNav") as? UINavigationController {
      self.present(navController, animated: true, completion: nil)
    }
  }
  
}

