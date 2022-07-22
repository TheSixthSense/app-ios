//
//  SignUpLastStepViewController.swift
//  VegannerApp
//
//  Created by Allie Kim on 2022/07/15.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import DesignSystem
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

final class SignUpLastStepViewController: UIViewController {

    // MARK: - UI

    private var stepLabel = AppLabel().then { label in
        label.setText("비건을 실천해 본 적 있어?", font: AppFont.title2)
    }

    private var buttonStackView = UIStackView().then { stack in
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 12
    }

    private let beginnerButton = ImageButton(
        defaultImage: AppImage.beginnerIconDefault.image,
        focusedImage: AppImage.beginnerIconFocused.image,
        text: "처음이야, 이제 시작해보려고 해!").then { $0.tag = 0 }
    private let juniorButton = ImageButton(
        defaultImage: AppImage.juniorIconDefault.image,
        focusedImage: AppImage.juniorIconFocused.image,
        text: "아직 비건 초심자, 조금씩 실천하는 중이야!").then { $0.tag = 1 }
    private let seniorButton = ImageButton(
        defaultImage: AppImage.seniorIconDefault.image,
        focusedImage: AppImage.seniorIconFocused.image,
        text: "예전부터 꾸준히 실천하고 있어!").then { $0.tag = 2 }
    private let retryButton = ImageButton(
        defaultImage: AppImage.retryIconDefault.image,
        focusedImage: AppImage.retryIconFocused.image,
        text: "잠시 쉬었다가 왔어! 다시 도전해보려고 해").then { $0.tag = 3 }

    // MARK: - Vars

    private let imageButtons: [ImageButton]
    private let imageButtonState: Observable<ImageButton>
    private var userVeganStage: VeganStage? { // 유저가 선택한 버튼
        didSet {
            veganStageData = userVeganStage?.rawValue ?? ""
        }
    }

    var veganStageData: String = ""

    private let disposeBag = DisposeBag()

    // MARK: - LifeCycle

    init() {
        imageButtons = [beginnerButton, juniorButton, seniorButton, retryButton]
        imageButtonState = Observable.from(
            imageButtons
                .map { button -> Observable in
                button.rx.tapGesture()
                    .when(.recognized)
                    .map { _ in button }
            }
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
        let state = userVeganStage != nil ? true : false
        NotificationCenter.default.post(name: .bottomButtonState, object: state)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureLaout()
    }
}

private extension SignUpLastStepViewController {

    private func configureUI() {
        view.addSubviews([stepLabel, buttonStackView])
        buttonStackView.addArrangedSubviews([beginnerButton, juniorButton, seniorButton, retryButton])
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

        beginnerButton.snp.makeConstraints { make in
            make.height.equalTo(86)
        }

        juniorButton.snp.makeConstraints { make in
            make.height.equalTo(beginnerButton)
        }

        seniorButton.snp.makeConstraints { make in
            make.height.equalTo(beginnerButton)
        }

        retryButton.snp.makeConstraints { make in
            make.height.equalTo(beginnerButton)
        }
    }

    func bindUI() {
        selectButtonEvent()
    }

    private func selectButtonEvent() {

        imageButtonState
            .bind(onNext: { _ in
            NotificationCenter.default.post(name: .bottomButtonState, object: true)
        })
            .disposed(by: disposeBag)

        imageButtons.reduce(Disposables.create()) { disposable, button in
            let subscription = imageButtonState
                .map { [weak self] in
                if ($0 == button) {
                    self?.userVeganStage = self?.findSelectedButton(with: button.tag)
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

    private func findSelectedButton(with tag: Int) -> VeganStage {
        if tag == 0 {
            return VeganStage.beginner
        } else if tag == 1 {
            return VeganStage.junior
        } else if tag == 2 {
            return VeganStage.senior
        } else {
            return VeganStage.retry
        }
    }
}
