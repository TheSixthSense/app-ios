//
//  HomeInteractor.swift
//  Home
//
//  Created by 문효재 on 2022/08/01.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

public protocol HomeRouting: ViewableRouting {
    func attachTabs()
    func detachTabs()
}

protocol HomePresentable: Presentable {
    var listener: HomePresentableListener? { get set }
}

public protocol HomeListener: AnyObject {
    func routeToSignIn()
}

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable, HomePresentableListener {

    weak var router: HomeRouting?
    weak var listener: HomeListener?

    override init(presenter: HomePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachTabs()
    }

    override func willResignActive() {
        super.willResignActive()
        router?.detachTabs()
    }

    func routeToSignIn() {
        listener?.routeToSignIn()
    }
}
