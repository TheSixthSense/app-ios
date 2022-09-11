//
//  UserInfoView.swift
//  Home
//
//  Created by Allie Kim on 2022/09/06.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import Then
import SnapKit
import DesignSystem

final class UserInfoview: UIView {

    var titleLabel = UILabel().then {
        $0.textColor = AppColor.systemGray500
        $0.font = AppFont.body2
    }

    var userDataLabel = UILabel().then {
        $0.textColor = AppColor.systemBlack
        $0.font = AppFont.body2
    }

    var editButton = UIButton().then {
        $0.layer.do {
            $0.backgroundColor = AppColor.systemGray100.cgColor
            $0.cornerRadius = 12
        }
        $0.setAttributedTitle(NSAttributedString(string: "수정",
                                                 attributes: [.font: AppFont.caption, .foregroundColor: AppColor.systemGray700]),
                              for: .normal)
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        addSubviews(titleLabel, userDataLabel, editButton)
    }

    private func configureLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(58)
        }

        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(20)
        }

        userDataLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(titleLabel.snp.right).offset(34)
        }

        editButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(20)
            $0.height.equalTo(24)
            $0.width.equalTo(45)
        }
    }
}
