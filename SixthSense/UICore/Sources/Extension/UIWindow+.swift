//
//  UIWindow+.swift
//  UICore
//
//  Created by Allie Kim on 2022/08/23.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit

extension UIWindow {
    static var key: UIWindow? {
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }
}
