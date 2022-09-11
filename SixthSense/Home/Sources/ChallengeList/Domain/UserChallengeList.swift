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
    var id: Int
    var challengeID: Int
    var name: String
    var emoji: String
    var challengeDate: Date
    var verificationImage: String
    var verificationMemo: String
    var verificationStatus: String
    
    init() {
        id = -1
        challengeID = -1
        name = ""
        emoji = ""
        challengeDate = .init()
        verificationImage = ""
        verificationMemo = ""
        verificationStatus = ""
    }
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        challengeID <- map["challengeId"]
        name <- map["name"]
        emoji <- map["emoji"]
        challengeDate <- (map["challengeDate"], ISO8601DateTransform())
        verificationImage <- map["verificationImage"]
        verificationMemo <- map["verificationMemo"]
        verificationStatus <- map["verificationStatus"]
    }
}
