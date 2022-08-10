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
                                ChallengeListListener {
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

    init(
        interactor: ChallengeInteractable,
        viewController: ChallengeViewControllable,
        calendarBuildable: ChallengeCalendarBuildable,
        listBuildable: ChallengeListBuildable
    ) {
        self.calendarBuildable = calendarBuildable
        self.listBuildable = listBuildable
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
}
