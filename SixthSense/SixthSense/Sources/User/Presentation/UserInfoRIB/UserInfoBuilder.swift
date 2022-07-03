//
//  UserInfoBuilder.swift
//  SixthSense
//
//  Created by Allie Kim on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol UserInfoDependency: Dependency {
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
        let component = UserInfoComponent(dependency: dependency)
        let viewController = UserInfoViewController()
        let interactor = UserInfoInteractor(presenter: viewController)
        interactor.listener = listener
        return UserInfoRouter(interactor: interactor, viewController: viewController)
    }
}
