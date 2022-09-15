//
//  UserInfoRequest.swift
//  Repository
//
//  Created by Allie Kim on 2022/09/13.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import Then
import ObjectMapper

public struct UserInfoRequest: Mappable {

    public var nickname: String
    public var birthDay: String
    public var gender: String
    public var vegannerStage: String

    public init() {
        nickname = ""
        birthDay = ""
        gender = ""
        vegannerStage = ""
    }

    public init?(map: Map) {
        nickname = ""
        birthDay = ""
        gender = ""
        vegannerStage = ""
    }

    mutating public func mapping(map: Map) {
        birthDay <- map["birthDay"]
        gender <- map["gender"]
        nickname <- map["nickName"]
        vegannerStage <- map["vegannerStage"]
    }

    func asBody(_ defaultBody: [String: Any]) -> [String: Any] {
        return defaultBody.with {
            $0.merge(dict: [
                "birthDay": birthDay,
                "gender": gender,
                "nickName": nickname,
                "vegannerStage": vegannerStage
            ])
        }
    }
}
