//
//  SignUpRouter.swift
//  Account
//
//  Created by Allie Kim on 2022/07/14.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol SignUpInteractable: Interactable, SignUpCompleteListener {
    var router: SignUpRouting? { get set }
    var listener: SignUpListener? { get set }
}

protocol SignUpViewControllable: ViewControllable { }

final class SignUpRouter: ViewableRouter<SignUpInteractable, SignUpViewControllable>, SignUpRouting {

    private var childRouting: ViewableRouting?
    private let signUpComplete: SignUpCompleteBuildable

    init(interactor: SignUpInteractable,
         viewController: SignUpViewControllable,
         signUpComplete: SignUpCompleteBuildable) {
        self.signUpComplete = signUpComplete
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    func attachSignUpComplete() {
        if childRouting != nil { return }

        let router = signUpComplete.build(withListener: self.interactor)
        let viewController = router.viewControllable
        viewController.uiviewController.modalPresentationStyle = .fullScreen
        viewControllable.present(viewController, animated: true, completion: nil)
        self.childRouting = router
        attachChild(router)
    }

    func detachSignUpComplete() {
        guard let router = childRouting else { return }
        detachChild(router)
        viewController.dismiss(animated: true, completion: nil)
        self.childRouting = nil
    }
}
