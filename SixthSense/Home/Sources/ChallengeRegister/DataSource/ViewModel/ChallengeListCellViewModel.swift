//
//  ChallengeListItemCellViewModel.swift
//  Home
//
//  Created by Allie Kim on 2022/08/19.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import ObjectMapper

struct ChallengeListItemCellViewModel: Mappable {

    var id: Int
    var categoryId: Int
    var emoji: String
    var title: String
    var sort: Int

    init?(map: Map) {
        id = -1
        categoryId = -1
        emoji = ""
        title = ""
        sort = -1
    }

    init() {
        id = -1
        categoryId = -1
        emoji = ""
        title = ""
        sort = -1
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        categoryId <- map["categoryId"]
        emoji <- map["emoji"]
        title <- map["name"]
        sort <- map["sort"]
    }
}

extension ChallengeListItemCellViewModel: Comparable {
    static func < (lhs: ChallengeListItemCellViewModel, rhs: ChallengeListItemCellViewModel) -> Bool {
        return lhs.sort < rhs.sort
    }
}
