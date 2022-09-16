//
//  MyPageModifyInfoViewController.swift
//  Home
//
//  Created by Allie Kim on 2022/09/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Account
import RxAppState
import DesignSystem
import RxKeyboard
import UICore

final class MyPageModifyInfoViewController: UIViewController, MyPageModifyInfoPresentable, MyPageModifyInfoViewControllable {

    weak var handler: MyPageModifyInfoPresenterHandler?
    weak var action: MyPageModifyInfoPresenterAction?

    private let modifyType: ModifyType

    private var iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = false
    }

    private var doneButton = AppButton(title: "수정").then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let backButton = UIBarButtonItem().then {
        $0.image = AppIcon.back
        $0.tintColor = .systemGray500
    }

    let nicknameView: NicknameStepViewController = .init()
    let genderView: GenderStepViewController = .init()
    let birthView: BirthStepViewController = .init()
    let veganStageView: VeganStepViewController = .init()

    var currentView: UIViewController?

    private let modifyNicknameRelay: PublishRelay<Void> = .init()
    private let disposeBag = DisposeBag()

    init(type: ModifyType) {
        self.modifyType = type
        super.init(nibName: nil, bundle: nil)
        action = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
}

extension MyPageModifyInfoViewController {

    private func configureUI() {
        view.backgroundColor = .white
        getModifyView()
        configureNavigationBar()

        guard let currentView = currentView else { return }

        view.addSubviews(iconImageView, currentView.view, doneButton)
        iconImageView.image = modifyType.stepIcon
    }

    private func configureLayout() {
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.top.equalToSuperview().offset(48)
            make.size.equalTo(80)
        }

        doneButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(view.safeAreaInsets.bottom + 44)
        }

        guard let currentView = currentView else { return }

        currentView.view.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(24)
            make.left.right.bottom.equalToSuperview()
        }
    }

    private func getModifyView() {
        switch modifyType {
        case .nickname:
            self.currentView = nicknameView
        case .gender:
            self.currentView = genderView
        case .birthday:
            self.currentView = birthView
        case .veganStage:
            self.currentView = veganStageView
        }
    }

    private func configureNavigationBar() {
        navigationItem.titleView = UILabel().then {
            $0.text = "회원 정보 수정"
            $0.font = AppFont.body1Bold
            $0.textColor = AppColor.systemBlack
            $0.numberOfLines = 1
            $0.sizeToFit()
        }

        navigationItem.leftBarButtonItem = backButton
    }

    private func bind() {
        rx.viewDidLayoutSubviews
            .take(1)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
            owner.configureLayout()
        }).disposed(by: disposeBag)

        bindSubViewHandlers()
        updateBottomButtonLayout()
    }

    private func bindSubViewHandlers() {
        guard let handler = handler else { return }
        handleNicknameSubView(with: handler)
        handleGenderSubView(with: handler)
        handleBirthSubView(with: handler)
        handleVeganStageSubView(with: handler)
        handleDoneButton(with: handler)
        handleErrorToast(with: handler)
    }

    private func handleNicknameSubView(with handler: MyPageModifyInfoPresenterHandler) {
        disposeBag.insert {
            handler.nicknameInputValid
                .bind(to: nicknameView.nicknameTextField.rx.isValidText)

            handler.nicknameCheckValid
                .withUnretained(self)
                .filter { owner, errorString in
                guard !errorString.isEmpty else {
                    return true
                }

                if errorString == "400" {
                    owner.nicknameView.nicknameTextField.do {
                        $0.errorString = "앗 이미 사용 중인 비거너의 이름이야ㅠㅠ"
                        $0.isValidText = false
                    }
                } else {
                    owner.showToast(errorString, toastStyle: .error)
                }
                return false
            }.bind(onNext: { owner, _ in
                owner.modifyNicknameRelay.accept(())
            })
        }
    }

    private func handleGenderSubView(with handler: MyPageModifyInfoPresenterHandler) {
        handler.genderInputValid
            .withUnretained(self)
            .bind(onNext: { owner, tag in
            let vc = owner.genderView
            vc.selectButtons.forEach { $0.hasFocused = $0.tag == tag ? true : false }
        })
            .disposed(by: disposeBag)
    }

    private func handleBirthSubView(with handler: MyPageModifyInfoPresenterHandler) {
        handler.birthInputValid
            .withUnretained(self)
            .bind(onNext: { owner, isValid in
            owner.birthView.birthTextFields
                .forEach({ $0.isValidText = isValid })
        })
            .disposed(by: disposeBag)
    }

    private func handleVeganStageSubView(with handler: MyPageModifyInfoPresenterHandler) {
        handler.veganStageInputValid
            .withUnretained(self)
            .bind(onNext: { owner, tag in
            let vc = owner.veganStageView
            vc.imageButtons.forEach { $0.hasFocused = $0.tag == tag ? true : false }
        }).disposed(by: disposeBag)
    }

    private func handleDoneButton(with handler: MyPageModifyInfoPresenterHandler) {
        disposeBag.insert {
            handler.enableButton
                .bind(to: doneButton.rx.hasFocused)
        }
    }

    private func updateBottomButtonLayout() {
        getKeyboardHeight { [weak self] height in
            guard let self = self else { return }

            let bottomSafeArea = self.view.safeAreaInsets.bottom

            if height > 0 {
                self.doneButton.snp.remakeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-height + bottomSafeArea)
                    make.height.equalTo(44)
                }
            } else {
                self.doneButton.snp.remakeConstraints { make in
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

    private func handleErrorToast(with handler: MyPageModifyInfoPresenterHandler) {
        handler.showErrorToast
            .withUnretained(self)
            .bind(onNext: { owner, message in
            owner.showToast(message, toastStyle: .error)
        }).disposed(by: disposeBag)
    }
}

extension MyPageModifyInfoViewController: MyPageModifyInfoPresenterAction {
    var didTapBackButton: Observable<Void> { backButton.rx.tap.throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance) }
    var nicknameDidInput: Observable<String> {
        nicknameView.nicknameTextField.rx.text.orEmpty.distinctUntilChanged().asObservable()
    }
    var genderDidInput: Observable<GenderInfo> { genderView.selectedButton.map { GenderInfo(rawValue: $0.stringValue) ?? .none }.asObservable() }
    var birthDidInput: Observable<[String]> {
        let textFields = [birthView.yearTextField.rx.text.orEmpty.distinctUntilChanged(),
                          birthView.monthTextField.rx.text.orEmpty.distinctUntilChanged(),
                          birthView.dayTextField.rx.text.orEmpty.distinctUntilChanged()]
        return Observable.combineLatest(textFields)
    }
    var veganStageDidInput: Observable<VeganStageInfo> { veganStageView.userVeganStage.map { VeganStageInfo(rawValue: $0.stringValue) ?? .beginner }.asObservable() }
    var didTapDoneButton: Observable<ModifyType> {
        doneButton.rx.tap.throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance)
            .map { [weak self] _ in self?.modifyType ?? .nickname }
    }
    var modifyNickname: Observable<Void> { modifyNicknameRelay.asObservable() }
}
