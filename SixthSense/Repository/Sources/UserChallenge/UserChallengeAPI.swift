//
//  UserChallengeAPI.swift
//  Repository
//
//  Created by 문효재 on 2022/09/09.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import Moya
import Utils

enum UserChallengeAPI {
    case monthList(String)
    case dayList(String)
    case verify(ChallengeVerifyRequest)
    case deleteVerify(Int)
    case deleteChallenge(Int)
}

extension UserChallengeAPI: BaseAPI, AccessTokenAuthorizable {

    var baseURL: URL {
        return API.EndPoint.base.url
    }
    
    var headers: [String : String]? {
        switch self {
            case .dayList, .monthList, .deleteVerify, .deleteChallenge:
                return ["Content-Type": "application/json"]
            case .verify:
                return ["Content-Type": "multipart/form-data"]
        }
    }

    var path: String {
        switch self {
            case .monthList:
                return "/user/challenge/month/list"
            case .dayList:
                return "/user/challenge/list"
            case .verify, .deleteVerify:
                return "/user/challenge/verify"
            case .deleteChallenge:
                return "/user/challenge"
        }
    }

    var method: Moya.Method {
        switch self {
            case .monthList, .dayList:
                return .get
            case .verify:
                return .post
            case .deleteVerify, .deleteChallenge:
                return .delete
        }
    }
    
    var authorizationType: AuthorizationType? {
        return .bearer
    }

    var task: Task {
        guard let parameters = parameters else { return .requestPlain }
        switch self {
            case .monthList, .dayList, .deleteVerify, .deleteChallenge:
                return .requestParameters(parameters: parameters, encoding: parameterEncoding)
            case .verify(let request):
                return .uploadMultipart(request.asMultipart)
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
            case .monthList(let date):
                return ["date": date]
            case .dayList(let date):
                return ["date": date]
            case .verify:
                return [:]
            case .deleteVerify(let id):
                return ["userChallengeId": id]
            case .deleteChallenge(let id):
                return ["userChallengeId": id]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
            case .monthList, .dayList, .deleteVerify:
                return URLEncoding.queryString
            case .verify, .deleteChallenge:
                return JSONEncoding.default
        }
    }
}
