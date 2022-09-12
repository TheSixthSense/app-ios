//
//  VeganStageInfo.swift
//  Home
//
//  Created by Allie Kim on 2022/09/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation

public enum VeganStageInfo: String {

    case beginner = "BEGINNER"
    case junior = "JUNIOR"
    case senior = "SENIOR"
    case retry = "RETRY"

    var localized: String {
        switch self {
        case .beginner:
            return "처음이야, 이제 시작해보려고 해!"
        case .junior:
            return "아직 비건 초심자, 조금씩 실천하는 중이야!"
        case .senior:
            return "예전부터 꾸준히 실천하고 있어!"
        case .retry:
            return "잠시 쉬었다가 왔어! 다시 도전해보려고 해"
        }
    }

    var intValue: Int {
        switch self {
        case .beginner:
            return 0
        case .junior:
            return 1
        case .senior:
            return 2
        case .retry:
            return 3
        }
    }
}

