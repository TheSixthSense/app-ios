//
//  MyPageModifyInteractor.swift
//  Home
//
//  Created by Allie Kim on 2022/09/06.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxRelay
import RxSwift

protocol MyPageModifyRouting: ViewableRouting {
}

protocol MyPageModifyPresentable: Presentable {
    var handler: MyPageModifyPresenterHandler? { get set }
    var action: MyPageModifyPresenterAction? { get set }
}

protocol MyPageModifyPresenterHandler: AnyObject {
    var userInfoPayload: Observable<UserInfoPayload> { get }
}

protocol MyPageModifyPresenterAction: AnyObject {
    var viewWillAppear: Observable<Void> { get }
    var didTapBackButton: Observable<Void> { get }
    var withDrawConfirmed: Observable<Void> { get }
}

protocol MyPageModifyListener: AnyObject {
    func popModifyView()
}

final class MyPageModifyInteractor: PresentableInteractor<MyPageModifyPresentable>, MyPageModifyInteractable {

    weak var router: MyPageModifyRouting?
    weak var listener: MyPageModifyListener?

    private var userInfo: UserInfoPayload

    private var userInfoPayloadRelay: PublishRelay<UserInfoPayload> = .init()
    private var withDrawPopupRelay: PublishRelay<Void> = .init()

    private var disposeBag = DisposeBag()

    init(presenter: MyPageModifyPresentable, userPayload: UserInfoPayload) {
        self.userInfo = userPayload
        super.init(presenter: presenter)
        presenter.handler = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        bind()
    }

    override func willResignActive() {
        super.willResignActive()
        disposeBag = DisposeBag()
    }

    private func bind() {
        guard let action = presenter.action else { return }

        disposeBag.insert {

            action.viewWillAppear
                .withUnretained(self)
                .bind(onNext: { owner, _ in
                owner.userInfoPayloadRelay.accept(self.userInfo)
            })

            action.didTapBackButton
                .withUnretained(self)
                .bind(onNext: { owner, _ in
                owner.listener?.popModifyView()
            })


        }
    }
}

extension MyPageModifyInteractor: MyPageModifyPresenterHandler {
    var userInfoPayload: Observable<UserInfoPayload> { userInfoPayloadRelay.asObservable() }
}

