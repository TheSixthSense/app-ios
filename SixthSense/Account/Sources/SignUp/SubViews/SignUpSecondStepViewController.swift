//
//  SignUpSecondStepViewController.swift
//  VegannerApp
//
//  Created by Allie Kim on 2022/07/15.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import SnapKit
import Then
import DesignSystem

// TODO: - 버튼 활성화 observer
final class SignUpSecondStepViewController: UIViewController {

    private var stepLabel = AppLabel().then { label in
        label.setText("비거너!\n너의 성별을 알려줘", font: AppFont.title2)
    }

    private var buttonStackView = UIStackView().then { stack in
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 12
    }

    private lazy var maleButton = SelectButton(title: "남성")
    private lazy var femaleButton = SelectButton(title: "여성")
    private lazy var aButton = SelectButton(title: "그 외 성별")
    private lazy var noneButton = SelectButton(title: "선택 안 함")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureLayout()
    }
}

private extension SignUpSecondStepViewController {

    private func configureUI() {
        view.addSubviews([stepLabel, buttonStackView])
        buttonStackView.addArrangedSubviews([maleButton, femaleButton, aButton, noneButton])
    }

    private func configureLayout() {
        stepLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.right.equalToSuperview().inset(32)
        }

        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(stepLabel.snp.bottom).offset(24)
            make.left.right.equalTo(stepLabel)
        }

        maleButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        femaleButton.snp.makeConstraints { make in
            make.height.equalTo(maleButton)
        }

        aButton.snp.makeConstraints { make in
            make.height.equalTo(maleButton)
        }

        noneButton.snp.makeConstraints { make in
            make.height.equalTo(maleButton)
        }
    }
}
