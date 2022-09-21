//
//  ChallengeWaitingItemCell.swift
//  Home
//
//  Created by 문효재 on 2022/08/16.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import UIKit
import DesignSystem

final class ChallengeWaitingItemCell: ChallengeItemCell {
    override func configureViews() {
        super.configureViews()
        
        container.backgroundColor = UIColor(red: 226/256, green: 227/256, blue: 223/256, alpha: 0.5)
        badge.backgroundColor = .systemGray100
        badgeTitle.textColor = .systemGray700
        badgeTitle.text = "대기"
    }
}
