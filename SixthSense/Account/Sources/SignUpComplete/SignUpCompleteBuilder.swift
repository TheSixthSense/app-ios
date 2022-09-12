//
//  SignUpCompleteBuilder.swift
//  Account
//
//  Created by Allie Kim on 2022/09/13.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol SignUpCompleteDependency: Dependency {
}

final class SignUpCompleteComponent: Component<SignUpCompleteDependency> {
}

// MARK: - Builder

protocol SignUpCompleteBuildable: Buildable {
    func build(withListener listener: SignUpCompleteListener) -> SignUpCompleteRouting
}

final class SignUpCompleteBuilder: Builder<SignUpCompleteDependency>, SignUpCompleteBuildable {

    override init(dependency: SignUpCompleteDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SignUpCompleteListener) -> SignUpCompleteRouting {
        let component = SignUpCompleteComponent(dependency: dependency)
        let viewController = SignUpCompleteViewController()
        let interactor = SignUpCompleteInteractor(presenter: viewController)
        interactor.listener = listener
        return SignUpCompleteRouter(interactor: interactor, viewController: viewController)
    }
}
