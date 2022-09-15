//
//  GenderInfo.swift
//  Home
//
//  Created by Allie Kim on 2022/09/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation

public enum GenderInfo: String {

    case male = "MALE"
    case female = "FEMALE"
    case etc = "ETC"
    case none = "NONE"

    var localized: String {
        switch self {
        case .male: return "남성"
        case .female: return "여성"
        case .etc: return "그 외 성별"
        case .none: return "선택하지 않음"
        }
    }

    var intValue: Int {
        switch self {
        case .male: return 0
        case .female: return 1
        case .etc: return 2
        case .none: return 3
        }
    }
}

