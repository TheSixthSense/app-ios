//
//  ModifyInfo.swift
//  Home
//
//  Created by Allie Kim on 2022/09/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import DesignSystem

enum ModifyType {
    case nickname
    case gender
    case birthday
    case veganStage
}

extension ModifyType {

    var stepIcon: UIImage? {
        switch self {
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
