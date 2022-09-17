//
//  MyPageModifyInfoBuilder.swift
//  Home
//
//  Created by Allie Kim on 2022/09/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import Repository

protocol MyPageModifyInfoDependency: Dependency {
    var userRepository: UserRepository { get }
    var userInfoPayload: UserInfoPayload { get }
}

final class MyPageModifyInfoComponent: Component<MyPageModifyInfoDependency> {
    var useCase: MyPageModifyInfoUseCase { MyPageModifyInfoUseCaseImpl(userRepository: dependency.userRepository) }
    var userInfoPayload: UserInfoPayload

    override init(dependency: MyPageModifyInfoDependency) {
        self.userInfoPayload = dependency.userInfoPayload
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol MyPageModifyInfoBuildable: Buildable {
    func build(withListener listener: MyPageModifyInfoListener, type: ModifyType) -> MyPageModifyInfoRouting
}

final class MyPageModifyInfoBuilder: Builder<MyPageModifyInfoDependency>, MyPageModifyInfoBuildable {

    override init(dependency: MyPageModifyInfoDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MyPageModifyInfoListener, type: ModifyType) -> MyPageModifyInfoRouting {
        let component = MyPageModifyInfoComponent(dependency: dependency)
        let viewController = MyPageModifyInfoViewController(type: type)
        let interactor = MyPageModifyInfoInteractor(presenter: viewController, component: component)
        interactor.listener = listener
        return MyPageModifyInfoRouter(interactor: interactor, viewController: viewController)
    }
}
