//
//  ChallengeRecommendBuilder.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/16.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import Repository

public protocol ChallengeRecommendDependency: Dependency {
    var network: Network { get }
    var challengeRepository: ChallengeRepository { get }
}

final class ChallengeRecommendComponent: Component<ChallengeRecommendDependency> {
    var useCase: ChallengeRecommendUseCase

    override init(dependency: ChallengeRecommendDependency) {
        self.useCase = ChallengeRecommendUseCaseImpl(challengeRepository: dependency.challengeRepository)
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public protocol ChallengeRecommendBuildable: Buildable {
    func build(withListener listener: ChallengeRecommendListener,
               selectedChallengeId: String) -> ChallengeRecommendRouting
}

public final class ChallengeRecommendBuilder: Builder<ChallengeRecommendDependency>, ChallengeRecommendBuildable {

    public override init(dependency: ChallengeRecommendDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: ChallengeRecommendListener,
                      selectedChallengeId: String) -> ChallengeRecommendRouting {
        let component = ChallengeRecommendComponent(dependency: dependency)
        let viewController = ChallengeRecommendViewController()
        let interactor = ChallengeRecommendInteractor(presenter: viewController,
                                                      component: component,
                                                      selectedChallengeId: selectedChallengeId)
        interactor.listener = listener
        return ChallengeRecommendRouter(interactor: interactor, viewController: viewController)
    }
}
