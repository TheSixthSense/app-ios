//
//  ChallengeRegisterModel.swift
//  Home
//
//  Created by Allie Kim on 2022/08/30.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import ObjectMapper

public struct ChallengeRegisterModel: Mappable {

    var id: Int
    var categoryId: Int
    var emoji: String
    var title: String
    var sort: Int

    public init?(map: Map) {
        id = -1
        categoryId = -1
        emoji = ""
        title = ""
        sort = -1
    }

    public init() {
        id = -1
        categoryId = -1
        emoji = ""
        title = ""
        sort = -1
    }

    public mutating func mapping(map: Map) {
        id <- map["id"]
        categoryId <- map["categoryId"]
        emoji <- map["emoji"]
        title <- map["name"]
        sort <- map["sort"]
    }
}
