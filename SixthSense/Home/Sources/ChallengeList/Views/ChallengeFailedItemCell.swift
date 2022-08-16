//
//  ChallengeFailedItemCell.swift
//  Home
//
//  Created by 문효재 on 2022/08/16.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import UIKit
import DesignSystem

final class ChallengeFailedItemCell: ChallengeItemCell {
    override func configureViews() {
        super.configureViews()
        
        container.backgroundColor = .sub100
        badge.backgroundColor = .sub500
        badgeTitle.textColor = .sub900
        badgeTitle.text = "재도전"
    }
}
