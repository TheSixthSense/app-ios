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

    private let containerView = UIView().then {
        $0.layer.borderColor = AppColor.systemGray300.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
    }

    private let emojiLabel = UILabel().then {
        $0.font = AppFont.subtitle
        $0.numberOfLines = 1
        $0.sizeToFit()
    }

    private var contentLabel = AppLabel().then {
        $0.numberOfLines = 0
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    private func configureUI() {
        addSubviews(containerView)
        containerView.addSubviews(emojiLabel, contentLabel)
        selectionStyle = .none
    }

    private func configureLayout() {
        containerView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview().inset(10)
            $0.height.equalTo(58)
        }

        emojiLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }

        contentLabel.snp.makeConstraints {
            $0.left.equalTo(emojiLabel.snp.right).offset(16)
            $0.right.centerY.equalToSuperview()
        }
    }

    func selected() {
        containerView.layer.borderColor = AppColor.main.cgColor
        containerView.backgroundColor = AppColor.green100
        containerView.layer.borderWidth = 1.5
        contentLabel.textColor = AppColor.green700
        contentLabel.font = AppFont.body2Bold
    }

    func deselected() {
        containerView.layer.borderColor = AppColor.systemGray300.cgColor
        containerView.backgroundColor = .white
        containerView.layer.borderWidth = 1
        contentLabel.textColor = AppColor.systemBlack
        contentLabel.font = AppFont.body2
    }

    // FIXME: - Datasource
    func bind(item: ChallengeListItemCellViewModel) {
        contentLabel.setText(item.title, font: AppFont.body2)
        emojiLabel.text = item.emoji
    }
}
