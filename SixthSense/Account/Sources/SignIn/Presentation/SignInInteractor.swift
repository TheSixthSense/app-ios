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
    func detachSignUp(completion: (() -> Void)?)
}

protocol SignInPresentable: Presentable {
    var listener: SignInPresentableListener? { get set }
    func showAlert(title: String?, message: String)
}

public protocol SignInListener: AnyObject {
    func signInDidTapClose()
}

protocol SignInInteractorDependency {
    var usecase: SignInUseCase { get }
}

final class SignInInteractor: PresentableInteractor<SignInPresentable>, SignInInteractable, SignInPresentableListener {

    weak var router: SignInRouting?
    weak var listener: SignInListener?
    private let dependency: SignInInteractorDependency

    init(presenter: SignInPresentable, dependency: SignInInteractorDependency) {
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

    func returnToSignIn() {
        router?.detachSignUp(completion: nil)
    }

    func signUpComplete() {
        router?.detachSignUp(completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
                self?.listener?.signInDidTapClose()
            })
        })
    }
}
