//
//  UserInfoBuilder.swift
//  SixthSense
//
//  Created by Allie Kim on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol UserInfoDependency: Dependency {
    var network: Network { get }
}

final class UserInfoComponent: Component<UserInfoDependency> {

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
        let _ = UserInfoComponent(dependency: dependency)
        let viewController = UserInfoViewController()

        let network = NetworkImpl(intercepter: NetworkInterceptableImpl(), logger: SwiftyLogger())
        let userRepository = UserRepositoryImpl(network: network)
        let userUseCase = UserUseCase(userRepository: userRepository)

        let userInteractor = UserInfoInteractor(presenter: viewController, useCase: userUseCase)
        userInteractor.listener = listener
        return UserInfoRouter(interactor: userInteractor, viewController: viewController)
    }
}
