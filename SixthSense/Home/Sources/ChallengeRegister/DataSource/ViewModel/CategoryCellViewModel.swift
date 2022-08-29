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

    var categoryId: Int
    var title: String
    var description: String
    var sort: Int

    init?(map: Map) {
        categoryId = -1
        title = ""
        description = ""
        sort = -1
    }

    init(categoryId: Int, title: String, description: String, sort: Int) {
        self.categoryId = categoryId
        self.title = title
        self.description = description
        self.sort = sort
    }

    init() {
        categoryId = -1
        title = ""
        description = ""
        sort = -1
    }

    mutating func mapping(map: Map) {
        categoryId <- map["categoryId"]
        title <- map["name"]
        description <- map["description"]
        sort <- map["sort"]
    }
}

extension CategoryCellViewModel: Comparable {
    static func < (lhs: CategoryCellViewModel, rhs: CategoryCellViewModel) -> Bool {
        return lhs.sort < rhs.sort
    }
}
