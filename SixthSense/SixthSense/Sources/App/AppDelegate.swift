//
//  AppDelegate.swift
//  SixthSense
//
//  Created by 문효재 on 2022/06/27.
//

import UIKit
import Then

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.

    configureDebug()
    // TODO: 해당로직은 Netfox 화면 나오는지 확인하기 위해서 임시로 추가한 코드입니다. 지우셔도됩니다
    let window = UIWindow(frame: UIScreen.main.bounds).with {
      $0.rootViewController = UIViewController()
      $0.backgroundColor = .white
      $0.makeKeyAndVisible()
    }
    self.window = window
    
    return true
  }
}

