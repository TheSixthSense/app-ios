//
//  SignUpViewController.swift
//  Account
//
//  Created by Allie Kim on 2022/07/14.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import DesignSystem
import RIBs
import RxAppState
import RxSwift
import RxCocoa
import RxKeyboard
import Then
import UIKit
import UICore

protocol SignUpPresentableListener: AnyObject {
    func didTapBackButton()
}

final class SignUpViewController: UIViewController, SignUpPresentable, SignUpViewControllable {

    weak var listener: SignUpPresentableListener?
    weak var action: SignUpPresenterAction?
    weak var handler: SignUpPresenterHandler?

    // MARK: - UI

    var signUpPageView: SignUpPageViewController

    private var stepIconImageView = UIImageView().then { view in
        view.image = AppImage.signUpIcon1.image
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = false
    }

    private let backButton = UIButton().then {
        $0.setImage(AppIcon.back, for: .normal)
    }

    private let navigationTitle = AppLabel().then {
        $0.setText("회원가입", font: AppFont.body1Bold)
    }

    private lazy var stepNavigationBar = UIView().then {
        $0.backgroundColor = .white
        $0.addSubviews([backButton, navigationTitle])
    }

    private lazy var stepProgressBar = UIProgressView().then {
        $0.layer.sublayers![1].cornerRadius = 5
        $0.subviews[1].clipsToBounds = true
        $0.progress = progressPositions[0]
        $0.progressTintColor = .main
        $0.layer.backgroundColor = AppColor.systemGray100.cgColor
    }

    private lazy var stepProgressLabel = AppLabel().then {
        $0.setText("\(Int(progressPositions[0] * 100))%", font: AppFont.caption)
        $0.textColor = .main
    }

    private var bottomButton = AppButton(title: SignUpSteps.nickname.buttonTitle)

    // MARK: - Vars
    private let progressPositions: [Float] = [0.25, 0.5, 0.75, 1]
    private let disposeBag = DisposeBag()
    private var currentStep: SignUpSteps

    // MARK: - LifeCycle

    init() {
        signUpPageView = SignUpPageViewController()
        currentStep = .nickname
        super.init(nibName: nil, bundle: nil)
        action = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

        bindUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

private extension SignUpViewController {

    private func configureUI() {
        navigationController?.navigationBar.isHidden = true

        view.backgroundColor = .white

        view.addSubviews([stepNavigationBar,
                          stepProgressBar,
                          stepProgressLabel,
                          stepIconImageView,
                          signUpPageView.view,
                          bottomButton])

        signUpPageView.didMove(toParent: self)
    }

    private func configureLayout() {

        stepNavigationBar.snp.makeConstraints { make in
            make.left.right.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }

        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(10)
            make.size.equalTo(24)
        }

        navigationTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backButton)
        }

        stepProgressBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(stepNavigationBar.snp.bottom)
            make.height.equalTo(6)
        }

        stepProgressLabel.snp.makeConstraints { make in
            make.top.equalTo(stepProgressBar.snp.bottom).offset(2)
            make.centerX.equalTo(stepProgressBar.subviews[1].snp.right)
        }

        stepIconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.size.equalTo(80)
            make.top.equalTo(stepProgressBar.snp.bottom).offset(40)
        }

        signUpPageView.view.snp.makeConstraints { make in
            make.top.equalTo(stepIconImageView.snp.bottom).offset(24)
            make.left.right.bottom.equalToSuperview()
        }

        bottomButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(view.safeAreaInsets.bottom + 44)
        }
    }

    private func bindUI() {
        bindSubViewHandlers()

        disposeBag.insert {
            rx.viewDidLayoutSubviews
                .take(1)
                .withUnretained(self)
                .bind(onNext: { owner, _ in
                owner.configureLayout()
            })

            signUpPageView.stepDrvier
                .asObservable()
                .withUnretained(self)
                .bind(onNext: { owner, step in
                owner.stepChanged(step)
            })

            backButton.rx.tap
                .withUnretained(self)
                .bind(onNext: { owner, _ in
                owner.signUpPageView.pageTransition(type: .backward)
            })
        }

        updateBottomButtonLayout()
    }

    private func bindSubViewHandlers() {
        guard let handler = handler else { return }
        handleNicknameSubView(with: handler)
        handleGenderSubView(with: handler)
        handleBirthSubView(with: handler)
        handleVeganStageSubView(with: handler)
        handleBottomButton(with: handler)
        handleSignUpComplete(with: handler)
    }

    private func handleNicknameSubView(with handler: SignUpPresenterHandler) {
        disposeBag.insert {
            handler.visibleNicknameValid
                .bind(to: signUpPageView.nickNameInputView.nicknameTextField.rx.isValidText)

            handler.nicknameCheckValid
                .withUnretained(self)
                .filter { owner, errorString in
                guard !errorString.isEmpty else {
                    return true
                }

                if errorString == "400" {
                    owner.signUpPageView.nickNameInputView.nicknameTextField.do {
                        $0.errorString = "앗 이미 사용 중인 비거너의 이름이야ㅠㅠ"
                        $0.isValidText = false
                    }
                } else {
                    owner.showToast(errorString, toastStyle: .error)
                }
                return false
            }
                .subscribe(onNext: { owner, _ in
                owner.signUpPageView.pageTransition(type: .forward)
            })
        }
    }

    private func handleGenderSubView(with handler: SignUpPresenterHandler) {
        handler.genderInputValid
            .withUnretained(self)
            .bind(onNext: { owner, tag in
            let vc = owner.signUpPageView.genderInputView
            vc.selectButtons.forEach {
                if $0.tag == tag {
                    $0.hasFocused = true
                } else {
                    $0.hasFocused = false
                }
            }
        })
            .disposed(by: disposeBag)
    }

    private func handleBirthSubView(with handler: SignUpPresenterHandler) {
        handler.visibleBirthInputValid
            .withUnretained(self)
            .bind(onNext: { owner, isValid in
            owner.signUpPageView.birthInputView.birthTextFields
                .forEach({ $0.isValidText = isValid })
        })
            .disposed(by: disposeBag)
    }

    private func handleVeganStageSubView(with handler: SignUpPresenterHandler) {
        handler.veganStageInputValid
            .withUnretained(self)
            .bind(onNext: { owner, tag in
            let vc = owner.signUpPageView.veganInputView
            vc.imageButtons.forEach {
                if $0.tag == tag {
                    $0.hasFocused = true
                } else {
                    $0.hasFocused = false
                }
            }
        })
            .disposed(by: disposeBag)
    }

    private func handleBottomButton(with handler: SignUpPresenterHandler) {
        disposeBag.insert {

            handler.enableButton
                .bind(to: bottomButton.rx.hasFocused)

            handler.didTapButton
                .withUnretained(self)
                .subscribe(onNext: { owner, isForward in
                if isForward {
                    owner.signUpPageView.pageTransition(type: .forward)
                }
            })
        }
    }

    private func handleSignUpComplete(with handler: SignUpPresenterHandler) {
        handler.signUpCompleteValid
            .withUnretained(self)
            .filter { owner, errorString in
            guard !errorString.isEmpty else {
                return true
            }
            owner.showToast(errorString, toastStyle: .error)
            return false
        }
            .subscribe(onNext: { _ in
        }).disposed(by: disposeBag)
    }
}

private extension SignUpViewController {

