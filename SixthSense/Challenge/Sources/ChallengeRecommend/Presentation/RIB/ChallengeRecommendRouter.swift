//
//  ChallengeRecommendRouter.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/16.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol ChallengeRecommendInteractable: Interactable {
    var router: ChallengeRecommendRouting? { get set }
    var listener: ChallengeRecommendListener? { get set }
}

protocol ChallengeRecommendViewControllable: ViewControllable {
}

final class ChallengeRecommendRouter: ViewableRouter<ChallengeRecommendInteractable, ChallengeRecommendViewControllable>, ChallengeRecommendRouting {

    override init(interactor: ChallengeRecommendInteractable, viewController: ChallengeRecommendViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
