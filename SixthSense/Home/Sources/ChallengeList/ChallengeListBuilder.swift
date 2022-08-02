//
//  ChallengeListBuilder.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol ChallengeListDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ChallengeListComponent: Component<ChallengeListDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ChallengeListBuildable: Buildable {
    func build(withListener listener: ChallengeListListener) -> ChallengeListRouting
}

final class ChallengeListBuilder: Builder<ChallengeListDependency>, ChallengeListBuildable {

    override init(dependency: ChallengeListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ChallengeListListener) -> ChallengeListRouting {
        let component = ChallengeListComponent(dependency: dependency)
        let viewController = ChallengeListViewController()
        let interactor = ChallengeListInteractor(presenter: viewController)
        interactor.listener = listener
        return ChallengeListRouter(interactor: interactor, viewController: viewController)
    }
}
