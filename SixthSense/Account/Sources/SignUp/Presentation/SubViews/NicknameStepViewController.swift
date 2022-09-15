//
//  NicknameStepViewController.swift
//  Account
//
//  Created by Allie Kim on 2022/07/15.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import DesignSystem
import Then

public final class NicknameStepViewController: UIViewController {

    // MARK: - UI

    private var stepLabel = AppLabel().then { label in
        label.setText("비거너!\n너의 닉네임을 알려줘", font: AppFont.title2)
    }

    public var nicknameTextField = AppTextField().then { textfield in
        textfield.placeholderString = "2~10자 사이로 입력해 주세요"
        textfield.errorString = "국문 또는 영문만 가능해!"
        textfield.maxLength = 10
    }

    // MARK: - Vars

    private let disposeBag = DisposeBag()

    // MARK: - LifeCycle
    public init() {
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

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureLaout()
    }
}

private extension NicknameStepViewController {

    private func configureUI() {
        view.addSubviews([stepLabel, nicknameTextField])
    }
    private func configureLaout() {
        stepLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.right.equalToSuperview().inset(32)
        }

        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(stepLabel.snp.bottom).offset(24)
            make.left.right.equalTo(stepLabel)
            make.height.equalTo(44)
        }
    }

    private func bindUI() {

        view.rx.tapGesture()
            .when(.recognized)
            .bind(onNext: { [weak self] _ in
            self?.view.endEditing(true)
        }).disposed(by: disposeBag)
    }
}
