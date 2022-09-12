//
//  SignUpCompleteViewController.swift
//  Account
//
//  Created by Allie Kim on 2022/09/13.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import Then
import SnapKit
import UIKit
import DesignSystem

protocol SignUpCompletePresentableListener: AnyObject {
    func routeToHome()
}

final class SignUpCompleteViewController: UIViewController, SignUpCompletePresentable, SignUpCompleteViewControllable {

    weak var listener: SignUpCompletePresentableListener?

    private let lottieImageView = UIImageView().then {
        $0.image = AppImage.signUpIcon4.image // TEST
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }

    private let titleLabel = AppLabel().then {
        $0.setText("비거너가 된 걸 환영해", font: AppFont.title2Bold)
        $0.textColor = .black
        $0.sizeToFit()
    }


    private let subtitleLabel = UILabel().then {
        let paragraphStyle = NSMutableParagraphStyle().then {
            $0.lineHeightMultiple = 1.44
            $0.alignment = .center
        }
        $0.attributedText = NSAttributedString(string: "챌린지를 위한 준비는 끝!\n우리 함께 실천하러 가볼까?",
                                               attributes: [.kern: -0.41,
                                                                .paragraphStyle: paragraphStyle,
                                                                .font: AppFont.body2])
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.sizeToFit()
    }

    private let startButton = UIButton().then {
        $0.backgroundColor = .main
        $0.setAttributedTitle(NSAttributedString(string: "좋아, 비거너 시작하기!",
                                                 attributes: [.foregroundColor: UIColor.white,
                                                                  .font: AppFont.body1Bold]), for: .normal)
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(didTapStartButton(_:)), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureLayout()
    }
}

extension SignUpCompleteViewController {

    private func configureUI() {
        view.backgroundColor = .white
        view.addSubviews(lottieImageView, titleLabel, subtitleLabel, startButton)
    }

    private func configureLayout() {
        lottieImageView.snp.makeConstraints {
            $0.size.equalTo(100)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(160)
        }

        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(lottieImageView.snp.bottom).offset(40)
        }

        subtitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }

        startButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(view.safeAreaInsets.bottom + 24)
            $0.height.equalTo(68)
        }
    }

    @objc
    func didTapStartButton(_ sender: UIButton) {
        listener?.routeToHome()
    }
}
