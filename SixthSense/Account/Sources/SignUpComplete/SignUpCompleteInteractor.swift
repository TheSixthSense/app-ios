//
//  SignUpCompleteInteractor.swift
//  Account
//
//  Created by Allie Kim on 2022/09/13.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift

protocol SignUpCompleteRouting: ViewableRouting {
}

protocol SignUpCompletePresentable: Presentable {
    var listener: SignUpCompletePresentableListener? { get set }
}

protocol SignUpCompleteListener: AnyObject {
    func routeToHome()
}

final class SignUpCompleteInteractor: PresentableInteractor<SignUpCompletePresentable>, SignUpCompleteInteractable, SignUpCompletePresentableListener {

    weak var router: SignUpCompleteRouting?
    weak var listener: SignUpCompleteListener?

    override init(presenter: SignUpCompletePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func routeToHome() {
        listener?.routeToHome()
    }
}
