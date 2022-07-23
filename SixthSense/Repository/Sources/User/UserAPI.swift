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
  case user
  case login(LoginRequest)
}

extension UserAPI: BaseAPI {
  // FIXME: 추후 UserInfo 제거 하면서 tempURL도 제거
  var baseURL: URL {
      switch self {
          case .user:
              return API.EndPoint.temp.url
  }
  
  var path: String {
    switch self {
      case .user:
        return "/users"
    }
  }
  
  var method: Moya.Method {
    switch self {
      case .user:
        return .get
    }
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
        case .user, .login:
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
