//
//  Gender.swift
//  Account
//
//  Created by Allie Kim on 2022/07/19.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation

public enum Gender: Int {
    case male = 0
    case female
    case etc
    case none
}

public extension Gender {

    var stringValue: String {
        switch self {
        case .male:
            return "MALE"
        case .female:
            return "FEMALE"
        case .etc:
            return "ETC"
        case .none:
            return "NONE"
        }
    }
}
