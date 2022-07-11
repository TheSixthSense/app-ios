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

let log: Loggable = {
#if DEBUG
  return SwiftyLogger()
#else
  return PrintLogger()
#endif
}()


extension AppDelegate {
  func configureDebug() {
    let configuration: Configuration = MainConfiguration()
    log.configure(with: configuration)
    #if DEBUG
    NFX.sharedInstance().start()
    #endif
  }
}
