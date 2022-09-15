//
//  SignUpCompleteRouter.swift
//  Account
//
//  Created by Allie Kim on 2022/09/13.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol SignUpCompleteInteractable: Interactable {
    var router: SignUpCompleteRouting? { get set }
    var listener: SignUpCompleteListener? { get set }
}

protocol SignUpCompleteViewControllable: ViewControllable {
}

final class SignUpCompleteRouter: ViewableRouter<SignUpCompleteInteractable, SignUpCompleteViewControllable>, SignUpCompleteRouting {

    override init(interactor: SignUpCompleteInteractable, viewController: SignUpCompleteViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
