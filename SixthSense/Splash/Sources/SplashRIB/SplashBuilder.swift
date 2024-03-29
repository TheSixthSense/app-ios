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
    var userRepository: UserRepository { get }
    var challengeRepository: ChallengeRepository { get }
}

final class SplashComponent: Component<SplashDependency> {

    var network: Network { dependency.network }
    var userRepository: UserRepository { dependency.userRepository }
    var challengeRepository: ChallengeRepository { dependency.challengeRepository }
    
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
        let _ = SplashComponent(dependency: dependency)
        let viewController = SplashViewController()
        let interactor = SplashInteractor(presenter: viewController)
        
        interactor.listener = listener
        return SplashRouter(
            interactor: interactor,
            viewController: viewController
        )
    }
}
