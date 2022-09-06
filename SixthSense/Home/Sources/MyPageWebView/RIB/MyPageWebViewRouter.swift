//
//  MyPageWebViewRouter.swift
//  Home
//
//  Created by Allie Kim on 2022/09/06.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol MyPageWebViewInteractable: Interactable {
    var router: MyPageWebViewRouting? { get set }
    var listener: MyPageWebViewListener? { get set }
}

protocol MyPageWebViewViewControllable: ViewControllable {
}

final class MyPageWebViewRouter: ViewableRouter<MyPageWebViewInteractable, MyPageWebViewViewControllable>, MyPageWebViewRouting {

    override init(interactor: MyPageWebViewInteractable, viewController: MyPageWebViewViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
