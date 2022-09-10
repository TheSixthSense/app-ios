//
//  MyPageWebViewInteractor.swift
//  Home
//
//  Created by Allie Kim on 2022/09/06.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift

protocol MyPageWebViewRouting: ViewableRouting {
}

protocol MyPageWebViewPresentable: Presentable {
    var listener: MyPageWebViewPresentableListener? { get set }
}

protocol MypageWebViewPresenterAction: AnyObject {
    var didTapBackButton: Observable<Void> { get }
}

protocol MyPageWebViewListener: AnyObject {
    func popWebView()
}

final class MyPageWebViewInteractor: PresentableInteractor<MyPageWebViewPresentable>, MyPageWebViewInteractable, MyPageWebViewPresentableListener {

    weak var router: MyPageWebViewRouting?
    weak var listener: MyPageWebViewListener?

    override init(presenter: MyPageWebViewPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func pop() {
        listener?.popWebView()
    }
}
