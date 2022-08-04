//
//  RootInteractor.swift
//  SixthSense
//
//  Created by Allie Kim on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import Account

protocol RootRouting: ViewableRouting {
    func attachSplash()
    func detachSplash()
    func attachSignIn()
    func detachSignIn()
    func attachHome()
}

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
        
        // TODO: 스플래시 테스트를 위한 딜레이입니다 추후 제거
        Observable<Void>.just(())
            .delay(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.attachSignInIfNeeded()
            })
            .disposeOnDeactivate(interactor: self)

    }

    public override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: - Interactor Method
extension RootInteractor {
    private func attachSignInIfNeeded() {
        router?.detachSplash()
        
        if shouldShowSignInView() {
            router?.attachSignIn()
        } else {
            router?.attachHome()
        }
    }
    
    // FIXME: 아직 구현이 안된 메소드입니다
    private func shouldShowSignInView() -> Bool {
        return true
    }
    
    public func signInDidTapClose() {
        router?.detachSignIn()
        router?.attachHome()
    }
}
