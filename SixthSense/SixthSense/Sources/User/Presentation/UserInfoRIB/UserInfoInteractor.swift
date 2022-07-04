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

    var userInfoRelay: BehaviorRelay<[UserItemsSection]>

    weak var router: UserInfoRouting?
    weak var listener: UserInfoListener?

    override init(presenter: UserInfoPresentable) {
        self.userInfoRelay = BehaviorRelay(value: [])
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        fetchUserInfo()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }

    private func fetchUserInfo() {
        let sectionModels = [
            UserItemsSection(
                model: 0,
                items: [
                    UserTableViewModel(model: User()),
                    UserTableViewModel(model: User()),
                    UserTableViewModel(model: User()),
                    UserTableViewModel(model: User()),
                ]
            )]
        userInfoRelay.accept(sectionModels)
    }
}
