//
//  ChallengeCalendarBuilder.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxRelay
import Foundation

protocol ChallengeCalendarDependency: Dependency {
    var targetDate: PublishRelay<Date> { get }
}

final class ChallengeCalendarComponent: Component<ChallengeCalendarDependency>,
                                        ChallengeCalendarInteractorDependency{
    var targetDate: PublishRelay<Date> { dependency.targetDate }
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
        let interactor = ChallengeCalendarInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return ChallengeCalendarRouter(interactor: interactor, viewController: viewController)
    }
}
