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
    func routeToModifyView()
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
    var didTapLoginButton: Observable<Void> { get }
}

protocol MyPagePresenterHandler: AnyObject {
    var myPageSections: Observable<[MyPageSection]> { get }
    var presentLogoutPopup: Observable<Void> { get }
}

protocol MyPageListener: AnyObject {
    func routeToSignIn()
}

final class MyPageInteractor: PresentableInteractor<MyPagePresentable>, MyPageInteractable {

    weak var router: MyPageRouting?
    weak var listener: MyPageListener?

    private var component: MyPageComponent

    private let myPageSectionsRelay: PublishRelay<[MyPageSection]> = .init()
    private let logoutPopupRelay: PublishRelay<Void> = .init()

    private lazy var dataObservable = Observable.combineLatest(
        self.fetchUserData(), self.fetchChallengeUserData()
    )

    init(presenter: MyPagePresentable, component: MyPageComponent) {
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
            .subscribe(onNext: { owner, _ in
            owner.makeSection()
        }).disposeOnDeactivate(interactor: self)

        action.didTapLoginButton
            .withUnretained(self)
            .bind(onNext: { owner, _ in
            owner.routeToSignIn()
        }).disposeOnDeactivate(interactor: self)

        action.didSelectItem
            .withUnretained(self)
            .subscribe(onNext: { owner, item in
            switch item.type {
            case .modifyProfile:
                owner.router?.routeToModifyView()
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
        var items = [MyPageSectionItem]()

        items.append(.item(MyPageItemCellViewModel(id: 1, type: .privacyPolicy)))
        items.append(.item(MyPageItemCellViewModel(id: 2, type: .termsOfService)))
        items.append(.item(MyPageItemCellViewModel(id: 3, type: .version)))
        items.append(.item(MyPageItemCellViewModel(id: 4, type: .credits)))

        if !isLoggedIn() {
            items.insert(.header(MyPageHeaderViewModel.init()), at: 0)
            myPageSectionsRelay.accept([MyPageSection.init(identity: .item, items: items)])
            return
        }

        items.insert(.item(MyPageItemCellViewModel(id: 0, type: .modifyProfile)), at: 0)
        items.insert(.item(MyPageItemCellViewModel(id: 5, type: .logout)), at: items.count)

        dataObservable
            .withUnretained(self)
            .subscribe(onNext: { owner, data in

            let (userData, challengeStatData) = data
            owner.component.userInfoPayload = UserInfoPayload(model: userData)

            items.insert(.header(MyPageHeaderViewModel(nickname: userData.nickname,
                                                       statData: challengeStatData,
                                                       isLoggedIn: true)), at: 0)

            owner.myPageSectionsRelay.accept([MyPageSection.init(identity: .item, items: items)])
        }).disposeOnDeactivate(interactor: self)
    }

    private func fetchUserData() -> Observable<UserInfoModel> {
        return component.myPageUseCase.fetchUserData()
            .catch { _ in return .empty() }
            .asObservable()
    }

    private func fetchChallengeUserData() -> Observable<UserChallengeStatModel> {
        return component.myPageUseCase.fetchUserChallengeStats()
            .catch { _ in return .empty() }
            .asObservable()
    }

    private func loggedOut() {
        component.myPageUseCase.logout()
            .withUnretained(self)
            .bind(onNext: { owner, _ in
            owner.routeToSignIn()
        }).disposeOnDeactivate(interactor: self)
    }

    private func isLoggedIn() -> Bool {
        return component.myPageUseCase.isLoggedIn()
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
}
