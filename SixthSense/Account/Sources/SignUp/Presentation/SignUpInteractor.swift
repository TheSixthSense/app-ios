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

public protocol SignUpRouting: ViewableRouting {
    func attachSignUpComplete()
    func detachSignUpComplete()
}

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
    var nicknameCheckValid: Observable<String> { get }
    var signUpCompleteValid: Observable<String> { get }
}

protocol SignUpPresentable: Presentable {
    var handler: SignUpPresenterHandler? { get set }
    var action: SignUpPresenterAction? { get set }
    var listener: SignUpPresentableListener? { get set }
}

public protocol SignUpListener: AnyObject {
    func returnToSignIn()
    func signUpComplete()
}

final class SignUpInteractor: PresentableInteractor<SignUpPresentable>, SignUpInteractable, SignUpPresentableListener {

    weak var router: SignUpRouting?
    weak var listener: SignUpListener?

    private let visibleNicknameValidRelay: BehaviorRelay<Bool> = .init(value: true)
    private let genderInputValidRelay: PublishRelay<Int> = .init()
    private let visibleBirthInputValidRelay: BehaviorRelay<Bool> = .init(value: true)
    private let veganStageInputValidRelay: PublishRelay<Int> = .init()

    private let enableButtonRelay: PublishRelay<Bool> = .init()
    private let textDoneButtonRelay: PublishRelay<SignUpButtonType> = .init()
    private let buttonDidTapRelay: PublishRelay<Bool> = .init()
    private let nicknameButtonRelay: PublishRelay<Bool> = .init()

    private let nicknameCheckValidRelay: PublishRelay<String> = .init()
    private let signUpCompleteValidRelay: PublishRelay<String> = .init()

    private var requests: SignUpRequest = .init()
    private let payload: SignUpPayload
    private let dependency: SignUpComponent

    init(presenter: SignUpPresentable,
         dependency: SignUpComponent,
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

    func didTapBackButton() {
        listener?.returnToSignIn()
    }

    func routeToHome() {
        router?.detachSignUpComplete()
        listener?.signUpComplete()
    }

    private func doSignUp() {
        dependency.useCase
            .fetchSignUp(reqeust: self.requests)
            .catchAndReturn("오류가 발생했어요ㅠㅠ 다시 눌러주세요!")
            .filter({ [weak self] errorMessage in
            if errorMessage.isEmpty {
                self?.router?.attachSignUpComplete()
                return false
            }
            return true
        })
            .bind(to: signUpCompleteValidRelay)
            .disposeOnDeactivate(interactor: self)
    }

    private func isUseableNickname(_ nickname: String) {
        dependency.useCase
            .validateUserNickname(request: nickname)
            .catch { error in
            guard let apiError = error as? APIError,
                let statusCode = apiError.errorStatusCode else {
                return .just(error.localizedDescription)
            }
            return .just(statusCode)
        }
            .bind(to: nicknameCheckValidRelay)
            .disposeOnDeactivate(interactor: self)
    }

    func bindSubViewActions() {
        guard let action = presenter.action else { return }
        bindBottomButton(action: action)
        bindNickname(action: action)
        bindGender(action: action)
        bindBirth(action: action)
        bindVeganStage(action: action)
    }
}

private extension SignUpInteractor {

    private func fetchDoneButtonText(buttonType: SignUpButtonType) {
        self.textDoneButtonRelay.accept(buttonType)
    }

    private func fetchEnableButton(_ enable: Bool) {
        self.enableButtonRelay.accept(enable)
    }

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
            .do(onNext: { [weak self] in
            if $0 == .nickname {
                self?.isUseableNickname(self?.requests.nickname ?? "")
                self?.buttonDidTapRelay.accept(false)
            }

            if $0 == .veganStage {
                self?.doSignUp()
                self?.buttonDidTapRelay.accept(false)
            }
        })
            .filter { ![.nickname, .veganStage].contains($0) }
            .subscribe(onNext: { [weak self] step in
            self?.buttonDidTapRelay.accept(true)
        })
            .disposeOnDeactivate(interactor: self)
    }

    private func bindNickname(action: SignUpPresenterAction) {

        action.nicknameDidInput
            .do(onNext: { [weak self] in

            guard !$0.isEmpty else {
                self?.fetchEnableButton(false)
                self?.visibleNicknameValidRelay.accept(true) // 에러메세지 지우기
                return
            }

            guard self?.isValidNickname($0) == true else {
                self?.fetchEnableButton(false)
                self?.visibleNicknameValidRelay.accept(false)
                return
            }
        })
            .filter { [weak self] in !$0.isEmpty && (self?.isValidNickname($0) == true) }
            .subscribe(onNext: { [weak self] in
            guard let self = self else { return }

            self.visibleNicknameValidRelay.accept(true)
            self.requests.nickname = $0
            self.fetchEnableButton(true)
        })
            .disposeOnDeactivate(interactor: self)
    }

    private func bindBirth(action: SignUpPresenterAction) {

        action.birthDidInput
            .subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let birthText = $0.joined()
            guard !birthText.isEmpty else {
                self.fetchEnableButton(false)
                self.visibleBirthInputValidRelay.accept(true) // 에러메세지 지우기
                return
            }

            guard birthText.count == 8 && self.isValidBirth(birthText) else {
                self.visibleBirthInputValidRelay.accept(false)
                self.fetchEnableButton(false)
                return
            }
            self.visibleBirthInputValidRelay.accept(true)
            self.requests.birthDay = birthText
            self.fetchEnableButton(true)
        })
            .disposeOnDeactivate(interactor: self)
    }

    private func bindGender(action: SignUpPresenterAction) {

        action.genderDidInput
            .subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.requests.gender = $0.stringValue
            self.fetchEnableButton(true)
            self.genderInputValidRelay.accept($0.rawValue)
        })
            .disposeOnDeactivate(interactor: self)
    }

    private func bindVeganStage(action: SignUpPresenterAction) {
        action.veganStageDidInput
            .subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.veganStageInputValidRelay.accept($0.rawValue)
            self.requests.vegannerStage = $0.stringValue
            self.fetchEnableButton(true)
        })
            .disposeOnDeactivate(interactor: self)
    }

    private func isValidNickname(_ nickname: String) -> Bool {
        let nicknameRegex = "^[ㄱ-ㅎ|가-힣|a-z|A-Z|0-9]+$"
        let nicknameTest = NSPredicate(format: "SELF MATCHES %@",
                                       nicknameRegex)
        return nicknameTest.evaluate(with: nickname)
    }

    private func isValidBirth(_ birth: String) -> Bool {
        let birthRegex = "^(19[0-9][0-9]|20\\d{2})(0[0-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1])$"
        let birthTest = NSPredicate(format: "SELF MATCHES %@", birthRegex)
        return birthTest.evaluate(with: birth)
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

    var nicknameCheckValid: Observable<String> {
        return nicknameCheckValidRelay.asObservable()
    }

    var signUpCompleteValid: Observable<String> {
        return signUpCompleteValidRelay.asObservable()
    }
}

extension SignUpRequest: Then { }
