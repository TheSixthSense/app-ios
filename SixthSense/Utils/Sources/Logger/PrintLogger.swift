//
//  PrintLogger.swift
//  SixthSense
//
//  Created by 문효재 on 2022/07/03.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation

public final class PrintLogger: Loggable {
  public init() { }
  public func configure(with configuration: Configuration?) {  }
  
  public func verbose(_ message: Any) {
    debugPrint("verbose: \(message)")
  }
  
  public func debug(_ message: Any) {
    debugPrint("debug: \(message)")
  }
  
  public func info(_ message: Any) {
    debugPrint("info: \(message)")
  }
  
  public func warning(_ message: Any) {
    debugPrint("warning: \(message)")
  }
  
  public func error(_ message: Any) {
    debugPrint("error: \(message)")
  }
}
