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

protocol RootInteractable: Interactable, SplashListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {

    private let splashBuilder: SplashBuildable

    private var splashRouter: SplashRouting?
    
    init(
        interactor: RootInteractable,
        viewController: RootViewControllable,
        splashBuilder: SplashBuildable
    ) {
        self.splashBuilder = splashBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()

        attachSplash()
    }

    
    private func attachSplash() {
        if splashRouter != nil { return }
        
        let router = splashBuilder.build(withListener: interactor)
        let viewController = router.viewControllable
        viewController.uiviewController.modalPresentationStyle = .fullScreen
        
        viewControllable.present(viewController, animated: false)
        attachChild(router)
        self.splashRouter = router

    }
}
