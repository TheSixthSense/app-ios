//
//  UserInfoBuilder.swift
//  SixthSense
//
//  Created by Allie Kim on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import Repository

protocol UserInfoDependency: Dependency {
    var network: Network { get }
}

final class UserInfoComponent: Component<UserInfoDependency> {
    let userUseCase: UserUseCaseable
    let userRepository: UserRepository

    override init(dependency: UserInfoDependency) {
        self.userRepository = UserRepositoryImpl(network: dependency.network)
        self.userUseCase = UserUseCase(userRepository: userRepository)
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol UserInfoBuildable: Buildable {
    func build(withListener listener: UserInfoListener) -> UserInfoRouting
}

final class UserInfoBuilder: Builder<UserInfoDependency>, UserInfoBuildable {

    override init(dependency: UserInfoDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: UserInfoListener) -> UserInfoRouting {
        let component = UserInfoComponent(dependency: dependency)
        let viewController = UserInfoViewController()
        let userInteractor = UserInfoInteractor(presenter: viewController, useCase: component.userUseCase)
        userInteractor.listener = listener
        return UserInfoRouter(interactor: userInteractor, viewController: viewController)
    }
}
