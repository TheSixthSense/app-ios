//
//  AppIcon.swift
//  DesignSystem
//
//  Created by Allie Kim on 2022/07/19.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit

public enum AppIcon {

    public static var back: UIImage {
        return UIImage(.back)!.color(.systemGray300)
    }

    public static var close: UIImage {
        return UIImage(.xmark)!.color(.systemGray300)
    }
}

enum SFSymbolKey: String {
    case back = "chevron.left"
    case xmark
}

extension UIImage {

    func color(_ color: AppColor) -> UIImage {
        return self.withTintColor(color, renderingMode: .alwaysOriginal)
    }

    convenience init?(_ sfSymbolKey: SFSymbolKey) {
        self.init(systemName: sfSymbolKey.rawValue)
    }
}
