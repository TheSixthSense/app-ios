//
//  SplashBuilder.swift
//  VegannerAppDev
//
//  Created by 문효재 on 2022/07/12.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import Account
import Repository
import Storage
import Home

public protocol SplashDependency: Dependency {
    var network: Network { get }
    var persistence: LocalPersistence { get }
    var userRepository: UserRepository { get }
}

final class SplashComponent: Component<SplashDependency>, UserInfoDependency, HomeDependency {
    var network: Network { dependency.network }
    var userRepository: UserRepository { dependency.userRepository }
    
    override init(dependency: SplashDependency) {
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public protocol SplashBuildable: Buildable {
    func build(withListener listener: SplashListener) -> SplashRouting
}

public final class SplashBuilder: Builder<SplashDependency>, SplashBuildable {
    
    public override init(dependency: SplashDependency) {
        super.init(dependency: dependency)
    }
    
    public func build(withListener listener: SplashListener) -> SplashRouting {
        let component = SplashComponent(dependency: dependency)
        let viewController = SplashViewController()
        let interactor = SplashInteractor(presenter: viewController)
        
        let userInfoBuilder = UserInfoBuilder(dependency: component)
        let homeBuilder = HomeBuilder(dependency: component)
        
        interactor.listener = listener
        return SplashRouter(
            interactor: interactor,
            viewController: viewController,
            userInfoBuilder: userInfoBuilder,
            homeBuilder: homeBuilder
        )
    }
}
