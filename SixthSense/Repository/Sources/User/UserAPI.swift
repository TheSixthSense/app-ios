//
//  UserAPI.swift
//  SixthSense
//
//  Created by 문효재 on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import Moya
import Utils

enum UserAPI {
    case info
    case login(LoginRequest)
    case validateNickname(String)
    case signUp(SignUpRequest)
    case challengeStats
}

extension UserAPI: BaseAPI, AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        switch self {
        case .info, .challengeStats:
            return .bearer
        default:
            return .none
        }
    }

    var baseURL: URL {
        return API.EndPoint.base.url
    }

    var path: String {
        switch self {
        case .info:
            return "/user/info"
        case .login:
            return "/auth/login"
        case .signUp:
            return "/signup"
        case .validateNickname:
            return "/check/nick-name"
        case .challengeStats:
            return "/user/challenge/stats"
        }
    }

    var method: Moya.Method {
        switch self {
        case .info, .validateNickname, .challengeStats:
            return .get
        case .login, .signUp:
            return .post
        }
    }

    var task: Task {
        guard let parameters = parameters else { return .requestPlain }
        let body: [String: Any] = [:]

        switch self {
        case .login(let request):
            return .requestCompositeParameters(
                bodyParameters: request.asBody(body),
                bodyEncoding: parameterEncoding,
                urlParameters: parameters)
        case .signUp(let signUpRequest):
            return .requestCompositeParameters(
                bodyParameters: signUpRequest.asBody(body),
                bodyEncoding: parameterEncoding,
                urlParameters: parameters)
        case .validateNickname:
            return .requestParameters(
                parameters: parameters,
                encoding: parameterEncoding)
        default:
            return .requestPlain
        }
    }

    var parameters: [String: Any]? {
        let defaultParameter: [String: Any] = [:]
        switch self {
        case .validateNickname(let text):
            return ["nickName": text]
        default:
            return defaultParameter
        }
    }

    var parameterEncoding: ParameterEncoding {
        switch self {
        case .login, .signUp:
            return JSONEncoding.default
        default:
            return URLEncoding.queryString
        }
    }
}
