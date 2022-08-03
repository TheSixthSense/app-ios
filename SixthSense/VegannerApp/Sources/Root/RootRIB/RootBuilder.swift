//
//  RootBuilder.swift
//  SixthSense
//
//  Created by Allie Kim on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import Repository
import Account
import Splash
import Storage

protocol RootDependency: Dependency {
    var network: Network { get }
    var persistence: LocalPersistence { get }
    var userRepository: UserRepository { get }
}

// MARK: - Builder

protocol RootBuildable: Buildable {
    func build() -> LaunchRouting
}

final class RootBuilder: Builder<RootDependency>, RootBuildable {

    override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }

    func build() -> LaunchRouting {
        let component = RootComponent(dependency: dependency)
        let viewController = RootViewController()
        let interactor = RootInteractor(presenter: viewController)
        let splashBuilder = SplashBuilder(dependency: component)
        return RootRouter(
            interactor: interactor,
            viewController: viewController,
            splashBuilder: splashBuilder
        )
    }
}
