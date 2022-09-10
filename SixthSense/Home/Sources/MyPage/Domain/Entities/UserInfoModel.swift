//
//  UserInfoModel.swift
//  Home
//
//  Created by Allie Kim on 2022/09/09.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import ObjectMapper

public struct UserInfoModel: Mappable {
    var nickname: String
    var gender: String
    var birthDay: String
    var vegannerStage: String

    public init() {
        self.nickname = ""
        self.gender = ""
        self.birthDay = ""
        self.vegannerStage = ""
    }

    public init?(map: Map) {
        self.nickname = ""
        self.gender = ""
        self.birthDay = ""
        self.vegannerStage = ""
    }

    public mutating func mapping(map: Map) {
        nickname <- map["data.nickName"]
        gender <- map["data.gender"]
        birthDay <- map["data.birthDay"]
        vegannerStage <- map["data.vegannerStage"]
    }
}
