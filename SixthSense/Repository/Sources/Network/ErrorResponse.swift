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

    public init() {
        systemMessage = ""
        userMessage = ""
    }

    public init?(map: Map) {
        systemMessage = ""
        userMessage = ""
    }

    public mutating func mapping(map: Map) {
        systemMessage <- map["meta.systemMessage"]
        userMessage <- map["meta.userMessage"]
    }
}