    /// rxKeyboard를 사용해서 keyboard height 만큼 view의 constratint을 업데이트 한다.
    private func updateBottomButtonLayout() {
        getKeyboardHeight { [weak self] height in
            guard let self = self else { return }

            let bottomSafeArea = self.view.safeAreaInsets.bottom

            if height > 0 {
                self.bottomButton.snp.remakeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-height + bottomSafeArea)
                    make.height.equalTo(44)
                }
            } else {
                self.bottomButton.snp.remakeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.height.equalTo(bottomSafeArea + 44)
                }
            }
            self.view.layoutIfNeeded()
        }
    }

    private func getKeyboardHeight(completion: @escaping (_ height: CGFloat) -> Void) {
        RxKeyboard.instance
            .visibleHeight
            .distinctUntilChanged()
            .skip(1)
            .drive(onNext: { height in
            completion(height)
        }).disposed(by: disposeBag)
    }

    /// SignUpPageViewController의 화면 전환에 관련된 UI 수행을 한다.
    private func stepChanged(_ step: SignUpSteps) {
        currentStep = step
        bottomButton.titleText = step.buttonTitle
        stepIconImageView.image = step.stepIcon
        updateProgressBar(when: step)
    }

    private func updateProgressBar(when step: SignUpSteps) {
        switch step {
        case .exit:
            listener?.didTapBackButton()
            return
        case .nickname:
            stepProgressLabel.text = "\(Int(progressPositions[0] * 100))%"
            stepProgressBar.progress = progressPositions[0]
            stepProgressLabel.snp.updateConstraints { make in
                make.centerX.equalTo(stepProgressBar.subviews[1].snp.right)
            }
        case .gender:
            stepProgressLabel.text = "\(Int(progressPositions[1] * 100))%"
            stepProgressBar.progress = progressPositions[1]
            stepProgressLabel.snp.updateConstraints { make in
                make.centerX.equalTo(stepProgressBar.subviews[1].snp.right)
            }
        case .birthday:
            stepProgressLabel.text = "\(Int(progressPositions[2] * 100))%"
            stepProgressBar.progress = progressPositions[2]
            stepProgressLabel.snp.updateConstraints { make in
                make.centerX.equalTo(stepProgressBar.subviews[1].snp.right)
            }
        case .veganStage:
            stepProgressLabel.text = "\(Int(progressPositions[3] * 100))%"
            stepProgressBar.progress = progressPositions[3]
            stepProgressLabel.snp.updateConstraints { make in
                make.centerX.equalTo(stepProgressBar.subviews[1].snp.right).inset(26)
            }
        }

        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}

extension SignUpViewController: SignUpPresenterAction {
    var nicknameViewDidAppear: Observable<Void> {
        signUpPageView.nickNameInputView.rx.viewDidAppear.map { _ in () }.asObservable()
    }

    var genderViewDidAppear: Observable<Void> {
        signUpPageView.genderInputView.rx.viewDidAppear.map { _ in () }.asObservable()
    }

    var birthDateViewDidAppear: Observable<Void> {
        signUpPageView.birthInputView.rx.viewDidAppear.map { _ in () }.asObservable()
    }

    var veganStageViewDidAppear: Observable<Void> {
        signUpPageView.veganInputView.rx.viewDidAppear.map { _ in () }.asObservable()
    }

    var doneButtonDidTap: Observable<SignUpSteps> {
        bottomButton.rx.tap
            .throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance)
            .map({ self.currentStep })
            .asObservable()
    }

    var nicknameDidInput: Observable<String> {
        signUpPageView.nickNameInputView.nicknameTextField.rx.text.orEmpty.distinctUntilChanged().asObservable()
    }

    var genderDidInput: Observable<Gender> {
        signUpPageView.genderInputView.selectedButton.asObservable()
    }

    var birthDidInput: Observable<[String]> {
        let birthView = signUpPageView.birthInputView
        let textFields = [birthView.yearTextField.rx.text.orEmpty.distinctUntilChanged(),
                          birthView.monthTextField.rx.text.orEmpty.distinctUntilChanged(),
                          birthView.dayTextField.rx.text.orEmpty.distinctUntilChanged()]
        return Observable.combineLatest(textFields)
    }

    var veganStageDidInput: Observable<VeganStage> {
        signUpPageView.veganInputView.userVeganStage.asObservable()
    }
}
