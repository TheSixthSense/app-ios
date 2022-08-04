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
import Home

protocol SplashInteractable: Interactable, UserInfoListener, HomeListener {
    var router: SplashRouting? { get set }
    var listener: SplashListener? { get set }
}

protocol SplashViewControllable: ViewControllable { }

final class SplashRouter: ViewableRouter<SplashInteractable, SplashViewControllable>, SplashRouting {
    private let userInfoBuilder: UserInfoBuildable
    private let homeBuilder: HomeBuildable
    
    private var childRouting: ViewableRouting?
    
    public init(
        interactor: SplashInteractable,
        viewController: SplashViewControllable,
        userInfoBuilder: UserInfoBuildable,
        homeBuilder: HomeBuildable
    ) {
        self.userInfoBuilder = userInfoBuilder
        self.homeBuilder = homeBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
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
    
    func attachUserInfo() {
        if childRouting != nil { return }
        
        let router = userInfoBuilder.build(withListener: interactor)
        let viewController = router.viewControllable
        viewController.uiviewController.modalPresentationStyle = .fullScreen
        viewControllable.present(viewController, animated: false)
        attachChild(router)
        self.childRouting = router
    }
}
