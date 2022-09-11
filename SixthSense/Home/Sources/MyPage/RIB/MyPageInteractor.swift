//
//  MyPageInteractor.swift
//  Home
//
//  Created by Allie Kim on 2022/09/01.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import RIBs
import RxRelay
import RxSwift

protocol MyPageRouting: ViewableRouting {
    func routeToWebView(urlString: String, titleString: String)
    func detachWebView()
    func routeToModifyView(userData: UserInfoPayload)
    func detachModifyView()
}

protocol MyPagePresentable: Presentable {
    var handler: MyPagePresenterHandler? { get set }
    var action: MyPagePresenterAction? { get set }
}

protocol MyPagePresenterAction: AnyObject {
    var viewWillAppear: Observable<Void> { get }
    var didSelectItem: Observable <MyPageItemCellViewModel> { get }
    var loggedOut: Observable<Void> { get }
    var routeToSignIn: Observable<Void> { get }
}

protocol MyPagePresenterHandler: AnyObject {
    var myPageSections: Observable<[MyPageSection]> { get }
    var presentSignInPopup: Observable<Void> { get }
    var presentLogoutPopup: Observable<Void> { get }
}

protocol MyPageListener: AnyObject {
    func routeToSignIn()
}

final class MyPageInteractor: PresentableInteractor<MyPagePresentable>, MyPageInteractable {

    weak var router: MyPageRouting?
    weak var listener: MyPageListener?

    private var useCase: MyPageUseCase

    private let myPageSectionsRelay: PublishRelay<[MyPageSection]> = .init()
    private let signInPopupRelay: PublishRelay<Void> = .init()
    private let logoutPopupRelay: PublishRelay<Void> = .init()

    private lazy var dataObservable = Observable.combineLatest(
        self.fetchUserData(), self.fetchChallengeUserData()
    )
    private var userInfoPayload = UserInfoPayload()

    init(presenter: MyPagePresentable, useCase: MyPageUseCase) {
        self.useCase = useCase
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
            .flatMap(isLoggedIn)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
            owner.makeSection()
        }).disposeOnDeactivate(interactor: self)

        action.routeToSignIn
            .withUnretained(self)
            .bind(onNext: { owner, _ in
            owner.routeToSignIn()
        }).disposeOnDeactivate(interactor: self)

        action.didSelectItem
            .withUnretained(self)
            .subscribe(onNext: { owner, item in
            switch item.type {
            case .modifyProfile:
                owner.router?.routeToModifyView(userData: owner.userInfoPayload)
                return
            case .privacyPolicy, .termsOfService:
                owner.router?.routeToWebView(urlString: item.type.url ?? "", titleString: item.type.title)
                return
            case .logout:
                return owner.logoutPopupRelay.accept(())
            default: return
            }
        }).disposeOnDeactivate(interactor: self)

        action.loggedOut
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in owner.loggedOut() })
            .disposeOnDeactivate(interactor: self)
    }

    private func makeSection() {
        dataObservable
            .withUnretained(self)
            .subscribe(onNext: { owner, data in

            let (userData, challengeStatData) = data
            self.userInfoPayload = UserInfoPayload(model: userData)

            owner.myPageSectionsRelay.accept([
                    .init(identity: .header, items: [
                        .header(MyPageHeaderViewModel(nickname: userData.nickname,
                                                      statData: challengeStatData)),
                        .item(MyPageItemCellViewModel(id: 0, type: .modifyProfile)),
                        .item(MyPageItemCellViewModel(id: 1, type: .privacyPolicy)),
                        .item(MyPageItemCellViewModel(id: 2, type: .termsOfService)),
                        .item(MyPageItemCellViewModel(id: 3, type: .version)),
                        .item(MyPageItemCellViewModel(id: 4, type: .credits)),
                        .item(MyPageItemCellViewModel(id: 5, type: .logout)),
                ])
            ])
        }).disposeOnDeactivate(interactor: self)
    }

    private func fetchUserData() -> Observable<UserInfoModel> {
        return useCase.fetchUserData().asObservable()
    }

    private func fetchChallengeUserData() -> Observable<UserChallengeStatModel> {
        return useCase.fetchUserChallengeStats().asObservable()
    }

    private func loggedOut() {
        useCase.logout()
            .withUnretained(self)
            .bind(onNext: { owner, _ in
            owner.routeToSignIn()
        }).disposeOnDeactivate(interactor: self)
    }

    private func isLoggedIn() -> Observable<Bool> {
        return useCase.isLoggedIn()
            .do(onNext: { [weak self] in
            if !$0 {
                self?.signInPopupRelay.accept(())
            }
        })
    }

    func popWebView() {
        router?.detachWebView()
    }

    func popModifyView() {
        router?.detachModifyView()
    }

    func routeToSignIn() {
        listener?.routeToSignIn()
    }
}
extension MyPageInteractor: MyPagePresenterHandler {
    var myPageSections: Observable<[MyPageSection]> { myPageSectionsRelay.asObservable() }
    var presentLogoutPopup: Observable<Void> { logoutPopupRelay.map { _ in () }.asObservable() }
    var presentSignInPopup: Observable<Void> { signInPopupRelay.asObservable() }
}
