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

    var buttonTitle: String {
        switch self {
        case .exit:
            return ""
        case .nickname:
            return "또 궁금한 건?"
        case .gender:
            return "이거야!"
        case .birthday:
            return "마지막 질문은?"
        case .veganStage:
            return "마지막 질문까지 완료!"
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
