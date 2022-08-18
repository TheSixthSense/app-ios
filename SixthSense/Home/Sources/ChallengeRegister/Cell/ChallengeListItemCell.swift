//
//  ChallengeListItemCell.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/13.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import SnapKit
import Then
import RxSwift
import UIKit
import DesignSystem

final class ChallengeListItemCell: UITableViewCell {

    private lazy var iconView = UIImageView().then {
        $0.image = AppImage.retryIconDefault.image
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }

    private let containerView = UIView().then {
        $0.layer.borderColor = AppColor.systemGray300.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
    }

    private lazy var contentLabel = AppLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        containerView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalToSuperview().inset(10)
        }

        iconView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }

        contentLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(16)
            $0.right.centerY.equalToSuperview()
        }
    }

    private func configureUI() {
        addSubviews(containerView)
        containerView.addSubviews(iconView, contentLabel)
        selectionStyle = .none
    }

    // FIXME: - Datasource
    func bind(item: String) {
        contentLabel.text = item
    }
}
