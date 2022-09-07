//
//  ChallengeSpacingCell.swift
//  Home
//
//  Created by 문효재 on 2022/09/07.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import DesignSystem
import Then
import SnapKit

class ChallengeSpacingCell: UITableViewCell {
    private enum Constants {
        enum Label { }
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

    func configure() { }

    func configureViews() {
        selectionStyle = .none
    }

    func setupConstraints() {
        contentView.snp.makeConstraints {
            $0.height.equalTo(10)
        }
    }
}
