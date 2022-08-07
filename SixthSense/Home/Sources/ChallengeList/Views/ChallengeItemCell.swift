//
//  ChallengeItemCell.swift
//  Home
//
//  Created by 문효재 on 2022/08/06.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import DesignSystem

class ChallengeItemCell: UITableViewCell {
    private enum Constants {
        enum Label { }
    }
    
    private let container = UIView().then {
        $0.backgroundColor = UIColor(red: 244/256, green: 251/256, blue: 245/256, alpha: 1)
        $0.layer.cornerRadius = 10
    }
    
    private let image = UIImageView().then {
        $0.image = HomeAsset.vegetable.image
    }

    private let titleLabel = UILabel().then {
        $0.font = AppFont.body1
        $0.textAlignment = .center
        $0.textColor = AppColor.systemBlack
        $0.backgroundColor = .clear
    }
    
    private let badge = UIView().then {
        $0.backgroundColor = AppColor.green100
        $0.layer.cornerRadius = 21
    }
    private let badgeTitle = UILabel().then {
        $0.text = "성공"
        $0.font = AppFont.captionBold
        $0.textColor = AppColor.green700
    }

    // MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String) {
        self.titleLabel.text = title
    }

    func configureViews() {
        self.setNeedsUpdateConstraints()
        contentView.addSubviews(container)
        container.addSubviews(image, titleLabel, badge)
        badge.addSubview(badgeTitle)
    }

    func setupConstraints() {
        container.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(68)
            $0.bottom.equalToSuperview().offset(-8)
        }
        
        image.snp.makeConstraints {
            $0.left.equalToSuperview().inset(24)
            $0.size.equalTo(30)
            $0.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(image.snp.right).offset(20)
        }
        
        badge.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
            $0.size.equalTo(42)
        }
        
        badgeTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
