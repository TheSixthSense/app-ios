//
//  UserAPI.swift
//  SixthSense
//
//  Created by 문효재 on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import Moya

enum UserAPI {
  case user
}

extension UserAPI: TargetType {
  var headers: [String: String]? {
    return ["Content-Type": "application/json"]
  }

  var baseURL: URL {
    return URL(string: "https://jsonplaceholder.typicode.com")!
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
    switch self {
      default:
        return .requestPlain
    }
  }
  
  var parameters: [String: Any]? {
    switch self {
      default:
        return [:]
    }
  }
  
  var parameterEncoding: ParameterEncoding {
    switch self {
      default:
        return URLEncoding.queryString
    }
  }
}
