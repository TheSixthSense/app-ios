//
//  ChallengeAddCell.swift
//  Home
//
//  Created by 문효재 on 2022/08/15.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import DesignSystem
import Then
import SnapKit

class ChallengeAddCell: UITableViewCell {
    private enum Constants {
        enum Label { }
    }
    
    private let container = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray300.cgColor
        $0.layer.cornerRadius = 10
    }
    
    private let contentsView = UIView()
    
    private let image = UIImageView().then {
        $0.image = HomeAsset.challengeAdd.image
    }

    private let titleLabel = UILabel().then {
        $0.text = "챌린지 추가하기"
        $0.font = AppFont.body1
        $0.textAlignment = .center
        $0.textColor = AppColor.systemGray500
        $0.backgroundColor = .clear
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

    func configure() {}

    func configureViews() {
        contentView.addSubviews(container)
        container.addSubviews(contentsView)
        contentsView.addSubviews(image, titleLabel)
    }

    func setupConstraints() {
        container.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(58)
        }
        
        contentsView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(18)
        }
        
        image.snp.makeConstraints {
            $0.right.equalTo(titleLabel.snp.left).offset(-10)
            $0.left.top.bottom.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
        }
    }
}
