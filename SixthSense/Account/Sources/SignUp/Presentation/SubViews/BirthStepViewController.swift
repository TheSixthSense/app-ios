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

public final class BirthStepViewController: UIViewController {

    // MARK: - UI

    private var stepLabel = AppLabel().then { label in
        label.setText("비거너!\n너의 생일을 알려줘", font: AppFont.title2)
    }

    private var birthStackView = UIStackView().then { stackView in
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.distribution = .fill
    }

    var yearTextField = AppTextField().then { textfield in
        textfield.placeholderString = "1990"
        textfield.maxLength = 4
        textfield.keyboardType = .decimalPad
        textfield.errorString = "날짜가 맞는지 다시 확인해줄래?"
    }

    private var yearLabel = AppLabel().then { label in
        label.setText("년", font: AppFont.body1)
    }

    var monthTextField = AppTextField().then { textfield in
        textfield.placeholderString = "01"
        textfield.maxLength = 2
        textfield.keyboardType = .decimalPad
    }

    private var monthLabel = AppLabel().then { label in
        label.setText("월", font: AppFont.body1)
    }

    var dayTextField = AppTextField().then { textfield in
        textfield.placeholderString = "01"
        textfield.maxLength = 2
        textfield.keyboardType = .decimalPad
    }

    private var dayLabel = AppLabel().then { label in
        label.setText("일", font: AppFont.body1)
    }

    // MARK: - Vars
    let birthTextFields: [AppTextField]

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
        view.addSubviews([stepLabel, birthStackView])
        birthStackView.addArrangedSubviews([yearTextField,
                                            yearLabel,
                                            monthTextField,
                                            monthLabel,
                                            dayTextField,
                                            dayLabel])
    }

    private func configureLayout() {
        stepLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.right.equalToSuperview().inset(32)
        }

        birthStackView.snp.makeConstraints { make in
            make.top.equalTo(stepLabel.snp.bottom).offset(24)
            make.left.right.equalTo(stepLabel)
            make.height.equalTo(44)
        }

        yearTextField.snp.makeConstraints { make in
            make.width.equalTo(100)
        }

        monthTextField.snp.makeConstraints { make in
            make.width.equalTo(60)
        }

        dayTextField.snp.makeConstraints { make in
            make.width.equalTo(60)
        }
    }
}
