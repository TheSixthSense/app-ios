//
//  UserInfoRouter.swift
//  SixthSense
//
//  Created by Allie Kim on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol UserInfoInteractable: Interactable {
    var router: UserInfoRouting? { get set }
    var listener: UserInfoListener? { get set }
}

protocol UserInfoViewControllable: ViewControllable {
}

final class UserInfoRouter: ViewableRouter<UserInfoInteractable, UserInfoViewControllable>, UserInfoRouting {

    override init(interactor: UserInfoInteractable, viewController: UserInfoViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
