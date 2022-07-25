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

public protocol SignUpRouting: ViewableRouting { }

protocol SignUpPresenterAction: AnyObject {
    var nicknameDidInput: Observable<String> { get }
    var genderDidInput: Observable<Gender> { get }
    var birthDidInput: Observable<[String]> { get }
    var veganStageDidInput: Observable<VeganStage> { get }
}

protocol SignUpPresenterHandler: AnyObject {
    var visibleNicknameValid: Observable<Bool> { get }
    var genderInputValid: Observable<Int> { get }
    var visibleBirthInputValid: Observable<Bool> { get }
    var veganStageInputValid: Observable<Int> { get }
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

    private var signUpRequestModel: SignUpRequestModel?

    override init(presenter: SignUpPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
        presenter.handler = self
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

        action.nicknameDidInput
            .subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            guard !$0.isEmpty else {
                self.visibleNicknameValidRelay.accept(false)
                return
            }

            let isValid = self.isValidNickname($0)
            self.visibleNicknameValidRelay.accept(isValid)

            // TODO: - Data에 저장

        })
            .disposeOnDeactivate(interactor: self)

        action.genderDidInput
            .subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.genderInputValidRelay.accept($0.rawValue)
            // TODO: - Data에 저장
        })
            .disposeOnDeactivate(interactor: self)

        action.birthDidInput
            .subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let birthText = $0.joined()
            guard birthText.count == 8 else {
                self.visibleBirthInputValidRelay.accept(false)
                return
            }
            self.visibleBirthInputValidRelay.accept(true)
            // TODO: - Data에 저장
        })
            .disposeOnDeactivate(interactor: self)

        action.veganStageDidInput
            .subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.veganStageInputValidRelay.accept($0.rawValue)
            // TODO: - Data에 저장
        })
            .disposeOnDeactivate(interactor: self)

    }

    private func isValidNickname(_ nickname: String) -> Bool {
        let nicknameRegex = "^[ㄱ-ㅎ|가-힣|a-z|A-Z|0-9]+$"
        let nicknameTest = NSPredicate(format: "SELF MATCHES %@",
                                       nicknameRegex)
        return nicknameTest.evaluate(with: nickname)
    }
}

extension SignUpInteractor: SignUpPresenterHandler {
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
}
