//
//  SignUpRequest.swift
//  Repository
//
//  Created by Allie Kim on 2022/07/28.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import ObjectMapper

public struct SignUpRequest: Mappable {

    public var appleId: String
    public var birthDay: String
    public var clientSecret: String
    public var gender: String
    public var nickname: String
    public var userRoleType: String
    public var vegannerStage: String

    public init() {
        appleId = ""
        birthDay = ""
        clientSecret = ""
        gender = ""
        nickname = ""
        userRoleType = "USER"
        vegannerStage = ""
    }

    public init?(map: Map) {
        appleId = ""
        birthDay = ""
        clientSecret = ""
        gender = ""
        nickname = ""
        userRoleType = "USER"
        vegannerStage = ""
    }

    mutating public func mapping(map: Map) {
        appleId <- map["appleId"]
        birthDay <- map["birthDay"]
        clientSecret <- map["clientSecret"]
        gender <- map["gender"]
        nickname <- map["nickName"]
        userRoleType <- map["userRoleType"]
        vegannerStage <- map["vegannerStage"]
    }

    func asBody(_ defaultBody: [String: Any]) -> [String: Any] {
        return defaultBody.with {
            $0.merge(dict: [
                "appleId": appleId
            ])
        }
    }
}
