//
//  PrintLogger.swift
//  SixthSense
//
//  Created by 문효재 on 2022/07/03.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation

final class PrintLogger: Loggable {
  func configure(with configuration: Configuration?) {  }
  
  func verbose(_ message: Any) {
    debugPrint("verbose: \(message)")
  }
  
  func debug(_ message: Any) {
    debugPrint("debug: \(message)")
  }
  
  func info(_ message: Any) {
    debugPrint("info: \(message)")
  }
  
  func warning(_ message: Any) {
    debugPrint("warning: \(message)")
  }
  
  func error(_ message: Any) {
    debugPrint("error: \(message)")
  }
}
