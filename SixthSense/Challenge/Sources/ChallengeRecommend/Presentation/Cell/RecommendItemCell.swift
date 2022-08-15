//
//  RecommendItemCell.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/16.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import SnapKit
import DesignSystem

final class RecommendItemCell: UICollectionViewCell {

    private lazy var recommendImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = ChallengeAsset.sample.image
    }

    private lazy var defaultLabel = AppLabel().then {
        $0.setText("이렇게 실천해보면 어떨까?", font: AppFont.body2)
        $0.textColor = .systemGray500
        $0.textAlignment = .center
    }

    private lazy var titleLabel = AppLabel().then {
        $0.setText("오트와 두유 베이스의 라떼", font: AppFont.title2Bold)
        $0.textColor = .black
        $0.textAlignment = .center

    }

    private lazy var subTitleLabel = AppLabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.44
        $0.attributedText = NSAttributedString(
            string: "<스타벅스>에서 라떼 주문할 때 오트밀크를 선택해보자\n오트와 두유는 단백질을 채워주고, 고소한 풍미를 더해줘!",
            attributes: [.kern: -0.41, .paragraphStyle: paragraphStyle, .font: AppFont.body2])

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
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

        recommendImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(56)
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

    private func configureUI() {
        addSubviews(recommendImageView, defaultLabel, titleLabel, subTitleLabel)
    }

    func bind(item: String) {

    }
}
