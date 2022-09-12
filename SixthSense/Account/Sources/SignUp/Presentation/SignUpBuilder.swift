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
    var userRepository: UserRepository { get }
}

final class SignUpComponent: Component<SignUpDependency>, SignUpCompleteDependency {
    var useCase: SignUpUseCase { SignUpUseCaseImpl(userRepository: dependency.userRepository) }
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
        let interactor = SignUpInteractor(presenter: viewController,
                                          dependency: component,
                                          payload: payload)
        interactor.listener = listener
        let signUpComplete = SignUpCompleteBuilder(dependency: component)
        return SignUpRouter(interactor: interactor, viewController: viewController, signUpComplete: signUpComplete)
    }
}
