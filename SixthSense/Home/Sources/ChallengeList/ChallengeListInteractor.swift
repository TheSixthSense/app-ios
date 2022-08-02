//
//  ChallengeListInteractor.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift

protocol ChallengeListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ChallengeListPresentable: Presentable {
    var listener: ChallengeListPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ChallengeListListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ChallengeListInteractor: PresentableInteractor<ChallengeListPresentable>, ChallengeListInteractable, ChallengeListPresentableListener {

    weak var router: ChallengeListRouting?
    weak var listener: ChallengeListListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ChallengeListPresentable) {
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
