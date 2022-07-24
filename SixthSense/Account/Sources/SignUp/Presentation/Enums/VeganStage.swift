//
//  VeganStage.swift
//  Account
//
//  Created by Allie Kim on 2022/07/19.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation

enum VeganStage: Int {
    case beginner = 0
    case junior
    case senior
    case retry
}

extension VeganStage {

    var stringValue: String {
        switch self {
        case .beginner:
            return "BEGINNER"
        case .junior:
            return "JUNIOR"
        case .senior:
            return "SENIOR"
        case .retry:
            return "RETRY"
        }
    }

}
