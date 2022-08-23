//
//  UIStackView+.swift
//  UICore
//
//  Created by Allie Kim on 2022/08/23.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit

public extension UIStackView {

    /// add muliple views into UIStackView
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { view in
            self.addArrangedSubview(view)
        }
    }
}

