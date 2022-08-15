//
//  ChallengeRegisterRouter.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol ChallengeRegisterInteractable: Interactable, ChallengeRecommendListener {
    var router: ChallengeRegisterRouting? { get set }
    var listener: ChallengeRegisterListener? { get set }
}

protocol ChallengeRegisterViewControllable: ViewControllable {
}

final class ChallengeRegisterRouter: ViewableRouter<ChallengeRegisterInteractable, ChallengeRegisterViewControllable>, ChallengeRegisterRouting {

    private let recommendBuilder: ChallengeRecommendBuildable

    private var childRouting: ViewableRouting?

    init(interactor: ChallengeRegisterInteractable,
         viewController: ChallengeRegisterViewControllable,
         recommendBuilder: ChallengeRecommendBuildable) {
        self.recommendBuilder = recommendBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    func routeToRecommend() {
        if childRouting != nil { return }
        let router = recommendBuilder.build(withListener: self.interactor)
        let viewController = router.viewControllable
        viewController.uiviewController.modalPresentationStyle = .fullScreen
        viewControllable.present(viewController, animated: false, completion: nil)
        self.childRouting = router
        attachChild(router)
    }
}
