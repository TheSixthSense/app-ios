//
//  AccessTokenPlugin.swift
//  Repository
//
//  Created by 문효재 on 2022/07/24.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import Moya
import Storage

public final class AccessTokenPlugin: PluginType {
    private let persistence: LocalPersistence
    
    public init(persistence: LocalPersistence) {
        self.persistence = persistence
    }
    
    private var request: (RequestType, TargetType)?
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let authorizable = target as? AccessTokenAuthorizable,
              let authorizationType = authorizable.authorizationType else { return request }
        var request = request
        let accessToken: String? = persistence.value(on: .accessToken)
        if let accessToken = accessToken, !accessToken.isEmpty {
            let authValue = "\(authorizationType.value) \(accessToken)"
            request.addValue(authValue, forHTTPHeaderField: "Authorization")
        }
        return request

    }
}
