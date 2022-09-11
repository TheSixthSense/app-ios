//
//  ChallengeCheck.swift
//  Challenge
//
//  Created by 문효재 on 2022/09/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import ObjectMapper

// TODO: 나중에 공통파일로 분리해요
protocol Responsable {
    init()
}

struct Response<T: Responsable & Mappable>: Mappable {
    var data: T
    
    init() {
        data = .init()
    }
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        data <- map["data"]
    }
}

struct ChallengeCheck: Mappable, Responsable {
    var userChallengeID: Int
    var date: String
    var challengeID: Int
    var contentImage: String
    var titleImage: String
    
    init() {
        userChallengeID = -1
        date = ""
        challengeID = -1
        contentImage = ""
        titleImage = ""
    }
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        userChallengeID <- map["userChallengeId"]
        date <- map["challengeDate"]
        challengeID <- map["challengeId"]
        contentImage <- map["contentImage"]
        titleImage <- map["titleImage"]
    }
}
