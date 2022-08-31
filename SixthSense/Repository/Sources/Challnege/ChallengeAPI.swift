//
//  ChallengeAPI.swift
//  Repository
//
//  Created by Allie Kim on 2022/08/21.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import Moya
import Utils

enum ChallengeAPI {
    case categoryLists
    case registerLists
    case recommendLists(String)
    case joinChallenge(ChallengeJoinRequest)
}

extension ChallengeAPI: BaseAPI, AccessTokenAuthorizable {

    var baseURL: URL {
        return API.EndPoint.base.url
    }

    var path: String {
        switch self {
        case .categoryLists:
            return "/category/list"
        case .registerLists:
            return "/challenge/list"
        case .recommendLists(let itemId):
            return "/challenge/guide/\(itemId)"
        case .joinChallenge:
            return "/challenge/join"
        }
    }

    var method: Moya.Method {
        switch self {
        case .joinChallenge:
            return .post
        default:
            return .get
        }
    }

    var authorizationType: AuthorizationType? {
        return .bearer
    }

    var task: Task {
        guard let parameters = parameters else { return .requestPlain }
        let body: [String: Any] = [:]

        switch self {
        case .joinChallenge(let request):
            return .requestCompositeParameters(
                bodyParameters: request.asBody(body),
                bodyEncoding: parameterEncoding,
                urlParameters: parameters)
        default:
            return .requestPlain
        }
    }

    var parameters: [String: Any]? {
        let defaultParameter: [String: Any] = [:]
        switch self {
        default:
            return defaultParameter
        }
    }

    var parameterEncoding: ParameterEncoding {
        switch self {
        case .joinChallenge:
            return JSONEncoding.default
        default:
            return URLEncoding.queryString
        }
    }
}
