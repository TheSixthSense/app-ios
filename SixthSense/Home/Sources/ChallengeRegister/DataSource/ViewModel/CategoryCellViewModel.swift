//
//  CategoryCellViewModel.swift
//  Home
//
//  Created by Allie Kim on 2022/08/28.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import ObjectMapper

struct CategoryCellViewModel: Mappable {

    var id: Int
    var title: String
    var description: String

    init?(map: Map) {
        id = -1
        title = ""
        description = ""
    }

    init(categoryId: Int, title: String, description: String, sort: Int) {
        self.id = categoryId
        self.title = title
        self.description = description
    }

    init() {
        id = -1
        title = ""
        description = ""
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["name"]
        description <- map["description"]
    }
}

extension CategoryCellViewModel: Comparable {
    static func < (lhs: CategoryCellViewModel, rhs: CategoryCellViewModel) -> Bool {
        return lhs.id < rhs.id
    }
}
