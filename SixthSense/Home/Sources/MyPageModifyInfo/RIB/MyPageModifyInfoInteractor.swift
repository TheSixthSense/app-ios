//
//  MyPageModifyInfoInteractor.swift
//  Home
//
//  Created by Allie Kim on 2022/09/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxRelay
import RxSwift

protocol MyPageModifyInfoRouting: ViewableRouting {

}

protocol MyPageModifyInfoPresentable: Presentable {
    var handler: MyPageModifyInfoPresenterHandler? { get set }
    var action: MyPageModifyInfoPresenterAction? { get set }
}

protocol MyPageModifyInfoPresenterHandler: AnyObject {

}

protocol MyPageModifyInfoPresenterAction: AnyObject {
    var didTapBackButton: Observable<Void> { get }

}

protocol MyPageModifyInfoListener: AnyObject {
    func popModifyInfoView()
}

final class MyPageModifyInfoInteractor: PresentableInteractor<MyPageModifyInfoPresentable>, MyPageModifyInfoInteractable {

    weak var router: MyPageModifyInfoRouting?
    weak var listener: MyPageModifyInfoListener?

    override init(presenter: MyPageModifyInfoPresentable) {
        super.init(presenter: presenter)
        presenter.handler = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        bind()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    private func bind() {
        bindAction()
    }

    private func bindAction() {
        guard let action = presenter.action else { return }
        action.didTapBackButton
            .withUnretained(self)
            .bind(onNext: { owner, _ in
            owner.listener?.popModifyInfoView()
        }).disposeOnDeactivate(interactor: self)
    }
}

extension MyPageModifyInfoInteractor: MyPageModifyInfoPresenterHandler {

}
