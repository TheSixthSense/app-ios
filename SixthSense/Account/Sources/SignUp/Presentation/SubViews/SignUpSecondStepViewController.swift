//
//  SignUpSecondStepViewController.swift
//  VegannerApp
//
//  Created by Allie Kim on 2022/07/15.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import DesignSystem
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

final class SignUpSecondStepViewController: UIViewController {
    
    // MARK: - UI

    private var stepLabel = AppLabel().then { label in
        label.setText("비거너!\n너의 성별을 알려줘", font: AppFont.title2)
    }

    private var buttonStackView = UIStackView().then { stack in
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 12
    }

    private let maleButton = SelectButton(title: "남성").then {
        $0.tag = 0
    }
    private let femaleButton = SelectButton(title: "여성").then {
        $0.tag = 1
    }
    private let etcButton = SelectButton(title: "그 외 성별").then {
        $0.tag = 2
    }
    private let noneButton = SelectButton(title: "선택 안 함").then {
        $0.tag = 3
    }
    
    // MARK: - Vars
    
    private let selectButtons: [SelectButton]
    private let selectButtonState: Observable<SelectButton>
    private var selectedButton: Gender? // 유저가 선택한 버튼

    private let disposeBag = DisposeBag()
    
    // MARK: - LifeCycle

    init() {
        selectButtons = [maleButton, femaleButton, etcButton, noneButton]
        selectButtonState = Observable.from(
            selectButtons
                .map { button in
                button.rx.tap.map { button } }
        ).merge().share()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let state = selectedButton != nil ? true : false
        NotificationCenter.default.post(name: .bottomButtonState, object: state)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureLayout()
    }
}

private extension SignUpSecondStepViewController {

    private func configureUI() {
        view.addSubviews([stepLabel, buttonStackView])
        buttonStackView.addArrangedSubviews(selectButtons)
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

        etcButton.snp.makeConstraints { make in
            make.height.equalTo(maleButton)
        }

        noneButton.snp.makeConstraints { make in
            make.height.equalTo(maleButton)
        }
    }

    private func bindUI() {
        selectButtonEvent()
    }

    private func selectButtonEvent() {

        selectButtonState
            .bind(onNext: { _ in
            NotificationCenter.default.post(name: .bottomButtonState, object: true)
        })
            .disposed(by: disposeBag)

        selectButtons.reduce(Disposables.create()) { disposable, button in
            let subscription = selectButtonState
                .map { [weak self] in
                if ($0 == button) {
                    self?.selectedButton = self?.findSelectedButton(with: button.tag)
                    return true
                }
                return false
            }
                .bind(onNext: { state in
                button.hasFocused = state
            })
            return Disposables.create(disposable, subscription)
        }
            .disposed(by: disposeBag)
    }

    private func findSelectedButton(with tag: Int) -> Gender {
        if tag == 0 {
            return Gender.male
        } else if tag == 1 {
            return Gender.female
        } else if tag == 2 {
            return Gender.etc
        } else {
            return Gender.none
        }
    }
}
