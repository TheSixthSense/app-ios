//
//  RenewalAuthToken.swift
//  Repository
//
//  Created by 문효재 on 2022/07/24.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation

public struct RenewalAuthToken {
    public var appleID: String
    public var beforeRefreshToken: String
    
    public init(appleID: String, beforeRefreshToken: String) {
        self.appleID = appleID
        self.beforeRefreshToken = beforeRefreshToken
    }
    
    func asBody(_ defaultBody: [String: Any]) -> [String: Any] {
        return defaultBody.with {
            $0.merge(dict: [
                "appleId": appleID,
                "refreshToken": beforeRefreshToken
            ])
        }
    }
}
