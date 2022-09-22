//
//  AppDelegate+Debug.swift
//  SixthSense
//
//  Created by 문효재 on 2022/06/30.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//
#if DEBUG
import netfox
import SwiftyBeaver
#endif
import Utils
import Foundation

extension AppDelegate {
  func configureDebug() {
    #if DEBUG
    let configuration: Configuration = MainConfiguration()
    SwiftyLogger().configure(with: configuration)
    NFX.sharedInstance().start()
    #endif
  }
}
