//
//  SignInBuilder.swift
//  Account
//
//  Created by 문효재 on 2022/07/15.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import Repository

public protocol SignInDependency: Dependency {
    var network: Network { get }
    var usecase: SignInUseCase { get }
    var userRepository: UserRepository { get }
}

final class SignInComponent: Component<SignInDependency>, SignUpDependency {
    var useCase: SignUpUseCase
    var network: Network { dependency.network }

    override init(dependency: SignInDependency) {
        self.useCase = SignUpUseCaseImpl(userRepository: dependency.userRepository)
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public protocol SignInBuildable: Buildable {
    func build(withListener listener: SignInListener) -> SignInRouting
}

public final class SignInBuilder: Builder<SignInDependency>, SignInBuildable {

    public override init(dependency: SignInDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: SignInListener) -> SignInRouting {
        let component = SignInComponent(dependency: dependency)
        let viewController = SignInViewController()
        let signUpBuilder = SignUpBuilder(dependency: component)
        let interactor = SignInInteractor(presenter: viewController, dependency: dependency)
        interactor.listener = listener
        return SignInRouter(interactor: interactor,
                            viewController: viewController,
                            signUpBuilder: signUpBuilder)
    }
}
