//
//  ChallengeCalendarInteractor.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift

protocol ChallengeCalendarRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ChallengeCalendarPresentable: Presentable {
    var listener: ChallengeCalendarPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ChallengeCalendarListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ChallengeCalendarInteractor: PresentableInteractor<ChallengeCalendarPresentable>, ChallengeCalendarInteractable, ChallengeCalendarPresentableListener {

    weak var router: ChallengeCalendarRouting?
    weak var listener: ChallengeCalendarListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ChallengeCalendarPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
