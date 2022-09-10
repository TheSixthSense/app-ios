//
//  MyPageHeaderItemCell.swift
//  Home
//
//  Created by Allie Kim on 2022/09/04.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Then
import SnapKit
import UIKit
import DesignSystem

final class MyPageHeaderItemCell: UITableViewCell {

    private var profileImageView = UIImageView().then {
        $0.image = HomeAsset.profileImage.image
        $0.layer.cornerRadius = 45
        $0.clipsToBounds = true
    }

    private var nicknameLabel = UILabel().then {
        $0.numberOfLines = 1
    }

    private var dateChallengeLabel = UILabel().then {
        $0.numberOfLines = 1
    }

    private var challengeStatView = UIView().then {
        $0.backgroundColor = .green100
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = AppColor.green300.cgColor
        $0.layer.borderWidth = 1
    }

    private var challengeCountView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fillEqually
        $0.spacing = 7
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins.top = 17
        $0.layoutMargins.bottom = 17
    }

    private var challengeCountStaticLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.attributedText = NSAttributedString(string: "도전", attributes: [.font: AppFont.body2, .foregroundColor: AppColor.systemGray500])
    }

    private var challengeCountLabel = UILabel().then {
        $0.numberOfLines = 1
    }

    private var challengeVerifiedView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fillEqually
        $0.spacing = 7
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins.top = 17
        $0.layoutMargins.bottom = 17
    }

    private var challengeVerifiedStaticLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.attributedText = NSAttributedString(string: "인증완료", attributes: [.font: AppFont.body2, .foregroundColor: AppColor.systemGray500])
    }

    private var challengeVerifiedLabel = UILabel().then {
        $0.numberOfLines = 1
    }

    private var challengeWaitingView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fillEqually
        $0.spacing = 7
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins.top = 17
        $0.layoutMargins.bottom = 17
    }

    private var challengeWaitingStaticLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.attributedText = NSAttributedString(string: "대기", attributes: [.font: AppFont.body2, .foregroundColor: AppColor.systemGray500])
    }

    private var challengeWaitingLabel = UILabel().then {
        $0.numberOfLines = 1
    }

    private var leftSeparator = UIView().then {
        $0.backgroundColor = .green300
    }

    private var rightSeparator = UIView().then {
        $0.backgroundColor = .green300
    }

    private enum Constants {
        static let labelStyle: [NSAttributedString.Key: Any] = [.font: AppFont.body1, .foregroundColor: AppColor.systemBlack]
        static let boldLabelStyle: [NSAttributedString.Key: Any] = [.font: AppFont.subtitleBold, .foregroundColor: AppColor.green700]
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
        addSubviews(profileImageView, nicknameLabel, dateChallengeLabel, challengeStatView)
        challengeStatView.addSubviews(challengeCountView, leftSeparator, challengeVerifiedView, rightSeparator, challengeWaitingView)
        challengeCountView.addArrangedSubviews(challengeCountStaticLabel, challengeCountLabel)
        challengeVerifiedView.addArrangedSubviews(challengeVerifiedStaticLabel, challengeVerifiedLabel)
        challengeWaitingView.addArrangedSubviews(challengeWaitingStaticLabel, challengeWaitingLabel)
        selectionStyle = .none
        isUserInteractionEnabled = false
    }

    private func configureLayout() {

        profileImageView.snp.makeConstraints {
            $0.size.equalTo(90)
            $0.top.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }

        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }

        dateChallengeLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }

        challengeStatView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(88)
            $0.top.equalTo(dateChallengeLabel.snp.bottom).offset(12)
            $0.bottom.equalToSuperview().inset(30)
        }

        challengeCountView.snp.makeConstraints {
            $0.width.equalTo(100).priority(.low)
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalTo(leftSeparator.snp.left)
        }

        leftSeparator.snp.makeConstraints {
            $0.width.equalTo(1).priority(.required)
            $0.top.equalToSuperview().inset(31.5)
            $0.bottom.equalToSuperview().inset(27)
        }

        challengeVerifiedView.snp.makeConstraints {
            $0.width.top.bottom.equalTo(challengeCountView)
            $0.left.equalTo(leftSeparator.snp.right)
            $0.right.equalTo(challengeWaitingView.snp.left)
        }

        rightSeparator.snp.makeConstraints {
            $0.width.top.bottom.equalTo(leftSeparator)
        }

        challengeWaitingView.snp.makeConstraints {
            $0.left.equalTo(rightSeparator.snp.right)
            $0.width.top.bottom.equalTo(challengeCountView)
            $0.right.equalToSuperview()
        }
    }

    func bind(viewModel: MyPageHeaderViewModel) {
        let nicknameString = NSMutableAttributedString(string: viewModel.nickname,
                                                       attributes: [.font: AppFont.body1Bold,
                                                                        .foregroundColor: AppColor.systemBlack])
        nicknameString.append(NSAttributedString(string: "님의", attributes: Constants.labelStyle))
        nicknameLabel.attributedText = nicknameString

        dateChallengeLabel.attributedText = NSAttributedString(string: "\(Date().month)월 챌린지 현황", attributes: Constants.labelStyle)

        let stats = viewModel.statData
        challengeCountLabel.attributedText = NSAttributedString(string: "\(stats.totalCount)", attributes: Constants.boldLabelStyle)
        challengeVerifiedLabel.attributedText = NSAttributedString(string: "\(stats.successCount)", attributes: Constants.boldLabelStyle)
        challengeWaitingLabel.attributedText = NSAttributedString(string: "\(stats.waitingCount)", attributes: Constants.boldLabelStyle)
    }
}
extension Date {
    var month: String {
        return String(Calendar.current.component(.month, from: self))
    }
}
