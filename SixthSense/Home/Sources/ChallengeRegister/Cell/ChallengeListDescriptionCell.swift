//
//  ChallengeListDescriptionCell.swift
//  Home
//
//  Created by Allie Kim on 2022/08/21.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import DesignSystem
import Then
import SnapKit

final class ChallengeListDescriptionCell: UITableViewCell {

    private let descriptionLabel = UILabel().then {
        $0.textColor = .systemGray500
        $0.numberOfLines = 0
    }

    private let textAttributes: [NSAttributedString.Key: Any] = [.font: AppFont.body1]

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
        addSubviews(descriptionLabel)
        selectionStyle = .none
    }

    private func configureLayout() {
        descriptionLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(40)
        }
    }

    func add(description: String) {
        descriptionLabel.attributedText = NSAttributedString(
            string: description,
            attributes: [.font: AppFont.body1])
    }
}
