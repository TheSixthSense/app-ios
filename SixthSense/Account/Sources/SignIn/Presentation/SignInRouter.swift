//
//  SignInRouter.swift
//  Account
//
//  Created by 문효재 on 2022/07/15.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol SignInInteractable: Interactable, SignUpListener {
    var router: SignInRouting? { get set }
    var listener: SignInListener? { get set }
}

protocol SignInViewControllable: ViewControllable {
}

final class SignInRouter: ViewableRouter<SignInInteractable, SignInViewControllable>, SignInRouting {

    private let signUpBuilder: SignUpBuildable

    private var childRouting: ViewableRouting?

    init(interactor: SignInInteractable, viewController: SignInViewControllable, signUpBuilder: SignUpBuildable) {
        self.signUpBuilder = signUpBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    func routeToSignUp() {
        if childRouting != nil { return }

        let router = signUpBuilder.build(withListener: self.interactor)
        let viewController = router.viewControllable
        viewController.uiviewController.modalPresentationStyle = .fullScreen
        viewControllable.present(viewController, animated: false)
        attachChild(router)
        self.childRouting = router
    }
}
