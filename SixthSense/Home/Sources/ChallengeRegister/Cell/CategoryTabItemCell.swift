//
//  CategoryTabItemCell.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/12.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Then
import SnapKit
import UIKit
import DesignSystem

final class CategoryTabItemCell: UICollectionViewCell {

    private let titleLabel = UILabel().then {
        $0.textColor = .systemGray500
    }

    private let line = UIView().then {
        $0.backgroundColor = .systemGray300
    }

    override var isSelected: Bool {
        willSet {
            titleLabel.textColor = newValue ? .black : .systemGray500
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(titleLabel, line)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        isSelected = false
    }

    private func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        line.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }

    func setCategory(with title: String) {
        titleLabel.attributedText = NSAttributedString(
            string: title,
            attributes: [.font: AppFont.body1])
    }
}
