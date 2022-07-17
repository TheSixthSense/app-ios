//
//  SplashInteractor.swift
//  VegannerAppDev
//
//  Created by 문효재 on 2022/07/12.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift

public protocol SplashRouting: ViewableRouting {
    func attachUserInfo()
    func attachSignIn()
}

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
        
        // TODO: 스플래시 테스트를 위한 딜레이입니다 추후 제거
        Observable<Void>.just(())
            .delay(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.attachSignInIfNeeded()
            })
            .disposeOnDeactivate(interactor: self)
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: - Interactor Method
extension SplashInteractor {
    private func attachSignInIfNeeded() {
        if shouldShowSignInView() {
            router?.attachSignIn()
        } else {
            router?.attachUserInfo()
        }
    }
    
    // FIXME: 아직 구현이 안된 메소드입니다
    private func shouldShowSignInView() -> Bool {
        return true
    }
}
