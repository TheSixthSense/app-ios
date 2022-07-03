//
//  Configuration.swift
//  SixthSense
//
//  Created by 문효재 on 2022/07/03.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation

// TODO: 프로토콜과 enum은 추후 모듈로 옮길 예정이에요
enum ConfigurationKey: String {
  case swiftyBeaverAppID = "SWIFTYBEAVER_APP_ID"
  case swiftyBeaverAppSecret = "SWIFTYBEAVER_APP_SECRET"
  case swiftyBeaverEncryptKey = "SWIFTYBEAVER_ENCRYPT_KEY"
}

protocol Configuration {
  func value(_ key: ConfigurationKey) -> String
}

