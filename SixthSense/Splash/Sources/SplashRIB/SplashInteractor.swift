//
//  SplashInteractor.swift
//  VegannerAppDev
//
//  Created by 문효재 on 2022/07/12.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift

public protocol SplashRouting: ViewableRouting { }

protocol SplashPresentable: Presentable {
    var listener: SplashPresentableListener? { get set }
}

public protocol SplashListener: AnyObject {}

final class SplashInteractor: PresentableInteractor<SplashPresentable>, SplashInteractable, SplashPresentableListener {
    weak var router: SplashRouting?
    weak var listener: SplashListener?
    
    override init(presenter: SplashPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
}
