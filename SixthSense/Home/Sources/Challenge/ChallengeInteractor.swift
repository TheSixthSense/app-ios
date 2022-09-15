//
//  ChallengeInteractor.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift

protocol ChallengeRouting: ViewableRouting {
    func attachCalendar()
    func attachList()
}

protocol ChallengePresentable: Presentable {
    var listener: ChallengePresentableListener? { get set }
}

protocol ChallengeListener: AnyObject {
    func routeToSignIn()
}

final class ChallengeInteractor: PresentableInteractor<ChallengePresentable>, ChallengeInteractable, ChallengePresentableListener {

    weak var router: ChallengeRouting?
    weak var listener: ChallengeListener?

    override init(presenter: ChallengePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachCalendar()
        router?.attachList()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func routeToSignIn() {
        listener?.routeToSignIn()
    }
}
