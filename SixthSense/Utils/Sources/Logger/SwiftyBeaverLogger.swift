//
//  SwiftyLogger.swift
//  SixthSense
//
//  Created by 문효재 on 2022/07/03.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
#if DEBUG
import SwiftyBeaver

public final class SwiftyLogger: Loggable {
  private let log = SwiftyBeaver.self
  
  public init() { }
  public func configure(with configuration: Configuration?) {
    let console = ConsoleDestination()  // log to Xcode Console
    guard let configuration = configuration else { return }
    let cloud = SBPlatformDestination(appID: configuration.value(.swiftyBeaverAppID),
                                      appSecret: configuration.value(.swiftyBeaverAppSecret),
                                      encryptionKey: configuration.value(.swiftyBeaverEncryptKey)) // to cloud
    console.format = "$DHH:mm:ss$d $L $M"
    log.addDestination(console)
    log.addDestination(cloud)
  }

  public func verbose(_ message: Any) {
    log.verbose(message)
  }
  
  public func debug(_ message: Any) {
    log.info(message)
  }
  
  public func info(_ message: Any) {
    log.info(message)
  }

  public func warning(_ message: Any) {
    log.warning(message)
  }

  public func error(_ message: Any) {
    log.error(message)
  }
}
#endif
