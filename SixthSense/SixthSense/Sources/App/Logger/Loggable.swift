//
//  Loggable.swift
//  SixthSense
//
//  Created by 문효재 on 2022/07/03.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation

protocol Loggable {
  func configure(with configuration: Configuration?)
  func verbose(_ message: Any)
  func debug(_ message: Any)
  func info(_ message: Any)
  func warning(_ message: Any)
  func error(_ message: Any)
}
