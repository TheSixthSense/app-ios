//
//  SignUpRouter.swift
//  Account
//
//  Created by Allie Kim on 2022/07/14.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol SignUpInteractable: Interactable {
    var router: SignUpRouting? { get set }
    var listener: SignUpListener? { get set }
}

protocol SignUpViewControllable: ViewControllable { }

final class SignUpRouter: ViewableRouter<SignUpInteractable, SignUpViewControllable>, SignUpRouting {

    override init(interactor: SignUpInteractable, viewController: SignUpViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
