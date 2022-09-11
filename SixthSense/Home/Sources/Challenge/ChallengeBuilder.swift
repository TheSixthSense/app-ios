//
//  ChallengeBuilder.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxRelay
import Foundation
import Repository
import Storage

protocol ChallengeDependency: Dependency {
    var userChallengeRepository: UserChallengeRepository { get }
    var targetDate: PublishRelay<Date> { get }
    var persistence: LocalPersistence { get }
}

final class ChallengeComponent: Component<ChallengeDependency>,
                                ChallengeCalendarDependency,
                                ChallengeListDependency{
    var targetDate: PublishRelay<Date> { dependency.targetDate }
    var userChallengeRepository: UserChallengeRepository {
        dependency.userChallengeRepository
    }
    var persistence: LocalPersistence { dependency.persistence }
}

// MARK: - Builder

protocol ChallengeBuildable: Buildable {
    func build(withListener listener: ChallengeListener) -> ChallengeRouting
}

final class ChallengeBuilder: Builder<ChallengeDependency>, ChallengeBuildable {

    override init(dependency: ChallengeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ChallengeListener) -> ChallengeRouting {
        let viewController = ChallengeViewController()
        let component = ChallengeComponent(dependency: dependency)
        let interactor = ChallengeInteractor(presenter: viewController)
        interactor.listener = listener
        
        let calendarBuilder = ChallengeCalendarBuilder(dependency: component)
        let listBuilder = ChallengeListBuilder(dependency: component)
        
        return ChallengeRouter(
            interactor: interactor,
            viewController: viewController,
            calendarBuildable: calendarBuilder,
            listBuildable: listBuilder)
    }
}
