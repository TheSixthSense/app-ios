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
                           MyPageListener,
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

    private let mypageHome: MyPageBuildable
    private var mypageHomeRouting: ViewableRouting?

    private let challengeRegisterHome: ChallengeRegisterBuildable
    private var challengeRegisterRouting: ViewableRouting?

    init(interactor: HomeInteractable,
         viewController: HomeViewControllable,
         challengeHome: ChallengeBuildable,
         challengeRegisterHome: ChallengeRegisterBuildable,
         mypageHome: MyPageBuildable) {

        self.challengeHome = challengeHome
        self.mypageHome = mypageHome
        self.challengeRegisterHome = challengeRegisterHome
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    func attachTabs() {
        let challengeRouting = challengeHome.build(withListener: interactor)
        let challengeRegisterRouting = challengeRegisterHome.build(withListener: interactor)
        let mypageRouting = mypageHome.build(withListener: interactor)

        attachChild(challengeRouting)
        self.challengeHomeRouting = challengeRouting
        attachChild(challengeRegisterRouting)
        self.challengeRegisterRouting = challengeRegisterRouting
        attachChild(mypageRouting)
        self.mypageHomeRouting = mypageRouting

        let viewControllers = [
            NavigationControllerable(root: challengeRouting.viewControllable),
            NavigationControllerable(root: challengeRegisterRouting.viewControllable),
            NavigationControllerable(root: mypageRouting.viewControllable)
        ]

        viewController.setViewControllers(viewControllers)
    }

    func detachTabs() {
        guard let challengeHomeRouting = challengeHomeRouting else { return }
        guard let challengeRegisterRouting = challengeRegisterRouting else { return }
        guard let mypageHomeRouting = mypageHomeRouting else { return }

        detachChild(challengeHomeRouting)
        detachChild(challengeRegisterRouting)
        detachChild(mypageHomeRouting)

        self.challengeHomeRouting = nil
        self.challengeRegisterRouting = nil
        self.mypageHomeRouting = nil

        viewController.dismiss(animated: false, completion: nil)
    }
}
