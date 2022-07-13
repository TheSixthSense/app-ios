//
//  ButtonProtocol.swift
//  DesignSystem
//
//  Created by Allie Kim on 2022/07/12.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation

protocol ButtonProtocol {
    var hasFocused: Bool { get set }
    var titleColor: AppColor { get set }
    func setButtonTitle(with: String)
}

