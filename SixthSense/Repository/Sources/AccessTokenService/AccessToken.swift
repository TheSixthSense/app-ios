//
//  AccessToken.swift
//  Repository
//
//  Created by 문효재 on 2022/07/27.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import ObjectMapper

public struct AccessToken: Mappable {
    public var accessToken: String
    public var refreshToken: String
    
    init() {
        accessToken = ""
        refreshToken = ""
    }
    
    public init?(map: Map) {
        self.init()
    }
    
    public mutating func mapping(map: Map) {
        accessToken <- map["data.accessToken"]
        refreshToken <- map["data.refreshToken"]
    }
}
