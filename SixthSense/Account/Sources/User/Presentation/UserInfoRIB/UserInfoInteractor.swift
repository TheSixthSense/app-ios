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

public protocol UserInfoRouting: ViewableRouting {
}

protocol UserInfoPresentable: Presentable {
    var listener: UserInfoPresentableListener? { get set }
}

public protocol UserInfoListener: AnyObject {
}

final class UserInfoInteractor: PresentableInteractor<UserInfoPresentable>, UserInfoInteractable, UserInfoPresentableListener {

    var userInfoDriver: Driver<[UserItemsSection]>

    weak var router: UserInfoRouting?
    weak var listener: UserInfoListener?

    private let userUseCase: UserUseCaseable
    private var userInfoRelay: PublishRelay<[UserItemsSection]>
    private let disposeBag: DisposeBag = DisposeBag()

    init(presenter: UserInfoPresentable, useCase: UserUseCaseable) {
        self.userUseCase = useCase
        self.userInfoRelay = PublishRelay()
        self.userInfoDriver = userInfoRelay.asDriver(onErrorDriveWith: .empty())
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
        userUseCase.fetch()
        // [UserEntity] -> [UserTableViewModel]
        .compactMap({ $0.compactMap({ UserTableViewModel(model: $0) }) })
        // UserTableViewModel -> [UserItemsSection]
        .map({ [UserItemsSection(model: 0, items: $0)] })
            .bind(to: userInfoRelay)
            .disposed(by: disposeBag)
    }
}
