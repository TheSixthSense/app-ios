//
//  ChallengeListBuilder.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxRelay
import Foundation
import Challenge
import Repository
import Storage

protocol ChallengeListDependency: Dependency {
    var targetDate: PublishRelay<Date> { get }
    var userChallengeRepository: UserChallengeRepository { get }
    var persistence: LocalPersistence { get }
}

final class ChallengeListComponent: Component<ChallengeListDependency>,
                                    ChallengeListInteractorDependency,
                                    ChallengeCheckDependency,
                                    ChallengeDetailDependency {
    var userChallengeRepository: UserChallengeRepository { dependency.userChallengeRepository }
    
    var usecase: ChallengeListUseCase {
        ChallengeListUseCaseImpl(
            repository: dependency.userChallengeRepository,
            persistence: dependency.persistence
        )
    }
    var targetDate: PublishRelay<Date> { dependency.targetDate }
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
        let interactor = ChallengeListInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        let checkBuilder = ChallengeCheckBuilder(dependency: component)
        let detailBuilder = ChallengeDetailBuilder(dependency: component)

        return ChallengeListRouter(
            interactor: interactor,
            viewController: viewController,
            checkBuilder: checkBuilder,
            detailBuilder: detailBuilder)
    }
}
