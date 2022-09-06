//
//  MyPageRouter.swift
//  Home
//
//  Created by Allie Kim on 2022/09/01.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol MyPageInteractable: Interactable, MyPageWebViewListener {
    var router: MyPageRouting? { get set }
    var listener: MyPageListener? { get set }
}

protocol MyPageViewControllable: ViewControllable {
}

final class MyPageRouter: ViewableRouter<MyPageInteractable, MyPageViewControllable>, MyPageRouting {

    var childRouting: ViewableRouting?

    var myPageWebView: MyPageWebViewBuildable

    init(interactor: MyPageInteractable,
         viewController: MyPageViewControllable,
         myPageWebView: MyPageWebViewBuildable
    ) {
        self.myPageWebView = myPageWebView
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    func routeToWebView(urlString: String, titleString: String) {
        if childRouting != nil { return }

        let router = myPageWebView.build(withListener: interactor, urlString: urlString, titleString: titleString)
        viewControllable.pushViewController(router.viewControllable, animated: true)
        self.childRouting = router
        attachChild(router)
    }

    func detachWebView() {
        guard let router = childRouting else { return }
        detachChild(router)
        viewController.popViewController(animated: true)
        self.childRouting = nil

    }
}
