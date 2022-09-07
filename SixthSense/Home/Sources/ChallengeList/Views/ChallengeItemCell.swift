//
//  ChallengeItemCell.swift
//  Home
//
//  Created by 문효재 on 2022/08/06.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import DesignSystem
import Then
import SnapKit

class ChallengeItemCell: UITableViewCell {
    private enum Constants {
        enum Label { }
    }
    
    let container = UIView().then {
        $0.layer.cornerRadius = 10
    }
    
    private let emoji = UILabel().then {
        $0.font = AppFont.subtitle
        $0.numberOfLines = 1
        $0.sizeToFit()
    }

    let titleLabel = UILabel().then {
        $0.font = AppFont.body1
        $0.textAlignment = .center
        $0.textColor = AppColor.systemBlack
        $0.backgroundColor = .clear
    }
    
    let badge = UIView().then {
        $0.layer.cornerRadius = 21
    }
    
    let badgeTitle = UILabel().then {
        $0.font = AppFont.captionBold
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

    func configure(viewModel: ChallengeItemCellViewModel) {
        self.titleLabel.text = viewModel.title
        self.emoji.text = viewModel.emoji
    }

    func configureViews() {
        selectionStyle = .none
        self.setNeedsUpdateConstraints()
        contentView.addSubviews(container)
        container.addSubviews(emoji, titleLabel, badge)
        badge.addSubview(badgeTitle)
    }

    func setupConstraints() {
        container.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(58)
        }
        
        emoji.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.size.equalTo(24)
            $0.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(emoji.snp.right).offset(16)
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
