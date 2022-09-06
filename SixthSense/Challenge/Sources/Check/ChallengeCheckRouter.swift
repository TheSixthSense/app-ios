//
//  ChallengeCheckRouter.swift
//  Challenge
//
//  Created by 문효재 on 2022/08/23.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol ChallengeCheckInteractable: Interactable {
    var router: ChallengeCheckRouting? { get set }
    var listener: ChallengeCheckListener? { get set }
}

protocol ChallengeCheckViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ChallengeCheckRouter: ViewableRouter<ChallengeCheckInteractable, ChallengeCheckViewControllable>, ChallengeCheckRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ChallengeCheckInteractable, viewController: ChallengeCheckViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
