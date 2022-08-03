//
//  ChallengeCalendarRouter.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol ChallengeCalendarInteractable: Interactable {
    var router: ChallengeCalendarRouting? { get set }
    var listener: ChallengeCalendarListener? { get set }
}

protocol ChallengeCalendarViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ChallengeCalendarRouter: ViewableRouter<ChallengeCalendarInteractable, ChallengeCalendarViewControllable>, ChallengeCalendarRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ChallengeCalendarInteractable, viewController: ChallengeCalendarViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
