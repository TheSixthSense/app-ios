//
//  BaseAPI.swift
//  Repository
//
//  Created by 문효재 on 2022/07/23.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation

import Moya

protocol BaseAPI: TargetType { }

extension BaseAPI {
    var baseURL: URL { API.EndPoint.base.url }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
