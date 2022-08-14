//
//  ChallengeRegisterRouter.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol ChallengeRegisterInteractable: Interactable {
    var router: ChallengeRegisterRouting? { get set }
    var listener: ChallengeRegisterListener? { get set }
}

protocol ChallengeRegisterViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ChallengeRegisterRouter: ViewableRouter<ChallengeRegisterInteractable, ChallengeRegisterViewControllable>, ChallengeRegisterRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ChallengeRegisterInteractable, viewController: ChallengeRegisterViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
