//
//  ErrorResponse.swift
//  Repository
//
//  Created by 문효재 on 2022/07/23.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import ObjectMapper

public struct ErrorResponse: Mappable {
    var systemMessage: String
    var userMessage: String
    var error: String // Http Error
    var status: String // Http Error status code

    public init() {
        systemMessage = ""
        userMessage = ""
        error = ""
        status = ""
    }

    public init?(map: Map) {
        systemMessage = ""
        userMessage = ""
        error = ""
        status = ""
    }

    public mutating func mapping(map: Map) {
        systemMessage <- map["meta.systemMessage"]
        userMessage <- map["meta.userMessage"]
        error <- map["error"]
        status <- map["status"]
    }
}
