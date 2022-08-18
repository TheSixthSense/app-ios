//
//  ChallengeRecommendBuilder.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/16.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

public protocol ChallengeRecommendDependency: Dependency {
}

final class ChallengeRecommendComponent: Component<ChallengeRecommendDependency> {
}

// MARK: - Builder

public protocol ChallengeRecommendBuildable: Buildable {
    func build(withListener listener: ChallengeRecommendListener) -> ChallengeRecommendRouting
}

public final class ChallengeRecommendBuilder: Builder<ChallengeRecommendDependency>, ChallengeRecommendBuildable {

    public override init(dependency: ChallengeRecommendDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: ChallengeRecommendListener) -> ChallengeRecommendRouting {
        let component = ChallengeRecommendComponent(dependency: dependency)
        let viewController = ChallengeRecommendViewController()
        let interactor = ChallengeRecommendInteractor(presenter: viewController)
        interactor.listener = listener
        return ChallengeRecommendRouter(interactor: interactor, viewController: viewController)
    }
}
