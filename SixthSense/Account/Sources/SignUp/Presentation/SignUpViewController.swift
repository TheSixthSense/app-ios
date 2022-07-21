//
//  SignUpViewController.swift
//  VegannerApp
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

protocol SignUpPresentableListener: AnyObject { }

final class SignUpViewController: UIViewController, SignUpPresentable, SignUpViewControllable {

    // MARK: - UI

    private var signUpPageView: SignUpPageViewController

    private lazy var stepIconImageView = UIImageView().then { view in
        view.image = AppImage.signUpIcon1.image
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = false
    }

    private lazy var backButton = UIButton().then { button in
        button.setImage(AppIcon.back, for: .normal)
    }

    private lazy var navigationTitle = AppLabel().then { label in
        label.setText("step 1", font: AppFont.body1)
    }

    private lazy var stepNavigationBar = UIView().then { view in
        view.backgroundColor = .white
        view.addSubviews([backButton, navigationTitle])
    }

    private lazy var stepProgressBar = UIProgressView().then { view in
        view.layer.sublayers![1].cornerRadius = 5
        view.subviews[1].clipsToBounds = true
        view.progress = progressPositions[0]
        view.progressTintColor = .main
        view.layer.backgroundColor = AppColor.systemGray100.cgColor
    }

    private lazy var stepProgressLabel = AppLabel().then { label in
        label.setText("\(Int(progressPositions[0] * 100))%", font: AppFont.caption)
        label.textColor = .main
    }

    private lazy var bottomButton = AppButton(title: "다음").then { button in
        button.hasFocused = false
    }

    // MARK: - Vars

    weak var listener: SignUpPresentableListener?

    private let progressPositions: [Float] = [0.25, 0.5, 0.75, 1]
    private let disposeBag = DisposeBag()

    private var signUpRequestModel: SignUpRequestModel?

    // MARK: - LifeCycle

    init() {
        signUpPageView = SignUpPageViewController()
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

        rx.viewDidLayoutSubviews
            .take(1)
            .bind(onNext: {
            self.configureLayout()
        }).disposed(by: disposeBag)

        signUpPageView.stepDrvier
            .drive(
            onNext: { [weak self] step in
                self?.stepChanged(step)
            }).disposed(by: disposeBag)

        bottomButton.rx.tap
            .bind(onNext: { [weak self] in
            guard self?.signUpPageView.goToNextPage() == true else {
                // 확인 버튼
                // TODO: - request API

                return
            }
        }).disposed(by: disposeBag)

        backButton.rx
            .tap
            .bind(onNext: { [weak self] in
            self?.signUpPageView.goToPreviousPage()
        }).disposed(by: disposeBag)

        NotificationCenter.default.rx
            .notification(.bottomButtonState)
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { noti in
                
            let state = noti.object as? Bool ?? false
            self.bottomButton.hasFocused = state
                
        }).disposed(by: disposeBag)

        updateBottomButtonLayout()
    }

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
    private func stepChanged(_ step: SignUpStep) {
        updateProgressBar(when: step)
        updateLabels(when: step)
        updateIcon(when: step)
    }

    private func updateProgressBar(when step: SignUpStep) {
        switch step {
        case .exit:
            // TODO: SignIn RIB 연결
            return
        case .one:
            stepProgressLabel.text = "\(Int(progressPositions[0] * 100))%"
            stepProgressBar.progress = progressPositions[0]
            stepProgressLabel.snp.updateConstraints { make in
                make.centerX.equalTo(stepProgressBar.subviews[1].snp.right)
            }
        case .two:
            stepProgressLabel.text = "\(Int(progressPositions[1] * 100))%"
            stepProgressBar.progress = progressPositions[1]
            stepProgressLabel.snp.updateConstraints { make in
                make.centerX.equalTo(stepProgressBar.subviews[1].snp.right)
            }
        case .three:
            stepProgressLabel.text = "\(Int(progressPositions[2] * 100))%"
            stepProgressBar.progress = progressPositions[2]
            stepProgressLabel.snp.updateConstraints { make in
                make.centerX.equalTo(stepProgressBar.subviews[1].snp.right)
            }
        case .four:
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

    private func updateLabels(when step: SignUpStep) {
        switch step {
        case .exit:
            return
        case .one:
            bottomButton.titleText = "다음"
            navigationTitle.text = "step 1"
            return
        case .two:
            bottomButton.titleText = "다음"
            navigationTitle.text = "step 2"
            return
        case .three:
            bottomButton.titleText = "다음"
            navigationTitle.text = "step 3"
            return
        case .four:
            bottomButton.titleText = "완료"
            navigationTitle.text = "step 4"
            return
        }
    }

    private func updateIcon(when step: SignUpStep) {
        switch step {
        case .exit:
            return
        case .one:
            stepIconImageView.image = AppImage.signUpIcon1.image
            return
        case .two:
            stepIconImageView.image = AppImage.signUpIcon2.image
            return
        case .three:
            stepIconImageView.image = AppImage.signUpIcon3.image
            return
        case .four:
            stepIconImageView.image = AppImage.signUpIcon4.image
            return
        }
    }
}
