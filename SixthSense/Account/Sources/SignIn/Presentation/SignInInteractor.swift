//
//  SignInInteractor.swift
//  Account
//
//  Created by 문효재 on 2022/07/15.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import AuthenticationServices

public protocol SignInRouting: ViewableRouting {
    func routeToSignUp(payload: SignUpPayload)
}

protocol SignInPresentable: Presentable {
    var listener: SignInPresentableListener? { get set }
    func showAlert(title: String?, message: String)
}

public protocol SignInListener: AnyObject {
    func signInDidTapClose()
}

final class SignInInteractor: PresentableInteractor<SignInPresentable>, SignInInteractable, SignInPresentableListener {
    weak var router: SignInRouting?
    weak var listener: SignInListener?
    private let dependency: SignInDependency

    // in constructor.
    init(presenter: SignInPresentable, dependency: SignInDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func signIn() {
        dependency.usecase
            .continueWithApple()
            .catch { [weak self] error in
                self?.presenter.showAlert(title: nil, message: error.localizedDescription)
                return .empty()
            }
            .subscribe(onNext: { [weak self] in
                switch $0 {
                    case .signIn:
                        // FIXME: 임시로 적용한 로직입니다. 추후 제거
                        print("🦊 signIn")
                        self?.listener?.signInDidTapClose()
                    case .signUp(let info):
                        self?.router?.routeToSignUp(
                            payload: .init(id: info.id,
                                           token: info.token,
                                           email: info.email))
                }
            })
            .disposeOnDeactivate(interactor: self)
    }

    func skip() {
        listener?.signInDidTapClose()
    }
}
