//
//  ChallengeRegisterBuilder.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import Challenge
import Repository

public protocol ChallengeRegisterDependency: Dependency {
    var network: Network { get }
    var challengeRepository: ChallengeRepository { get }
    var challengeRegisterUseCase: ChallengeRegisterUseCase { get }
}

public final class ChallengeRegisterComponent: Component<ChallengeRegisterDependency>,
    ChallengeRecommendDependency {
//    var useCase: ChallengeRegisterUseCase
//    var network: Network { dependency.network }
//
//    override init(dependency: ChallengeRegisterDependency) {
//        self.useCase = ChallengeRegisterUseCaseImpl(challengeRepository: dependency.challengeRepository)
//        super.init(dependency: dependency)
//    }
}

// MARK: - Builder

public protocol ChallengeRegisterBuildable: Buildable {
    func build(withListener listener: ChallengeRegisterListener) -> ChallengeRegisterRouting
}

public final class ChallengeRegisterBuilder: Builder<ChallengeRegisterDependency>, ChallengeRegisterBuildable {

    public override init(dependency: ChallengeRegisterDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: ChallengeRegisterListener) -> ChallengeRegisterRouting {
        let component = ChallengeRegisterComponent(dependency: dependency)
        let viewController = ChallengeRegisterViewController()
        let interactor = ChallengeRegisterInteractor(presenter: viewController,
                                                     dependency: dependency)
        interactor.listener = listener

        let recommendBuilder = ChallengeRecommendBuilder(dependency: component)
        return ChallengeRegisterRouter(interactor: interactor,
                                       viewController: viewController,
                                       recommendBuilder: recommendBuilder)
    }
}
