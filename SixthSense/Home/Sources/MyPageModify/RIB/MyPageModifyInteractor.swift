//
//  MyPageModifyInteractor.swift
//  Home
//
//  Created by Allie Kim on 2022/09/06.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift

protocol MyPageModifyRouting: ViewableRouting {
}

protocol MyPageModifyPresentable: Presentable {
    var handler: MyPageModifyPresenterHandler? { get set }
    var action: MyPageModifyPresenterAction? { get set }
}

protocol MyPageModifyPresenterHandler: AnyObject {

}

protocol MyPageModifyPresenterAction: AnyObject {

}

protocol MyPageModifyListener: AnyObject {
}

final class MyPageModifyInteractor: PresentableInteractor<MyPageModifyPresentable>, MyPageModifyInteractable {

    weak var router: MyPageModifyRouting?
    weak var listener: MyPageModifyListener?

    override init(presenter: MyPageModifyPresentable) {
        super.init(presenter: presenter)
        presenter.handler = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()

    }

    override func willResignActive() {
        super.willResignActive()
    }
}

extension MyPageModifyInteractor: MyPageModifyPresenterHandler {

}
