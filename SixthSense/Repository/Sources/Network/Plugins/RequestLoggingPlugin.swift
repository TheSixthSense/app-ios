//
//  RequestLoggingPlugin.swift
//  Repository
//
//  Created by 문효재 on 2022/07/24.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import Moya
import Utils

public final class RequestLoggingPlugin: PluginType {
    private let log: Loggable
    
    private let responseDescription: (TargetType, Response) -> String = { target, response in
        return "\(target.method.rawValue) \(target.path) (\(response.statusCode))"
    }
    
    public init(logger: Loggable) {
        self.log = logger
    }
    
    /// API Response
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
      switch result {
      case let .success(response):
        onSuceed(response, target: target)
      case let .failure(error):
        onFail(error, target: target)
      }
    }

    func onSuceed(_ response: Response, target: TargetType) {
        log.info("SUCCESS: \(responseDescription(target, response))")
    }

    func onFail(_ error: MoyaError, target: TargetType) {
        guard let response: Moya.Response = error.response else {
            log.warning("FAILURE: \(error.localizedDescription)")
            return
        }
        
        if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
            log.warning("FAILURE: \(responseDescription(target, response))\n\(jsonObject)")
        } else if let rawString = String(data: response.data, encoding: .utf8) {
            log.warning("FAILURE: \(responseDescription(target, response))\n\(rawString)")
        } else {
            log.warning("FAILURE: \(responseDescription(target, response))")
        }
    }
}
