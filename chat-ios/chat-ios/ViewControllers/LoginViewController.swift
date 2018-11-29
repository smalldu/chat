//
//  LoginViewController.swift
//  chat-ios
//
//  Created by zuber on 2018/11/22.
//  Copyright © 2018年 duzhe. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
  
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
    passwordField.isSecureTextEntry = true
  }
  
  @objc
  func login() {
    guard let email = emailField.text , let pwd = passwordField.text else { return }
    guard let auth = "\(email):\(pwd)".data(using: .utf8)?.base64EncodedString() else { return }
    // 密码方式
    let headers: [String: String] = ["Authorization": "Basic \(auth)","Accept": "application/json"]
    
    // token 方式 均验证ok
//    let t = "eyJpYXQiOjE1NDM0ODI3NzksImV4cCI6MTU0MzQ4NjM3OSwiYWxnIjoiSFMyNTYifQ.eyJpZCI6M30.St4qHImPw3dZ8XJmOo4idxItJtLYPPR7q-udGBaMcEY"
//    guard let token = "\(t):".data(using: .utf8)?.base64EncodedString() else { return }
//    let headers: [String: String] = ["Authorization": "Basic \(token)","Accept": "application/json"]
    print(headers)
    // 验证ok 可以登录 。
    request("http://127.0.0.1:8000/api/v1.0/posts", method: .get , parameters: nil , encoding: JSONEncoding.default , headers: headers).responseJSON { (response) in
      print(response.value)
    }
    
//    guard let uid = userNameField.text else { return }
//    Global.loginUser = uid
//    DScoket.shared.connect()
//    if let navController = self.storyboard?.instantiateViewController(withIdentifier: "chatListNav") as? UINavigationController {
//      self.present(navController, animated: true, completion: nil)
//    }
  }
  
}

