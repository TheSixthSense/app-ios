//
//  ChallengeRecommendModel.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/29.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import ObjectMapper

public struct DataModel: Mappable {
    var data: [ChallengeRecommendModel]

    public init?(map: Map) {
        data = []
    }

    public mutating func mapping(map: Map) {
        data <- map["data"]
    }
}

public struct ChallengeRecommendModel: Mappable {
    var title: String
    var description: String
    var imagePath: String
    var sort: Int

    public init?(map: Map) {
        title = ""
        description = ""
        imagePath = ""
        sort = -1
    }

    public init() {
        title = ""
        description = ""
        imagePath = ""
        sort = -1
    }

    public mutating func mapping(map: Map) {
        title <- map["title"]
        description <- map["description"]
        imagePath <- map["imagePath"]
        sort <- map["sort"]
    }
}
