//
//  SplashRouter.swift
//  VegannerAppDev
//
//  Created by 문효재 on 2022/07/12.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import UIKit
import Account

protocol SplashInteractable: Interactable, SignUpListener, SignInListener {
    var router: SplashRouting? { get set }
    var listener: SplashListener? { get set }
}

protocol SplashViewControllable: ViewControllable { }

final class SplashRouter: ViewableRouter<SplashInteractable, SplashViewControllable>, SplashRouting {
    private let signUpBuilder: SignUpBuildable
    private let signInBuilder: SignInBuildable
    
    private var childRouting: ViewableRouting?
    
    public init(
        interactor: SplashInteractable,
        viewController: SplashViewControllable,
        signUpBuilder: SignUpBuildable,
        signInBuilder: SignInBuildable
    ) {
        self.signUpBuilder = signUpBuilder
        self.signInBuilder = signInBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachSignUp() {
        if childRouting != nil { return }
        
        let router = signUpBuilder.build(withListener: interactor)
        let viewController = router.viewControllable
        viewController.uiviewController.modalPresentationStyle = .fullScreen
        viewControllable.present(viewController, animated: false)
        attachChild(router)
        self.childRouting = router
    }
    
    func attachSignIn() {
        if childRouting != nil { return }
        
        let router = signInBuilder.build(withListener: interactor)
        let viewController = router.viewControllable
        viewController.uiviewController.modalPresentationStyle = .fullScreen
        viewControllable.present(viewController, animated: false)
        attachChild(router)
        self.childRouting = router
    }
    
    func detachSignIn() {
        guard let router = childRouting else { return }
        router.viewControllable.dismiss(animated: false)
        detachChild(router)
        self.childRouting = nil
    }
}
