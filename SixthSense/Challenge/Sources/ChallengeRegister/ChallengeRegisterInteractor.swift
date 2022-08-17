//
//  ChallengeRegisterInteractor.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift

public protocol ChallengeRegisterRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ChallengeRegisterPresentable: Presentable {
    var listener: ChallengeRegisterPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

public protocol ChallengeRegisterListener: AnyObject {
    func returnToHome()
}

final class ChallengeRegisterInteractor: PresentableInteractor<ChallengeRegisterPresentable>, ChallengeRegisterInteractable, ChallengeRegisterPresentableListener {

    weak var router: ChallengeRegisterRouting?
    weak var listener: ChallengeRegisterListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ChallengeRegisterPresentable) {
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

    func didTapBackButton() {
        listener?.returnToHome()
    }
}
