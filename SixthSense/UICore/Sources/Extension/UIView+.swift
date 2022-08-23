//
//  UIView+.swift
//  UICore
//
//  Created by Allie Kim on 2022/08/23.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit

public extension UIView {

    /// add muliple views into UIView
    func addSubviews(_ views: UIView...) {
        views.forEach { view in
            self.addSubview(view)
        }
    }
}
