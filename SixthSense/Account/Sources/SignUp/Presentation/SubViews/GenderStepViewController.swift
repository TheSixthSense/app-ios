//
//  GenderStepViewController.swift
//  Account
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

public final class GenderStepViewController: UIViewController {

    // MARK: - UI

    private var stepLabel = AppLabel().then { label in
        label.setText("비거너!\n너의 성별을 알려줘", font: AppFont.title2)
    }

    private var buttonStackView = UIStackView().then { stack in
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 12
    }

    let maleButton = SelectButton(title: "남성").then {
        $0.tag = Gender.male.rawValue
    }
    let femaleButton = SelectButton(title: "여성").then {
        $0.tag = Gender.female.rawValue
    }
    let etcButton = SelectButton(title: "그 외 성별").then {
        $0.tag = Gender.etc.rawValue
    }
    let noneButton = SelectButton(title: "선택 안 함").then {
        $0.tag = Gender.none.rawValue
    }

    // MARK: - Vars

    public let selectButtons: [SelectButton]
    let selectButtonState: Observable<SelectButton>
    public var selectedButton: PublishRelay<Gender> // 유저가 선택한 버튼

    private let disposeBag = DisposeBag()

    // MARK: - LifeCycle

    public init() {
        selectButtons = [maleButton, femaleButton, etcButton, noneButton]
        selectButtonState = Observable.from(
            selectButtons
                .map { button in
                button.rx.tap.map { button } }
        ).merge().share()

        selectedButton = PublishRelay.init()

        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureLayout()
    }
}

private extension GenderStepViewController {

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

        selectButtons.reduce(Disposables.create()) { disposable, button in
            let subscription = selectButtonState
                .bind(onNext: {
                if $0 == button {
                    self.selectedButton.accept(self.findSelectedButton(with: $0.tag))
                }
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
