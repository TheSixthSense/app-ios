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
    func routeToModifyInfo(type: ModifyType)
    func detachModifyInfoView()
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
    var didTapEditButton: Observable<ModifyType> { get }
}

protocol MyPageModifyListener: AnyObject {
    func popModifyView()
}

final class MyPageModifyInteractor: PresentableInteractor<MyPageModifyPresentable>, MyPageModifyInteractable {

    weak var router: MyPageModifyRouting?
    weak var listener: MyPageModifyListener?

    private var userInfo: UserInfoPayload

    private let userInfoPayloadRelay: PublishRelay<UserInfoPayload> = .init()
    private let withDrawPopupRelay: PublishRelay<Void> = .init()

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
    }

    private func bind() {
        guard let action = presenter.action else { return }

        action.viewWillAppear
            .withUnretained(self)
            .bind(onNext: { owner, _ in
            owner.userInfoPayloadRelay.accept(self.userInfo)
        }).disposeOnDeactivate(interactor: self)

        action.didTapBackButton
            .withUnretained(self)
            .bind(onNext: { owner, _ in
            owner.listener?.popModifyView()
        }).disposeOnDeactivate(interactor: self)

        action.didTapEditButton
            .withUnretained(self)
            .bind(onNext: { owner, type in
            owner.router?.routeToModifyInfo(type: type)
        }).disposeOnDeactivate(interactor: self)
    }

    func popModifyInfoView() {
        router?.detachModifyInfoView()
    }
}

extension MyPageModifyInteractor: MyPageModifyPresenterHandler {
    var userInfoPayload: Observable<UserInfoPayload> { userInfoPayloadRelay.asObservable() }
}

