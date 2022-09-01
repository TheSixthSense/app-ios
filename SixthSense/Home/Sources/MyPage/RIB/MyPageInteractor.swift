//
//  MyPageInteractor.swift
//  Home
//
//  Created by Allie Kim on 2022/09/01.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift

protocol MyPageRouting: ViewableRouting {
}

protocol MyPagePresentable: Presentable {
}

protocol MyPageListener: AnyObject {
}

final class MyPageInteractor: PresentableInteractor<MyPagePresentable>, MyPageInteractable {

    weak var router: MyPageRouting?
    weak var listener: MyPageListener?

    override init(presenter: MyPagePresentable) {
        super.init(presenter: presenter)
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}
