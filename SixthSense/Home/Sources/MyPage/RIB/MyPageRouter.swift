//
//  MyPageRouter.swift
//  Home
//
//  Created by Allie Kim on 2022/09/01.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol MyPageInteractable: Interactable {
    var router: MyPageRouting? { get set }
    var listener: MyPageListener? { get set }
}

protocol MyPageViewControllable: ViewControllable {
}

final class MyPageRouter: ViewableRouter<MyPageInteractable, MyPageViewControllable>, MyPageRouting {

    override init(interactor: MyPageInteractable, viewController: MyPageViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
