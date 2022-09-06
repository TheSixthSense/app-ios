//
//  MyPageItemCell.swift
//  Home
//
//  Created by Allie Kim on 2022/09/05.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Then
import SnapKit
import UIKit
import DesignSystem

final class MyPageItemCell: UITableViewCell {

    private var containerView = UIView().then {
        $0.backgroundColor = .white
    }

    private var titleLabel = AppLabel()

    private var arrowImageView = UIImageView().then {
        $0.image = AppIcon.next
        $0.clipsToBounds = true
    }

    private var line = UIView().then {
        $0.backgroundColor = .systemGray100
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
        addSubview(containerView)
        containerView.addSubviews(titleLabel, arrowImageView, line)
    }

    private func configureLayout() {
        containerView.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(6)
            $0.centerY.equalToSuperview()
        }

        arrowImageView.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.right)
            $0.right.centerY.equalToSuperview()
            $0.width.equalTo(7)
            $0.height.equalTo(11)
        }

        line.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }

    func bind(viewModel: MyPageItemCellViewModel) {
        titleLabel.setText(viewModel.type.title, font: AppFont.body1)
    }
}
