//
//  RootRouter.swift
//  SixthSense
//
//  Created by Allie Kim on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import Account
import Then
import Splash
import Home

protocol RootInteractable: Interactable,
                            SplashListener,
                            SignInListener,
                            HomeListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {

    private let splashBuilder: SplashBuildable
    private let signInBuilder: SignInBuildable
    private let homeBuilder: HomeBuildable

    private var childRouting: ViewableRouting?
    
    init(
        interactor: RootInteractable,
        viewController: RootViewControllable,
        splashBuilder: SplashBuildable,
        signInBuilder: SignInBuildable,
        homeBuilder: HomeBuildable
    ) {
        self.splashBuilder = splashBuilder
        self.signInBuilder = signInBuilder
        self.homeBuilder = homeBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()

        attachSplash()
    }

    
    func attachSplash() {
        if childRouting != nil { return }
        
        let router = splashBuilder.build(withListener: interactor)
        let viewController = router.viewControllable
        viewController.uiviewController.modalPresentationStyle = .fullScreen
        
        viewControllable.present(viewController, animated: false)
        attachChild(router)
        self.childRouting = router
    }
    
    func detachSplash() {
        guard let router = childRouting else { return }
        router.viewControllable.dismiss(animated: false)
        detachChild(router)
        self.childRouting = nil
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
    
    func attachHome() {
        if childRouting != nil { return }
        
        let router = homeBuilder.build(withListener: interactor)
        let viewController = router.viewControllable
        viewController.uiviewController.modalPresentationStyle = .fullScreen
        viewControllable.present(viewController, animated: false)
        attachChild(router)
        self.childRouting = router
    }
}
