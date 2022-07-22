//
//  SignUpFirstStepVIewController.swift
//  VegannerApp
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

// TODO: - 닉네임 validation API 추가

final class SignUpFirstStepViewController: UIViewController {

    // MARK: - UI

    private var stepLabel = AppLabel().then { label in
        label.setText("비거너!\n너의 닉네임을 알려줘", font: AppFont.title2)
    }

    private var nicknameTextField = AppTextField().then { textfield in
        textfield.placeholderString = "2~10자 사이로 입력해 주세요"
        // TODO: - 기획: validation 문구 수정
        textfield.errorString = "필수항목을 선택해 주세요.(벨리데이션 문구 필요)"
        textfield.maxLength = 10
    }

    // MARK: - Vars
    var nicknameData: String = ""

    private let disposeBag = DisposeBag()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureLaout()
    }
}

private extension SignUpFirstStepViewController {

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

        nicknameTextField.rx.text.orEmpty
            .changed
            .skip(1)
            .bind { [weak self] text in
            guard let self = self else { return }
            guard !text.isEmpty else {
                // 빈 스트링일때 error text 지우기
                self.nicknameTextField.isValidText = true
                NotificationCenter.default.post(name: .bottomButtonState,
                                                object: false)
                return
            }
            let isValid = self.isValidNickname(text)
            self.nicknameTextField.isValidText = isValid
            NotificationCenter.default.post(name: .bottomButtonState,
                                            object: isValid)
            if isValid {
                self.nicknameData = text
            }
        }.disposed(by: disposeBag)
    }

    private func isValidNickname(_ nickname: String) -> Bool {
        let nicknameRegex = "^[ㄱ-ㅎ|가-힣|a-z|A-Z|0-9]+$"
        let nicknameTest = NSPredicate(format: "SELF MATCHES %@",
                                       nicknameRegex)
        return nicknameTest.evaluate(with: nickname)
    }
}
