//
//  AuthAPI.swift
//  Repository
//
//  Created by 문효재 on 2022/07/24.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import Moya
import Utils

enum AuthAPI {
    case refresh(RenewalAuthToken)
}

extension AuthAPI: BaseAPI {
    var path: String {
        switch self {
            case .refresh:
                return "/auth/refreshToken"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .refresh:
                return .post
        }
    }
    
    var task: Task {
        guard let parameters = parameters else { return .requestPlain }
        let body: [String: Any] = [:]
        
        switch self {
            case .refresh(let request):
                return .requestCompositeParameters(bodyParameters: request.asBody(body), bodyEncoding: parameterEncoding, urlParameters: parameters)
        }
    }
    
    var parameters: [String: Any]? {
        let defaultParameter: [String: Any] = [:]
        switch self {
            case .refresh:
                return defaultParameter
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
            case .refresh:
                return JSONEncoding.default
        }
    }
}
