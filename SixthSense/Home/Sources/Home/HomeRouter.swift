//
//  HomeRouter.swift
//  Home
//
//  Created by 문효재 on 2022/08/01.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import UIKit
import Challenge

protocol HomeInteractable: Interactable,
                           ChallengeListener,
                           FeedListener,
                           ChallengeRegisterListener {
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}

protocol HomeViewControllable: ViewControllable {
    func setViewControllers(_ viewControllers: [ViewControllable])
}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable>, HomeRouting {
    private let challengeHome: ChallengeBuildable
    private var challengeHomeRouting: ViewableRouting?
    
    private let feedHome: FeedBuildable
    private var feedHomeRouting: ViewableRouting?

    private let challengeRegisterHome: ChallengeRegisterBuildable
    private var challengeRegisterRouting: ViewableRouting?

    init(interactor: HomeInteractable,
         viewController: HomeViewControllable,
         challengeHome: ChallengeBuildable,
         feedHome: FeedBuildable,
         challengeRegisterHome: ChallengeRegisterBuildable) {
        
        self.challengeHome = challengeHome
        self.feedHome = feedHome
        self.challengeRegisterHome = challengeRegisterHome
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTabs() {
        let challengeRouting = challengeHome.build(withListener: interactor)
        let feedRouting = feedHome.build(withListener: interactor)
        let challengeRegisterRouting = challengeRegisterHome.build(withListener: interactor)
        
        attachChild(challengeRouting)
        attachChild(feedRouting)
        attachChild(challengeRegisterRouting)
        
        let viewControllers = [
            NavigationControllerable(root: challengeRouting.viewControllable),
            NavigationControllerable(root: feedRouting.viewControllable),
            NavigationControllerable(root: challengeRegisterRouting.viewControllable)
        ]
        
        viewController.setViewControllers(viewControllers)
    }
}
