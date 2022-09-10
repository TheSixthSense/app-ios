//
//  MyPageModifyInfoInteractor.swift
//  Home
//
//  Created by Allie Kim on 2022/09/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift

protocol MyPageModifyInfoRouting: ViewableRouting {

}
protocol MyPageModifyInfoPresentable: Presentable {

}
protocol MyPageModifyInfoListener: AnyObject {
}

final class MyPageModifyInfoInteractor: PresentableInteractor<MyPageModifyInfoPresentable>, MyPageModifyInfoInteractable {

    weak var router: MyPageModifyInfoRouting?
    weak var listener: MyPageModifyInfoListener?

    override init(presenter: MyPageModifyInfoPresentable) {
        super.init(presenter: presenter)
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}
