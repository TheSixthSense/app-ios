//
//  UserInfoBuilder.swift
//  SixthSense
//
//  Created by Allie Kim on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import Repository

public protocol UserInfoDependency: Dependency {
    var network: Network { get }
    var userRepository: UserRepository { get }
}

final class UserInfoComponent: Component<UserInfoDependency> {
    let userUseCase: UserUseCaseable

    override init(dependency: UserInfoDependency) {
        self.userUseCase = UserUseCase(userRepository: dependency.userRepository)
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public protocol UserInfoBuildable: Buildable {
    func build(withListener listener: UserInfoListener) -> UserInfoRouting
}

public final class UserInfoBuilder: Builder<UserInfoDependency>, UserInfoBuildable {

    public override init(dependency: UserInfoDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: UserInfoListener) -> UserInfoRouting {
        let component = UserInfoComponent(dependency: dependency)
        let viewController = UserInfoViewController()
        let userInteractor = UserInfoInteractor(presenter: viewController, useCase: component.userUseCase)
        userInteractor.listener = listener
        return UserInfoRouter(interactor: userInteractor, viewController: viewController)
    }
}
