//
//  SignInBuilder.swift
//  Account
//
//  Created by 문효재 on 2022/07/15.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import Repository
import Storage

public protocol SignInDependency: Dependency {
    var userRepository: UserRepository { get }
    var persistence: LocalPersistence { get }
}

final class SignInComponent: Component<SignInDependency>, SignUpDependency, SignInInteractorDependency {
    var usecase: SignInUseCase
    var userRepository: UserRepository { dependency.userRepository }

    override init(dependency: SignInDependency) {
        usecase = SignInUseCaseImpl(userRepository: dependency.userRepository,
                                    persistence: dependency.persistence)
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
        let interactor = SignInInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return SignInRouter(interactor: interactor,
                            viewController: viewController,
                            signUpBuilder: signUpBuilder)
    }
}
