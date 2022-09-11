//
//  ChallengeDetailBuilder.swift
//  Challenge_Challenge
//
//  Created by 문효재 on 2022/09/07.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

public protocol ChallengeDetailDependency: Dependency { }

final class ChallengeDetailComponent: Component<ChallengeDetailDependency>,
                                      ChallengeDetailInteractorDependency {
    var usecase: ChallengeDetailUseCase
    
    override init(dependency: ChallengeDetailDependency) {
        usecase = ChallengeDetailUseCaseImpl()
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public protocol ChallengeDetailBuildable: Buildable {
    func build(withListener listener: ChallengeDetailListener, payload: ChallengeDetailPayload) -> ChallengeDetailRouting
}

public final class ChallengeDetailBuilder: Builder<ChallengeDetailDependency>, ChallengeDetailBuildable {

    public override init(dependency: ChallengeDetailDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: ChallengeDetailListener, payload: ChallengeDetailPayload) -> ChallengeDetailRouting {
        let component = ChallengeDetailComponent(dependency: dependency)
        let viewController = ChallengeDetailViewController()
        let interactor = ChallengeDetailInteractor(presenter: viewController,
                                                   dependency: component,
                                                   payload: payload)
        interactor.listener = listener
        return ChallengeDetailRouter(interactor: interactor, viewController: viewController)
    }
}
