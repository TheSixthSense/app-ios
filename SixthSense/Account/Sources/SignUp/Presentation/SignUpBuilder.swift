//
//  SignUpBuilder.swift
//  Account
//
//  Created by Allie Kim on 2022/07/14.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import Repository

public protocol SignUpDependency: Dependency {
    var network: Network { get }
}

final class SignUpComponent: Component<SignUpDependency> {
    let userUseCase: SignUpUseCase
    let userRepository: UserRepository

    override init(dependency: SignUpDependency) {
        self.userRepository = UserRepositoryImpl(network: dependency.network)
        self.userUseCase = SignUpUseCaseImpl(userRepository: userRepository)
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public protocol SignUpBuildable: Buildable {
    func build(withListener listener: SignUpListener, payload: SignUpPayload) -> SignUpRouting
}

public final class SignUpBuilder: Builder<SignUpDependency>, SignUpBuildable {

    public override init(dependency: SignUpDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: SignUpListener, payload: SignUpPayload) -> SignUpRouting {
        let component = SignUpComponent(dependency: dependency)
        let viewController = SignUpViewController()
        let interactor = SignUpInteractor(presenter: viewController, useCase: component.userUseCase, payload: payload)
        interactor.listener = listener
        return SignUpRouter(interactor: interactor, viewController: viewController)
    }
}
