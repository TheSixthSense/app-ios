//
//  RootRouter.swift
//  SixthSense
//
//  Created by Allie Kim on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol RootInteractable: Interactable, UserInfoListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: NavigateViewControllable {
    func push(viewController: ViewControllable, animation: Bool)
    func pop(viewController: ViewControllable, animation: Bool)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {

    private let userInfoBuilder: UserInfoBuilder

    private var userInfoRouter: ViewableRouting?

    init(
        interactor: RootInteractable,
        viewController: RootViewControllable,
        userInfoBuilder: UserInfoBuilder
    ) {
        self.userInfoBuilder = userInfoBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    override func didLoad() {
        super.didLoad()

        routeToUserInfo()
    }

    private func routeToUserInfo() {
        let userInfoRouter = userInfoBuilder.build(withListener: interactor)
        self.userInfoRouter = userInfoRouter
        attachChild(userInfoRouter)
        viewController.push(viewController: userInfoRouter.viewControllable, animation: true)
    }
}
