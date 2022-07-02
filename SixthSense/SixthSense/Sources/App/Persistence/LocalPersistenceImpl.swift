//
//  LocalPersistenceImpl.swift
//  SixthSense
//
//  Created by 문효재 on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation

public final class LocalPersistenceImpl: LocalPersistence {
  private var source: UserDefaults {
    return UserDefaults.standard
  }
  
  public func value<T: Storable>(on key: LocalPersistenceKey) -> T? {
    guard let rawValue = self.source.value(forKey: key.rawValue) as? String else { return nil }
    return T.init(json: rawValue)
  }
  
  public func save<T: Storable>(value: T?, on key: LocalPersistenceKey) {
    self.source.set(value?.jsonString, forKey: key.rawValue)
  }
  
  public func delete(on key: LocalPersistenceKey) {
    self.source.removeObject(forKey: key.rawValue)
  }
}
