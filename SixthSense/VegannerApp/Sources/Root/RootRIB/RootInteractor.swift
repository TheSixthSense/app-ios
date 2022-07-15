//
//  RootInteractor.swift
//  SixthSense
//
//  Created by Allie Kim on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift

protocol RootRouting: ViewableRouting {}

public protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
}

protocol RootListener: AnyObject {
}

public final class RootInteractor: PresentableInteractor<RootPresentable>, RootInteractable, RootPresentableListener {

    weak var router: RootRouting?
    weak var listener: RootListener?

    public override init(presenter: RootPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    public override func didBecomeActive() {
        super.didBecomeActive()
    }

    public override func willResignActive() {
        super.willResignActive()
    }
}
