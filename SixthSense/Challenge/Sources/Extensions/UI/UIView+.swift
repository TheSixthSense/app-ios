//
//  View+.swift
//  SixthSense
//
//  Created by Allie Kim on 2022/07/07.
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
