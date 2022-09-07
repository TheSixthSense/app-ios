//
//  ChallengeDetailRouter.swift
//  Challenge_Challenge
//
//  Created by 문효재 on 2022/09/07.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol ChallengeDetailInteractable: Interactable {
    var router: ChallengeDetailRouting? { get set }
    var listener: ChallengeDetailListener? { get set }
}

protocol ChallengeDetailViewControllable: ViewControllable { }

final class ChallengeDetailRouter: ViewableRouter<ChallengeDetailInteractable, ChallengeDetailViewControllable>, ChallengeDetailRouting {

    override init(interactor: ChallengeDetailInteractable, viewController: ChallengeDetailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
