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
}

protocol MyPagePresenterHandler: AnyObject {
    var myPageSections: Observable<[MyPageSection]> { get }
    var presentLogoutPopup: Observable<Void> { get }
}

protocol MyPageListener: AnyObject {
}

final class MyPageInteractor: PresentableInteractor<MyPagePresentable>, MyPageInteractable {

    weak var router: MyPageRouting?
    weak var listener: MyPageListener?

    private var dependency: MyPageDependency

    private let myPageSectionsRelay: PublishRelay<[MyPageSection]> = .init()
    private let logoutPopupRelay: PublishRelay<Bool> = .init()

    private lazy var dataObservable = Observable.combineLatest(
        self.fetchUserData(), self.fetchChallengeUserData()
    )
    private var userInfoPayload = UserInfoPayload()

    init(presenter: MyPagePresentable, dependency: MyPageDependency) {
        self.dependency = dependency
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
        })
            .disposeOnDeactivate(interactor: self)

        action.didSelectItem
            .withUnretained(self)
            .subscribe(onNext: { owner, item in
            switch item.type {
            case .privacyPolicy, .termsOfService:
                owner.router?.routeToWebView(urlString: item.type.url ?? "", titleString: item.type.title)
                return
            case .logout:
                return owner.logoutPopupRelay.accept(true)
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
        return dependency.myPageUseCase.fetchUserData().asObservable()
    }

    private func fetchChallengeUserData() -> Observable<UserChallengeStatModel> {
        return dependency.myPageUseCase.fetchUserChallengeStats().asObservable().debug()
    }


    private func loggedOut() {
        // TODO: - 로그아웃 API & AccessToken 제거
    }

    func pop() {
        router?.detachWebView()
    }
}
extension MyPageInteractor: MyPagePresenterHandler {
    var myPageSections: Observable<[MyPageSection]> { myPageSectionsRelay.asObservable() }
    var presentLogoutPopup: Observable<Void> { logoutPopupRelay.map { _ in () }.asObservable() }
}
