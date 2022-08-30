//
//  ChallengeJoinRequest.swift
//  Repository
//
//  Created by Allie Kim on 2022/08/30.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import Then
import ObjectMapper

public struct ChallengeJoinRequest: Mappable {

    public var challengeDate: String
    public var challengeId: Int

    public init() {
        challengeDate = ""
        challengeId = -1
    }

    public init(date: String, challengeId: Int) {
        challengeDate = date
        self.challengeId = challengeId
    }

    public init?(map: Map) {
        challengeDate = ""
        challengeId = -1
    }

    mutating public func mapping(map: Map) {
        challengeDate <- map["challengeDate"]
        challengeId <- map["challengeId"]
    }

    func asBody(_ defaultBody: [String: Any]) -> [String: Any] {
        return defaultBody.with {
            $0.merge(dict: [
                "challengeDate": challengeDate,
                "challengeId": challengeId
            ])
        }
    }
}
