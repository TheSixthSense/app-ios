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
    var useCase: SignUpUseCase { get }
}

final class SignUpComponent: Component<SignUpDependency> {
    var network: Network { dependency.network }
    var payload: SignUpPayload

    init(dependency: SignUpDependency, payload: SignUpPayload) {
        self.payload = payload
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
        let component = SignUpComponent(dependency: dependency, payload: payload)
        let viewController = SignUpViewController()
        let interactor = SignUpInteractor(presenter: viewController,
                                          dependency: dependency,
                                          payload: component.payload)
        interactor.listener = listener
        return SignUpRouter(interactor: interactor, viewController: viewController)
    }
}
