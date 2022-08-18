//
//  ChallengeSuccessItemCell.swift
//  Home
//
//  Created by 문효재 on 2022/08/16.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import UIKit
import DesignSystem

final class ChallengeSuccessItemCell: ChallengeItemCell {
    override func configureViews() {
        super.configureViews()
        
        container.backgroundColor = UIColor(red: 244/256, green: 251/256, blue: 245/256, alpha: 1)
        badge.backgroundColor = AppColor.green100
        badgeTitle.textColor = AppColor.green700
        badgeTitle.text = "성공"
    }
}
