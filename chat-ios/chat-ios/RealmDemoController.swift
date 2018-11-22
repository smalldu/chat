//
//  RealmDemoController.swift
//  chat-ios
//
//  Created by zuber on 2018/8/14.
//  Copyright © 2018年 duzhe. All rights reserved.
//

import UIKit
import RealmSwift

class Dog: Object {
  @objc dynamic var name = ""
  @objc dynamic var age = 0
}
class Person: Object {
  @objc dynamic var name = ""
  @objc dynamic var picture: Data? = nil // optionals supported
  let dogs = List<Dog>()
}

// 您只能在对象被创建的线程中使用该对象 （这句话太重要了）

class RealmDemoController: UIViewController {
  
  init() {
    super.init(nibName: "RealmDemoController", bundle: Bundle.main)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setDefaultRealmForUser(username: String) {
    var config = Realm.Configuration()
    // 使用默认的目录，但是请将文件名替换为用户名
    config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(username).realm")
    // 将该配置设置为默认 Realm 配置
    Realm.Configuration.defaultConfiguration = config
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "realm-demo"
    let myDog = Dog()
    myDog.name = "Rex"
    myDog.age = 1
    
    let realm = try! Realm()
    // 获取realm 文件的父目录
    let folderPath = realm.configuration.fileURL!.deletingLastPathComponent().path
    
    // 禁用此目录的文件保护
    try! FileManager.default.setAttributes([FileAttributeKey.protectionKey : FileProtectionType.none], ofItemAtPath: folderPath)
    
    let puppies = realm.objects(Dog.self).filter("age < 2")
    print(puppies.count)
    
    try! realm.write {
      realm.add(myDog)
    }
    print(puppies.count)
    
    
    DispatchQueue(label: "background").async {
      let realm = try! Realm()
      let theDog = realm.objects(Dog.self).filter("age == 1").first
      try! realm.write {
        theDog!.age = 3
      }
      print(theDog?.age ?? 0)
    }
  }
  
}

