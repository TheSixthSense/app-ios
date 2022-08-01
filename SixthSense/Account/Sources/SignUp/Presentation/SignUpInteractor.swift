//
//  SignUpInteractor.swift
//  Account
//
//  Created by Allie Kim on 2022/07/14.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import Foundation
import RxSwift
import RxRelay
import Then
import Repository

enum SignUpButtonType: String {
    case next = "다음"
    case done = "확인"
}

public protocol SignUpRouting: ViewableRouting { }

protocol SignUpPresenterAction: AnyObject {

    var nicknameDidInput: Observable<String> { get }
    var genderDidInput: Observable<Gender> { get }
    var birthDidInput: Observable<[String]> { get }
    var veganStageDidInput: Observable<VeganStage> { get }

    var nicknameViewDidAppear: Observable<Void> { get }
    var genderViewDidAppear: Observable<Void> { get }
    var birthDateViewDidAppear: Observable<Void> { get }
    var veganStageViewDidAppear: Observable<Void> { get }

    var doneButtonDidTap: Observable<SignUpSteps> { get }
}

protocol SignUpPresenterHandler: AnyObject {
    var textDoneButton: Observable<SignUpButtonType> { get }
    var enableButton: Observable<Bool> { get }
    var didTapButton: Observable<Bool> { get }
    var visibleNicknameValid: Observable<Bool> { get }
    var genderInputValid: Observable<Int> { get }
    var visibleBirthInputValid: Observable<Bool> { get }
    var veganStageInputValid: Observable<Int> { get }
    var nicknameCheckValid: Observable<Bool> { get }
}

protocol SignUpPresentable: Presentable {
    var handler: SignUpPresenterHandler? { get set }
    var action: SignUpPresenterAction? { get set }
    var listener: SignUpListener? { get set }
}

public protocol SignUpListener: AnyObject { }

final class SignUpInteractor: PresentableInteractor<SignUpPresentable>, SignUpInteractable, SignUpListener {

    weak var router: SignUpRouting?
    weak var listener: SignUpListener?

    private let visibleNicknameValidRelay: BehaviorRelay<Bool> = .init(value: false)
    private let genderInputValidRelay: PublishRelay<Int> = .init()
    private let visibleBirthInputValidRelay: BehaviorRelay<Bool> = .init(value: false)
    private let veganStageInputValidRelay: PublishRelay<Int> = .init()

    private let enableButtonRelay: PublishRelay<Bool> = .init()
    private let textDoneButtonRelay: PublishRelay<SignUpButtonType> = .init()
    private let buttonDidTapRelay: PublishRelay<Bool> = .init()
    private let nicknameButtonRelay: PublishRelay<Bool> = .init()

    private let nicknameCheckValidRelay: BehaviorRelay<Bool> = .init(value: false)

    private var requests: SignUpRequest = .init()
    private let payload: SignUpPayload
    private let dependency: SignUpDependency

    init(presenter: SignUpPresentable,
         dependency: SignUpDependency,
         payload: SignUpPayload) {
        self.dependency = dependency
        self.payload = payload
        super.init(presenter: presenter)
        presenter.listener = self
        presenter.handler = self
        configureRequestModel()
    }

    private func configureRequestModel() {
        self.requests = requests.with {
            $0.appleId = payload.id
            $0.clientSecret = payload.token
        }
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        bindSubViewActions()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func bindSubViewActions() {
        guard let action = presenter.action else { return }
        bindBottomButton(action: action)
        bindNickname(action: action)

        action.genderDidInput
            .subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.requests.gender = $0.stringValue
            self.fetchEnableButton(true)
            self.genderInputValidRelay.accept($0.rawValue)
        })
            .disposeOnDeactivate(interactor: self)

