//
//  CategoryModel.swift
//  Home
//
//  Created by Allie Kim on 2022/08/30.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import ObjectMapper

public struct CategoryModel: Mappable {

    var id: Int
    var title: String
    var description: String

    public init?(map: Map) {
        id = -1
        title = ""
        description = ""
    }

    public init(categoryId: Int, title: String, description: String) {
        self.id = categoryId
        self.title = title
        self.description = description
    }

    public init() {
        id = -1
        title = ""
        description = ""
    }

    public mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["name"]
        description <- map["description"]
    }
}
