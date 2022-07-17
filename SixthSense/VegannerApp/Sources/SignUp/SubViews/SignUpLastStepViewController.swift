//
//  SignUpLastStepViewController.swift
//  VegannerApp
//
//  Created by Allie Kim on 2022/07/15.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import DesignSystem
import Then
import SnapKit

final class SignUpLastStepViewController: UIViewController {

    private var stepLabel = AppLabel().then { label in
        label.setText("비건을 실천해 본 적 있어?", font: AppFont.title2)
    }

    private var buttonStackView = UIStackView().then { stack in
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 12
    }

    private lazy var starterButton = SelectButton(title: "🌰\n처음이야, 이제 시작해보려고 해!", type: .doubleLine)
    private lazy var beginnerButton = SelectButton(title: "🌱\n아직 비건 초심자, 조금씩 실천하는 중이야!", type: .doubleLine)
    private lazy var doButton = SelectButton(title: "🌸\n예전부터 꾸준히 실천하고 있어!", type: .doubleLine)
    private lazy var noneButton = SelectButton(title: "🌳\n잠시 쉬었다가 왔어! 다시 도전해보려고 해", type: .doubleLine)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureLaout()
    }
}
private extension SignUpLastStepViewController {

    private func configureUI() {
        view.addSubviews([stepLabel, buttonStackView])
        buttonStackView.addArrangedSubviews([starterButton, beginnerButton, doButton, noneButton])
    }

    private func configureLaout() {
        stepLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.right.equalToSuperview().inset(32)
        }

        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(stepLabel.snp.bottom).offset(24)
            make.left.right.equalTo(stepLabel)
        }

        starterButton.snp.makeConstraints { make in
            make.height.equalTo(66)
        }

        beginnerButton.snp.makeConstraints { make in
            make.height.equalTo(starterButton)
        }

        doButton.snp.makeConstraints { make in
            make.height.equalTo(starterButton)
        }

        noneButton.snp.makeConstraints { make in
            make.height.equalTo(starterButton)
        }
    }
}
