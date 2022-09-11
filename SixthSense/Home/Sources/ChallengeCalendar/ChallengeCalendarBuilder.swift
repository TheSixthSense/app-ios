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
import Repository

protocol ChallengeCalendarDependency: Dependency {
    var targetDate: PublishRelay<Date> { get }
    var userChallengeRepository: UserChallengeRepository { get }
}

final class ChallengeCalendarComponent: Component<ChallengeCalendarDependency>,
                                        ChallengeCalendarInteractorDependency{
    var usecase: ChallengeCalendarUseCase
    var targetDate: PublishRelay<Date> { dependency.targetDate }
    
    override init(dependency: ChallengeCalendarDependency) {
        self.usecase = ChallengeCalendarUsCaseImpl(
            repository: dependency.userChallengeRepository)
        super.init(dependency: dependency)
    }
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