        action.birthDidInput
            .subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let birthText = $0.joined()
            guard birthText.count == 8 else {
                self.visibleBirthInputValidRelay.accept(false)
                self.fetchEnableButton(false)
                return
            }
            self.requests.birthDay = birthText
            self.visibleBirthInputValidRelay.accept(true)
            self.fetchEnableButton(true)
        })
            .disposeOnDeactivate(interactor: self)

        action.veganStageDidInput
            .subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.veganStageInputValidRelay.accept($0.rawValue)
            self.requests.vegannerStage = $0.stringValue
            self.fetchEnableButton(true)
        })
            .disposeOnDeactivate(interactor: self)
    }

    private func fetchDoneButtonText(buttonType: SignUpButtonType) {
        self.textDoneButtonRelay.accept(buttonType)
    }

    private func fetchEnableButton(_ enable: Bool) {
        self.enableButtonRelay.accept(enable)
    }

    private func isValidNickname(_ nickname: String) -> Bool {
        let nicknameRegex = "^[ㄱ-ㅎ|가-힣|a-z|A-Z|0-9]+$"
        let nicknameTest = NSPredicate(format: "SELF MATCHES %@",
                                       nicknameRegex)
        return nicknameTest.evaluate(with: nickname)
    }

    private func isUseableNickname(_ nickname: String) {
        dependency.useCase.validateUserNickname(request: nickname)
            .subscribe(onNext: { [weak self] _ in
            // TODO: - 공통 데이터 모델로 변환 후 success/failure 처리
            self?.nicknameCheckValidRelay.accept(true)
        }).disposeOnDeactivate(interactor: self)
    }

    private func signUp() {
        dependency.useCase.fetchSignUp(reqeust: self.requests)
            .subscribe(onNext: { [weak self] _ in
            // TODO: - 공통 데이터 모델로 변환 후 success/failure 처리
        }).disposeOnDeactivate(interactor: self)
    }
}
extension SignUpInteractor {

    private func bindBottomButton(action: SignUpPresenterAction) {

        Observable.merge([
            action.nicknameViewDidAppear,
            action.genderViewDidAppear,
            action.birthDateViewDidAppear
        ]).subscribe(onNext: { [weak self] in
            self?.fetchDoneButtonText(buttonType: .next)
            self?.fetchEnableButton(false)
        })
            .disposeOnDeactivate(interactor: self)

        action.veganStageViewDidAppear
            .subscribe(onNext: { [weak self] in
            self?.fetchDoneButtonText(buttonType: .done)
            self?.fetchEnableButton(false)
        })
            .disposeOnDeactivate(interactor: self)

        action.doneButtonDidTap
            .subscribe(onNext: { [weak self] step in
            if step == .nickname {
                self?.isUseableNickname(self?.requests.nickname ?? "")
                self?.buttonDidTapRelay.accept(false)
                return
            }

            if step == .veganStage {
                self?.signUp()
                self?.buttonDidTapRelay.accept(false)
                return
            }

            self?.buttonDidTapRelay.accept(true)
        })
            .disposeOnDeactivate(interactor: self)
    }


    private func bindNickname(action: SignUpPresenterAction) {

        action.nicknameDidInput
            .subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            guard !$0.isEmpty else {
                self.fetchEnableButton(false)
                self.visibleNicknameValidRelay.accept(false)
                return
            }

            let isValid = self.isValidNickname($0)
            self.visibleNicknameValidRelay.accept(isValid)
            self.requests.nickname = $0
            self.fetchEnableButton(true)
        })
            .disposeOnDeactivate(interactor: self)
    }
}


extension SignUpInteractor: SignUpPresenterHandler {

    var textDoneButton: Observable<SignUpButtonType> {
        return textDoneButtonRelay.asObservable()
    }

    var enableButton: Observable<Bool> {
        return enableButtonRelay.asObservable()
    }

    var didTapButton: Observable<Bool> {
        return buttonDidTapRelay.asObservable()
    }

    var visibleNicknameValid: Observable<Bool> {
        return visibleNicknameValidRelay.asObservable()
    }

    var genderInputValid: Observable<Int> {
        return genderInputValidRelay.asObservable()
    }

    var visibleBirthInputValid: Observable<Bool> {
        return visibleBirthInputValidRelay.asObservable()
    }

    var veganStageInputValid: Observable<Int> {
        return veganStageInputValidRelay.asObservable()
    }

    var nicknameCheckValid: Observable<Bool> {
        return nicknameCheckValidRelay.asObservable()
    }
}

extension SignUpRequest: Then { }
