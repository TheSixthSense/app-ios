//
//  MyPageModifyRouter.swift
//  Home
//
//  Created by Allie Kim on 2022/09/06.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol MyPageModifyInteractable: Interactable {
    var router: MyPageModifyRouting? { get set }
    var listener: MyPageModifyListener? { get set }
}

protocol MyPageModifyViewControllable: ViewControllable {
}

final class MyPageModifyRouter: ViewableRouter<MyPageModifyInteractable, MyPageModifyViewControllable>, MyPageModifyRouting {

    override init(interactor: MyPageModifyInteractable, viewController: MyPageModifyViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
