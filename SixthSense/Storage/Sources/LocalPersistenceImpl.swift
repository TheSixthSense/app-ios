//
//  LocalPersistenceImpl.swift
//  SixthSense
//
//  Created by 문효재 on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation

public final class LocalPersistenceImpl: LocalPersistence {
  private var source: Persistable
  
  public init(source: Persistable) {
    self.source = source
  }
    
    public func value<T>(on key: LocalPersistenceKey) -> T? {
        self.source.value(forKey: key.rawValue) as? T
    }
    
    public func save<T>(value: T?, on key: LocalPersistenceKey) {
        self.source.set(value, forKey: key.rawValue)
    }
  
  public func valueObject<T: Storable>(on key: LocalPersistenceKey) -> T? {
    guard let rawValue = self.source.value(forKey: key.rawValue) as? String else { return nil }
    return T.init(json: rawValue)
  }
  
  public func saveObject<T: Storable>(value: T?, on key: LocalPersistenceKey) {
    self.source.set(value?.jsonString, forKey: key.rawValue)
  }
  
  public func delete(on key: LocalPersistenceKey) {
    self.source.removeObject(forKey: key.rawValue)
  }
}

// TODO: 모듈분리 이후 파일로 분리할 예정이에요
public protocol Persistable {
  func value(forKey key: String) -> Any?
  func set(_ value: Any?, forKey defaultName: String)
  func removeObject(forKey defaultName: String)
}
extension UserDefaults: Persistable { }

