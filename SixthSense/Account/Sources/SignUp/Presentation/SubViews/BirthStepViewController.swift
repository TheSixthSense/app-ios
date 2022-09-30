//
//  BirthStepViewController.swift
//  Account
//
//  Created by Allie Kim on 2022/07/15.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import Then
import DesignSystem
import RxSwift
import SnapKit
import RxGesture

public final class BirthStepViewController: UIViewController {

    // MARK: - UI

    private let stepLabel = AppLabel().then {
        $0.setText("비거너!\n너의 생일을 알려줘", font: AppFont.title2)
    }

    public let messageLabel = AppLabel().then {
        $0.setText("👀 이건 선택사항이야", font: AppFont.body2)
        $0.textColor = .systemGray500
    }

    private let birthStackView = UIStackView().then {
        $0.spacing = 8
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    public let yearTextField = AppTextField().then {
        $0.placeholderString = "1990"
        $0.maxLength = 4
        $0.keyboardType = .decimalPad
        $0.errorString = "날짜가 맞는지 다시 확인해줄래?"
    }

    private let yearLabel = AppLabel().then {
        $0.setText("년", font: AppFont.body1)
    }

    public let monthTextField = AppTextField().then {
        $0.placeholderString = "01"
        $0.maxLength = 2
        $0.keyboardType = .decimalPad
    }

    private let monthLabel = AppLabel().then {
        $0.setText("월", font: AppFont.body1)
    }

    public let dayTextField = AppTextField().then {
        $0.placeholderString = "01"
        $0.maxLength = 2
        $0.keyboardType = .decimalPad
    }

    private let dayLabel = AppLabel().then {
        $0.setText("일", font: AppFont.body1)
    }

    // MARK: - Vars
    public let birthTextFields: [AppTextField]

    // MARK: - LifeCycle

    public init() {
        birthTextFields = [yearTextField, monthTextField, dayTextField]
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureLayout()
    }
}

private extension BirthStepViewController {

    private func configureUI() {
        view.addSubviews([stepLabel, messageLabel, birthStackView])
        birthStackView.addArrangedSubviews([yearTextField,
                                            yearLabel,
                                            monthTextField,
                                            monthLabel,
                                            dayTextField,
                                            dayLabel])
    }

    private func configureLayout() {
        stepLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.right.equalToSuperview().inset(32)
        }

        messageLabel.snp.makeConstraints {
            $0.top.equalTo(stepLabel.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(32)
        }

        birthStackView.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(24)
            $0.left.right.equalTo(stepLabel)
            $0.height.equalTo(44)
        }

        yearTextField.snp.makeConstraints { $0.width.equalTo(100) }

        monthTextField.snp.makeConstraints { $0.width.equalTo(60) }

        dayTextField.snp.makeConstraints { $0.width.equalTo(60) }
    }
}
