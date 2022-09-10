//
//  UserChallengeStatModel.swift
//  Home
//
//  Created by Allie Kim on 2022/09/09.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import ObjectMapper

public struct UserChallengeStatModel: Mappable {
    var successCount: Int
    var totalCount: Int
    var waitingCount: Int

    public init() {
        self.successCount = 0
        self.totalCount = 0
        self.waitingCount = 0
    }

    public init?(map: Map) {
        self.successCount = 0
        self.totalCount = 0
        self.waitingCount = 0
    }

    public mutating func mapping(map: Map) {
        successCount <- map["data.successCount"]
        totalCount <- map["data.totalCount"]
        waitingCount <- map["data.waitingCount"]
    }
}
