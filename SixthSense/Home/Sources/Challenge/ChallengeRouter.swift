//
//  ChallengeRouter.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import Challenge

protocol ChallengeInteractable: Interactable,
                                ChallengeCalendarListener,
                                ChallengeListListener,
                                ChallengeRegisterListener {
    var router: ChallengeRouting? { get set }
    var listener: ChallengeListener? { get set }
}

protocol ChallengeViewControllable: ViewControllable {
    func addDashBoard(_ view: ViewControllable)
}

final class ChallengeRouter: ViewableRouter<ChallengeInteractable, ChallengeViewControllable>, ChallengeRouting {
    private let calendarBuildable: ChallengeCalendarBuildable
    private var calendarRouting: Routing?

    private let listBuildable: ChallengeListBuildable
    private var listRouting: Routing?

    private let registerBuildable: ChallengeRegisterBuildable
    private var registerRouting: Routing?

    init(
        interactor: ChallengeInteractable,
        viewController: ChallengeViewControllable,
        calendarBuildable: ChallengeCalendarBuildable,
        listBuildable: ChallengeListBuildable,
        registerBuildable: ChallengeRegisterBuildable
    ) {
        self.calendarBuildable = calendarBuildable
        self.listBuildable = listBuildable
        self.registerBuildable = registerBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    func attachCalendar() {
        guard self.calendarRouting == nil else { return }
        
        let router = calendarBuildable.build(withListener: interactor)
        
        let dashboard = router.viewControllable
        viewController.addDashBoard(dashboard)
        
        self.calendarRouting = router
        attachChild(router)
    }
    
    func attachList() {
        guard self.listRouting == nil else { return }
        
        let router = listBuildable.build(withListener: interactor)
        
        let dashboard = router.viewControllable
        viewController.addDashBoard(dashboard)
        
        self.listRouting = router
        attachChild(router)
    }

    func attachChallengeRegister() {
        guard registerRouting == nil  else { return }
        let router = registerBuildable.build(withListener: interactor)
        self.registerRouting = router
        attachChild(router)
        viewController.pushViewController(router.viewControllable, animated: true)
    }

    func detachChallengeRegister() {
        guard let router = registerRouting else { return }
        detachChild(router)
        viewController.popViewController(animated: true)
        self.registerRouting = nil
    }
}
