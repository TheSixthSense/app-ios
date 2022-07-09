//
//  LocalPersistence.swift
//  SixthSense
//
//  Created by 문효재 on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
// TODO: 모듈화 이후 각 타입별로 파일 나눌 예정이에요

public enum LocalPersistenceKey: String {
  case accessToken
  case refreshToken
}

public protocol Storable {
  init?(json: String)
  var jsonString: String? { get }
}

/**
 UserDefaults에 앱 내에 저장해야할 데이터를 저장합니다
 */
public protocol LocalPersistence: AnyObject {
  func value<T: Storable>(on key: LocalPersistenceKey) -> T?
  func save<T: Storable>(value: T?, on key: LocalPersistenceKey)
  func delete(on key: LocalPersistenceKey)
}
