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

enum SignUpStep {
    case one
    case two
    case three
    case four
}

protocol SignUpPresentableListener: AnyObject {
}

final class SignUpViewController: UIViewController, SignUpPresentable, SignUpViewControllable {

    func changeButtonState(_ state: Bool) {
        bottomButton.hasFocused = state
    }

    weak var listener: SignUpPresentableListener?

    private var signUpPageView: SignUpPageViewController

    private lazy var stepIconImageView = UIImageView().then { view in
        view.image = AppImage.signUpIcon1.image
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
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
        view.progress = 0.25
        view.progressTintColor = .main
        view.progressViewStyle = .default
    }

    private lazy var stepProgressLabel = AppLabel().then { label in
        label.setText("25%", font: AppFont.caption)
        label.textColor = .main
    }

    private lazy var bottomButton = AppButton(title: "다음")

    private let disposeBag = DisposeBag()

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

        NotificationCenter.default.rx
            .notification(.bottomButtonState)
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { noti in

            let state = noti.object as? Bool ?? false
            self.bottomButton.hasFocused = state

        }).disposed(by: disposeBag)
    }
}

extension SignUpViewController {

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
        }

        stepIconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
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

        updateBottomButton()

    }

    private func updateBottomButton() {
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
            .skip(1)
            .drive(onNext: { height in
            completion(height)
        }).disposed(by: disposeBag)
    }

    private func stepChanged(_ step: SignUpStep) {
        switch step {
        case .one:
            navigationTitle.text = "step 1"
            stepIconImageView.image = AppImage.signUpIcon1.image
            stepProgressBar.setProgress(0.25, animated: true)
            stepProgressLabel.text = "25%"
        case .two:
            navigationTitle.text = "step 2"
            stepIconImageView.image = AppImage.signUpIcon2.image
            stepProgressBar.setProgress(0.5, animated: true)
            stepProgressLabel.text = "50%"
        case .three:
            navigationTitle.text = "step 3"
            stepIconImageView.image = AppImage.signUpIcon3.image
            stepProgressBar.setProgress(0.75, animated: true)
            stepProgressLabel.text = "75%"
        case .four:
            navigationTitle.text = "step 4"
            stepIconImageView.image = AppImage.signUpIcon4.image
            stepProgressBar.setProgress(1.0, animated: true)
            stepProgressLabel.text = "100%"
        }
    }
}

extension Notification.Name {
    static let bottomButtonState = NSNotification.Name("signUpBottomButtonState")
}
