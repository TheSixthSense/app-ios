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
}

extension ChallengeAPI: BaseAPI, AccessTokenAuthorizable {

    var baseURL: URL {
        return API.EndPoint.base.url
    }

    var path: String {
        switch self {
        case .categoryLists:
            return "/"
        case .registerLists:
            return "/challenge/list"
        case .recommendLists(let itemId):
            return "/challenge/guide/\(itemId)"
        }
    }

    var method: Moya.Method {
        switch self {
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
        default:
            return URLEncoding.queryString
        }
    }
}
