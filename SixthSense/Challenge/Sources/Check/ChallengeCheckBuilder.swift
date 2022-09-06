//
//  ChallengeCheckBuilder.swift
//  Challenge
//
//  Created by 문효재 on 2022/08/23.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

public protocol ChallengeCheckDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ChallengeCheckComponent: Component<ChallengeCheckDependency>, ChallengeCheckInteractorDependency {
    var usecase: ChallengeCheckUseCase
    
    override init(dependency: ChallengeCheckDependency) {
        usecase = ChallengeCheckUseCaseImpl()
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public protocol ChallengeCheckBuildable: Buildable {
    func build(withListener listener: ChallengeCheckListener) -> ChallengeCheckRouting
}

public final class ChallengeCheckBuilder: Builder<ChallengeCheckDependency>, ChallengeCheckBuildable {

    public override init(dependency: ChallengeCheckDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: ChallengeCheckListener) -> ChallengeCheckRouting {
        let component = ChallengeCheckComponent(dependency: dependency)
        let viewController = ChallengeCheckViewController()
        let interactor = ChallengeCheckInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return ChallengeCheckRouter(interactor: interactor, viewController: viewController)
    }
}
