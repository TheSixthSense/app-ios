//
//  AppDelegate+Debug.swift
//  SixthSense
//
//  Created by 문효재 on 2022/06/30.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//
#if DEBUG
import netfox
#endif

import Foundation

extension AppDelegate {
  func configureDebug() {
    #if DEBUG
    
    NFX.sharedInstance().start()
    #endif
  }
}
