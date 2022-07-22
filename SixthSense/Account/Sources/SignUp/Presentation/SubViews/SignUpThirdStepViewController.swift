//
//  SignUpThirdStepViewController.swift
//  VegannerApp
//
//  Created by Allie Kim on 2022/07/15.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture
import Then
import DesignSystem

final class SignUpThirdStepViewController: UIViewController {

    // MARK: - UI

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

    // MARK: - Vars

    var birthData: String = ""

    private let disposeBag = DisposeBag()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
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

    private func bindUI() {

        Observable<Bool>.combineLatest(
            yearTextField.rx.text.orEmpty,
            monthTextField.rx.text.orEmpty,
            dayTextField.rx.text.orEmpty
        ) { year, month, day in
            (year.count > 3 && !year.isEmpty)
                && (month.count > 1 && !month.isEmpty)
                && (day.count > 1 && !day.isEmpty)
        }
            .distinctUntilChanged()
            .bind { [weak self] isNotEmpty in
            guard let self = self else { return }
            NotificationCenter.default.post(name: .bottomButtonState,
                                            object: isNotEmpty)
            self.birthData = "\(self.yearTextField.text!)\(self.monthTextField.text!)\(self.dayTextField.text!)"
        }.disposed(by: disposeBag)
    }
}
