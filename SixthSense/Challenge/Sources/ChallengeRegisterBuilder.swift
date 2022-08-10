//
//  ChallengeRegisterBuilder.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol ChallengeRegisterDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ChallengeRegisterComponent: Component<ChallengeRegisterDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ChallengeRegisterBuildable: Buildable {
    func build(withListener listener: ChallengeRegisterListener) -> ChallengeRegisterRouting
}

final class ChallengeRegisterBuilder: Builder<ChallengeRegisterDependency>, ChallengeRegisterBuildable {

    override init(dependency: ChallengeRegisterDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ChallengeRegisterListener) -> ChallengeRegisterRouting {
        let component = ChallengeRegisterComponent(dependency: dependency)
        let viewController = ChallengeRegisterViewController()
        let interactor = ChallengeRegisterInteractor(presenter: viewController)
        interactor.listener = listener
        return ChallengeRegisterRouter(interactor: interactor, viewController: viewController)
    }
}
