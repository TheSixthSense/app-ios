//
//  AppIcon.swift
//  DesignSystem
//
//  Created by Allie Kim on 2022/07/18.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit

public typealias AppImage = DesignSystemAsset

enum SFSymbolKey: String {
    case back

}

extension UIImage {
    convenience init?(_ sfSymbolKey: SFSymbolKey) {
        self.init(systemName: sfSymbolKey.rawValue)
    }
}
