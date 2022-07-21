//
//  SignUpRequestModel.swift
//  Account
//
//  Created by Allie Kim on 2022/07/19.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import ObjectMapper

public struct SignUpRequestModel: Mappable {

    public var appleId: String
    public var birthDay: String
    public var clientSecret: String
    public var gender: String
    public var nickName: String
    public var userRoleType: String
    public var vegannerStage: String

    init() {
        appleId = ""
        birthDay = ""
        clientSecret = ""
        gender = ""
        nickName = ""
        userRoleType = "USER"
        vegannerStage = ""
    }

    public init?(map: Map) {
        appleId = ""
        birthDay = ""
        clientSecret = ""
        gender = ""
        nickName = ""
        userRoleType = "USER"
        vegannerStage = ""
    }

    public mutating func mapping(map: Map) {
        appleId <- map["appleId"]
        birthDay <- map["birthDay"]
        clientSecret <- map["clientSecret"]
        gender <- map["gender"]
        nickName <- map["nickName"]
        userRoleType <- map["userRoleType"]
        vegannerStage <- map["vegannerStage"]
    }
}
