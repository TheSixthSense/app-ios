//
//  AlertAction.swift
//  UICore
//
//  Created by Allie Kim on 2022/08/23.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import DesignSystem

public struct AlertAction {

    public enum Style {
        case positive // 오른쪽
        case negative // 왼쪽

        var attributes: [NSAttributedString.Key: Any] {
            switch self {
            case .positive:
                return [.font: AppFont.body2Bold, .foregroundColor: UIColor.white]
            case .negative:
                return [.font: AppFont.body2Bold, .foregroundColor: AppColor.systemGray500]
            }
        }

        var background: UIColor {
            switch self {
            case .positive:
                return AppColor.main
            case .negative:
                return .white
            }
        }

        var borderColor: CGColor {
            switch self {
            case .positive:
                return AppColor.main.cgColor
            case .negative:
                return AppColor.systemGray300.cgColor
            }
        }
    }

    var title: String
    var style: AlertAction.Style

    public static func action(title: String, style: AlertAction.Style) -> AlertAction {
        return AlertAction(title: title, style: style)
    }

    private init(title: String, style: AlertAction.Style) {
        self.title = title
        self.style = style
    }
}
