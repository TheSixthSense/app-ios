//
//  VeganStepViewController.swift
//  Account
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

final class VeganStepViewController: UIViewController {

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
        text: "처음이야, 이제 시작해보려고 해!").then { $0.tag = VeganStage.beginner.rawValue }
    private let juniorButton = ImageButton(
        defaultImage: AppImage.juniorIconDefault.image,
        focusedImage: AppImage.juniorIconFocused.image,
        text: "아직 비건 초심자, 조금씩 실천하는 중이야!").then { $0.tag = VeganStage.junior.rawValue }
    private let seniorButton = ImageButton(
        defaultImage: AppImage.seniorIconDefault.image,
        focusedImage: AppImage.seniorIconFocused.image,
        text: "예전부터 꾸준히 실천하고 있어!").then { $0.tag = VeganStage.senior.rawValue }
    private let retryButton = ImageButton(
        defaultImage: AppImage.retryIconDefault.image,
        focusedImage: AppImage.retryIconFocused.image,
        text: "잠시 쉬었다가 왔어! 다시 도전해보려고 해").then { $0.tag = VeganStage.retry.rawValue }

    // MARK: - Vars

    let imageButtons: [ImageButton]
    let imageButtonState: Observable<ImageButton>
    var userVeganStage: PublishRelay<VeganStage> // 유저가 선택한 버튼

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

        userVeganStage = PublishRelay.init()

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
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureLaout()
    }
}

private extension VeganStepViewController {

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

        imageButtons.reduce(Disposables.create()) { disposable, button in
            let subscription = imageButtonState
                .bind(onNext: {
                if $0 == button {
                    self.userVeganStage.accept(self.findSelectedButton(with: $0.tag))
                }
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
