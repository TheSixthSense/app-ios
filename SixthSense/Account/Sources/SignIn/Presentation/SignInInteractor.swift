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
    func routeToSignUp()
}

protocol SignInPresentable: Presentable {
    var listener: SignInPresentableListener? { get set }
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
            .signInWithApple()
            .subscribe(onNext: { [weak self] in
            guard let identityToken = $0.identityToken else { return }
            // FIXME: 테스트를 위한 로그들입니다 추후 제거 예정
            print("🦊\(String(data: identityToken, encoding: .utf8))")
            print("🦊\($0.email)")
            print("🦊\($0.fullName)")

            self?.router?.routeToSignUp()
        })
            .disposeOnDeactivate(interactor: self)
    }

    func skip() {
        listener?.signInDidTapClose()
    }
}
