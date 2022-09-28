//
//  RecommendItemCell.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/16.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import Then
import SnapKit
import DesignSystem
import Kingfisher

final class RecommendItemCell: UICollectionViewCell {

    private var recommendImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private var defaultLabel = AppLabel().then {
        $0.setText("이렇게 실천해보면 어떨까?", font: AppFont.body2)
        $0.textColor = .systemGray500
        $0.textAlignment = .center
    }

    private var titleLabel = AppLabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
    }

    private var subTitleLabel = AppLabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
    }

    private let paragraphStyle = NSMutableParagraphStyle().then {
        $0.lineHeightMultiple = 1.44
        $0.alignment = .center
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func configureUI() {
        addSubviews(recommendImageView, defaultLabel, titleLabel, subTitleLabel)
    }

    private func configureLayout() {

        recommendImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.left.right.equalToSuperview().inset(56)
            $0.height.equalToSuperview().dividedBy(3)
        }

        defaultLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(recommendImageView.snp.bottom).offset(30)
            $0.bottom.equalTo(titleLabel.snp.top).offset(-5)
        }

        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(subTitleLabel.snp.top).offset(-8)
        }

        subTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
    }


    func bind(viewModel: ChallengeRecommendViewModel) {
        recommendImageView.setImage(with: viewModel.imageUrl)
        titleLabel.setText(viewModel.title, font: AppFont.title2Bold)
        subTitleLabel.attributedText = NSAttributedString(
            string: viewModel.description,
            attributes: [.kern: -0.41, .paragraphStyle: paragraphStyle, .font: AppFont.body2])
    }
}
