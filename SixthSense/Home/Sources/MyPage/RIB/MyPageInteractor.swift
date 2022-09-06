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
}

protocol MyPagePresentable: Presentable {
    var handler: MyPagePresenterHandler? { get set }
    var action: MyPagePresenterAction? { get set }
}

protocol MyPagePresenterAction: AnyObject {
    var viewWillAppear: Observable<Void> { get }
}

protocol MyPagePresenterHandler: AnyObject {
    var myPageSections: Observable<[MyPageSection]> { get }
}

protocol MyPageListener: AnyObject {
}

final class MyPageInteractor: PresentableInteractor<MyPagePresentable>, MyPageInteractable {

    weak var router: MyPageRouting?
    weak var listener: MyPageListener?

    private let myPageSectionsRelay: PublishRelay<[MyPageSection]> = .init()

    override init(presenter: MyPagePresentable) {
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
    }

    private func makeSection() {
        // Mock
        myPageSectionsRelay.accept([
                .init(identity: .header, items: [.header, .item, .item, .item, .item, .item])
        ])
    }

    func pop() {
        router?.detachWebView()
    }
}
extension MyPageInteractor: MyPagePresenterHandler {
    var myPageSections: Observable<[MyPageSection]> { myPageSectionsRelay.asObservable().debug() }
}
