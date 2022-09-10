//
//  MyPageModifyRouter.swift
//  Home
//
//  Created by Allie Kim on 2022/09/06.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol MyPageModifyInteractable: Interactable, MyPageModifyInfoListener {
    var router: MyPageModifyRouting? { get set }
    var listener: MyPageModifyListener? { get set }
}

protocol MyPageModifyViewControllable: ViewControllable {
}

final class MyPageModifyRouter: ViewableRouter<MyPageModifyInteractable, MyPageModifyViewControllable>, MyPageModifyRouting {

    private var childRouting: ViewableRouting?

    private let modifyInfoBuilder: MyPageModifyInfoBuildable

    init(interactor: MyPageModifyInteractable,
         viewController: MyPageModifyViewControllable,
         modifyInfoBuilder: MyPageModifyInfoBuildable) {
        self.modifyInfoBuilder = modifyInfoBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    func routeToModifyInfo(type: ModifyType) {
        if childRouting != nil { return }

        let router = modifyInfoBuilder.build(withListener: interactor, type: type)
        viewControllable.pushViewController(router.viewControllable, animated: true)
        self.childRouting = router
        attachChild(router)
    }

    func detachModifyInfoView() {
        guard let router = childRouting else { return }
        detachChild(router)
        viewController.popViewController(animated: true)
        self.childRouting = nil
    }
}
