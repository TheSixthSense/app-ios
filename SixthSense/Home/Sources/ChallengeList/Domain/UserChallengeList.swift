//
//  ChallengeList.swift
//  Home
//
//  Created by 문효재 on 2022/09/09.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserChallengeList: Mappable {
    var data: [UserChallengeItem]
    
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

struct UserChallengeItem: Mappable {
    var id: String
    var challengeID: String
    var name: String
    var emoji: String
    var challengeDate: String
    var verificationStatus: String
    
    init() {
        id = ""
        challengeID = ""
        name = ""
        emoji = ""
        challengeDate = ""
        verificationStatus = ""
    }
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        challengeID <- map["challengeID"]
        name <- map["name"]
        emoji <- map["emoji"]
        challengeDate <- map["challengeDate"]
        verificationStatus <- map["verificationStatus"]
    }
}
