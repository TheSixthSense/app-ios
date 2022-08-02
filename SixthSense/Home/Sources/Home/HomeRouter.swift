//
//  HomeRouter.swift
//  Home
//
//  Created by 문효재 on 2022/08/01.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import UIKit

protocol HomeInteractable: Interactable,
                           ChallengeListener,
                           FeedListener {
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

    init(interactor: HomeInteractable,
         viewController: HomeViewControllable,
         challengeHome: ChallengeBuildable,
         feedHome: FeedBuildable) {
        
        self.challengeHome = challengeHome
        self.feedHome = feedHome
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTabs() {
        let challengeRouting = challengeHome.build(withListener: interactor)
        let feedRouting = feedHome.build(withListener: interactor)
        
        attachChild(challengeRouting)
        attachChild(feedRouting)
        
        let viewControllers = [
            NavigationControllerable(root: challengeRouting.viewControllable),
            NavigationControllerable(root: feedRouting.viewControllable)
        ]
        
        viewController.setViewControllers(viewControllers)
    }
}
