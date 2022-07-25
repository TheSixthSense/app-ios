//
//  LoginRequest.swift
//  Repository
//
//  Created by 문효재 on 2022/07/23.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import Then

public struct LoginRequest {
    public var appleId: String
    
    public init(appleID: String) {
        self.appleId = appleID
    }
    
    func asBody(_ defaultBody: [String: Any]) -> [String: Any] {
        return defaultBody.with {
            $0.merge(dict: [
                "appleId": appleId
            ])
        }
    }
}
