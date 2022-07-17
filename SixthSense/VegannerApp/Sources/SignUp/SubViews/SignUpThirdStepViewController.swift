//
//  SignUpThirdStepViewController.swift
//  VegannerApp
//
//  Created by Allie Kim on 2022/07/15.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import RxSwift
import Then
import DesignSystem

final class SignUpThirdStepViewController: UIViewController {

    private var stepLabel = AppLabel().then { label in
        label.setText("비거너!\n너의 생일을 알려줘", font: AppFont.title2)
    }

    private var birthStackView = UIStackView().then { stackView in
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.distribution = .fill
    }

    private var yearTextField = AppTextField().then { textfield in
        textfield.placeholderString = "1990"
        textfield.maxLength = 4
        textfield.keyboardType = .decimalPad
    }

    private var yearLabel = AppLabel().then { label in
        label.setText("년", font: AppFont.body1)
    }

    private var monthTextField = AppTextField().then { textfield in
        textfield.placeholderString = "01"
        textfield.maxLength = 2
        textfield.keyboardType = .decimalPad
    }

    private var monthLabel = AppLabel().then { label in
        label.setText("월", font: AppFont.body1)
    }

    private var dayTextField = AppTextField().then { textfield in
        textfield.placeholderString = "01"
        textfield.maxLength = 2
        textfield.keyboardType = .decimalPad
    }

    private var dayLabel = AppLabel().then { label in
        label.setText("일", font: AppFont.body1)
    }

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

        // TODO: - 버튼 활성화 observer
        Observable.combineLatest([yearTextField.rx.text, monthTextField.rx.text, dayTextField.rx.text])
            .distinctUntilChanged()
            .bind { [weak self] text in
            print("text~ \(text)")
            NotificationCenter.default.post(name: .bottomButtonState, object: true)
        }.disposed(by: disposeBag)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureLayout()
    }
}
private extension SignUpThirdStepViewController {

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
