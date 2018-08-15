//
//  AppDelegate.swift
//  chat-ios
//
//  Created by 杜哲 on 2018/8/10.
//  Copyright © 2018年 duzhe. All rights reserved.
//

import UIKit
import SocketIO

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
      
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
      DScoket.shared.disconnect()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
      
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
      DScoket.shared.connect()
    }

    func applicationWillTerminate(_ application: UIApplication) {
      
    }

}

