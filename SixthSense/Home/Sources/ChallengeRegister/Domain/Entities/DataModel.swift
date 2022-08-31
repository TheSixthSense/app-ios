//
//  DataModel.swift
//  Home
//
//  Created by Allie Kim on 2022/08/28.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import ObjectMapper

struct DataModel<T: Mappable>: Mappable {
    var data: [T]?

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        data <- map["data"]
    }
}
