//
//  UserInfoInteractor.swift
//  SixthSense
//
//  Created by Allie Kim on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxCocoa
import RxSwift

protocol UserInfoRouting: ViewableRouting {
}

protocol UserInfoPresentable: Presentable {
    var listener: UserInfoPresentableListener? { get set }
}

protocol UserInfoListener: AnyObject {
}

final class UserInfoInteractor: PresentableInteractor<UserInfoPresentable>, UserInfoInteractable, UserInfoPresentableListener {

    var userInfo: BehaviorRelay<[UserItemsSection]>

    weak var router: UserInfoRouting?
    weak var listener: UserInfoListener?

    override init(presenter: UserInfoPresentable) {
        self.userInfo = BehaviorRelay(value: [])
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    private func fetchUserInfo() {



    }
}
