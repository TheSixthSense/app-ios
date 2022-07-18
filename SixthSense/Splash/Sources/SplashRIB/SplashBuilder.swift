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
    var userRepository: UserRepository { get }
}

final class SplashComponent: Component<SplashDependency>, SignUpDependency, SignInDependency {
    var network: Network { dependency.network }
    var usecase: SignInUseCase
    
    override init(dependency: SplashDependency) {
        // TODO: SignInUseCase는 어디서 주입해야할지 고민해보기
        self.usecase = SignInUseCaseImpl(userRepository: dependency.userRepository)
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
        
        let signUpBuilder = SignUpBuilder(dependency: component)
        let signInBuilder = SignInBuilder(dependency: component)
        
        interactor.listener = listener
        return SplashRouter(
            interactor: interactor,
            viewController: viewController,
            signUpBuilder: signUpBuilder,
            signInBuilder: signInBuilder
        )
    }
}
