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
    func routeToSignIn()
}

final class MyPageModifyInteractor: PresentableInteractor<MyPageModifyPresentable>, MyPageModifyInteractable {

    weak var router: MyPageModifyRouting?
    weak var listener: MyPageModifyListener?

    private let component: MyPageModifyComponent

    private let userInfoPayloadRelay: PublishRelay<UserInfoPayload> = .init()
    private let withDrawPopupRelay: PublishRelay<Void> = .init()

    private var disposeBag = DisposeBag()

    init(presenter: MyPageModifyPresentable,
         component: MyPageModifyComponent) {
        self.component = component
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
            owner.userInfoPayloadRelay.accept(owner.component.userInfoPayload)
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

        action.withDrawConfirmed
            .withUnretained(self)
            .bind(onNext: { owner, _ in
            owner.withdrawUser()
        }).disposeOnDeactivate(interactor: self)
    }

    func popModifyInfoView(userInfo: UserInfoPayload) {
        component.userInfoPayload = userInfo
        router?.detachModifyInfoView()
    }

    func withdrawUser() {
        component.useCase.withdrawUser()
            .withUnretained(self)
            .bind(onNext: { owner, _ in
            owner.popModifyInfoView(userInfo: owner.component.userInfoPayload)
            owner.listener?.routeToSignIn()
        }).disposeOnDeactivate(interactor: self)
    }
}

extension MyPageModifyInteractor: MyPageModifyPresenterHandler {
    var userInfoPayload: Observable<UserInfoPayload> { userInfoPayloadRelay.asObservable() }
}

