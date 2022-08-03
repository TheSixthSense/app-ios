//
//  ChallengeCalendarBuilder.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol ChallengeCalendarDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ChallengeCalendarComponent: Component<ChallengeCalendarDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ChallengeCalendarBuildable: Buildable {
    func build(withListener listener: ChallengeCalendarListener) -> ChallengeCalendarRouting
}

final class ChallengeCalendarBuilder: Builder<ChallengeCalendarDependency>, ChallengeCalendarBuildable {

    override init(dependency: ChallengeCalendarDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ChallengeCalendarListener) -> ChallengeCalendarRouting {
        let component = ChallengeCalendarComponent(dependency: dependency)
        let viewController = ChallengeCalendarViewController()
        let interactor = ChallengeCalendarInteractor(presenter: viewController)
        interactor.listener = listener
        return ChallengeCalendarRouter(interactor: interactor, viewController: viewController)
    }
}
