//
//  SignUpSteps.swift
//  Account
//
//  Created by Allie Kim on 2022/07/19.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import DesignSystem

enum SignUpSteps {
    case exit
    case nickname
    case gender
    case birthday
    case veganStage
}

extension SignUpSteps {

    var navigationTitle: String {
        switch self {
        case .exit:
            return ""
        case .nickname:
            return "step 1"
        case .gender:
            return "step 2"
        case .birthday:
            return "step 3"
        case .veganStage:
            return "step 4"
        }
    }

    var buttonTitle: String {
        switch self {
        case .veganStage:
            return "확인"
        default:
            return "다음"
        }
    }

    var stepIcon: UIImage? {
        switch self {
        case .exit: return nil
        case .nickname:
            return AppImage.signUpIcon1.image
        case .gender:
            return AppImage.signUpIcon2.image
        case .birthday:
            return AppImage.signUpIcon3.image
        case .veganStage:
            return AppImage.signUpIcon4.image
        }
    }
}
