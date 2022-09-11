//
//  ChallengeCalendarItem.swift
//  Home
//
//  Created by 문효재 on 2022/09/09.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserChallengeCalendarList: Mappable {
    var data: [UserChallengCalendarItem]
    
    init() {
        data = []
    }
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        data <- map["data"]
    }
}

struct UserChallengCalendarItem: Mappable {
    var date: String
    var successCount: Int
    var totalCount: Int
    
    init() {
        date = ""
        successCount = 0
        totalCount = 0
    }
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        date <- map["date"]
        successCount <- map["success_count"]
        totalCount <- map["total_count"]
    }
}
