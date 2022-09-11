//
//  ChallengeCheckBuilder.swift
//  Challenge
//
//  Created by 문효재 on 2022/08/23.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import Repository

public protocol ChallengeCheckDependency: Dependency {
    var userChallengeRepository: UserChallengeRepository { get }
}

final class ChallengeCheckComponent: Component<ChallengeCheckDependency>, ChallengeCheckInteractorDependency {
    var usecase: ChallengeCheckUseCase
    
    override init(dependency: ChallengeCheckDependency) {
        usecase = ChallengeCheckUseCaseImpl(repository: dependency.userChallengeRepository)
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public protocol ChallengeCheckBuildable: Buildable {
    func build(withListener listener: ChallengeCheckListener, id: Int) -> ChallengeCheckRouting
}

public final class ChallengeCheckBuilder: Builder<ChallengeCheckDependency>, ChallengeCheckBuildable {

    public override init(dependency: ChallengeCheckDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: ChallengeCheckListener, id: Int) -> ChallengeCheckRouting {
        let component = ChallengeCheckComponent(dependency: dependency)
        let viewController = ChallengeCheckViewController()
        let interactor = ChallengeCheckInteractor(presenter: viewController,
                                                  id: id,
                                                  dependency: component)
        interactor.listener = listener
        return ChallengeCheckRouter(interactor: interactor, viewController: viewController)
    }
}
