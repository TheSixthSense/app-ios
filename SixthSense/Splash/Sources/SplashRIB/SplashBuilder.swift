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

public protocol SplashDependency: Dependency {
    var network: Network { get }
}

final class SplashComponent: Component<SplashDependency>, UserInfoDependency, SignInDependency {
    var network: Network { dependency.network }
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
        
        interactor.listener = listener
        return SplashRouter(
            interactor: interactor,
            viewController: viewController,
            userInfoBuilder: userInfoBuilder,
        )
    }
}
