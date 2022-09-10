//
//  MyPageModifyInfoRouter.swift
//  Home
//
//  Created by Allie Kim on 2022/09/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol MyPageModifyInfoInteractable: Interactable {
    var router: MyPageModifyInfoRouting? { get set }
    var listener: MyPageModifyInfoListener? { get set }
}

protocol MyPageModifyInfoViewControllable: ViewControllable {
}

final class MyPageModifyInfoRouter: ViewableRouter<MyPageModifyInfoInteractable, MyPageModifyInfoViewControllable>, MyPageModifyInfoRouting {

    override init(interactor: MyPageModifyInfoInteractable, viewController: MyPageModifyInfoViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
