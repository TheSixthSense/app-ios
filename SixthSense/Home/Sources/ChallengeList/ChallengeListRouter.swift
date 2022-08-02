//
//  ChallengeListRouter.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol ChallengeListInteractable: Interactable {
    var router: ChallengeListRouting? { get set }
    var listener: ChallengeListListener? { get set }
}

protocol ChallengeListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ChallengeListRouter: ViewableRouter<ChallengeListInteractable, ChallengeListViewControllable>, ChallengeListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ChallengeListInteractable, viewController: ChallengeListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
