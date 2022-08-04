//
//  CalendarHeaderView.swift
//  Home
//
//  Created by 문효재 on 2022/08/04.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import DesignSystem

final class CalendarHeaderView: UIView {
    private let headerView = UIView()
    private let monthLabel = UILabel().then {
        $0.text = "2022년 8월"
        $0.font = AppFont.body1Bold
        $0.numberOfLines = 1
        $0.sizeToFit()
    }
    private let monthSelectButton = UIButton().then {
        $0.setImage(DesignSystemAsset.chevronDown.image, for: .normal)
    }
    private let addButton = UIButton().then {
        $0.setImage(DesignSystemAsset.plus.image, for: .normal)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        addSubviews(monthLabel, monthSelectButton, addButton)
    }
    
    func configureConstraints() {
        monthLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        monthSelectButton.snp.makeConstraints {
            $0.left.equalTo(monthLabel.snp.right).offset(7)
            $0.centerY.equalTo(monthLabel)
            $0.width.equalTo(11)
            $0.height.equalTo(6)
        }
        
        addButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(33)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(16)
        }
    }
}
