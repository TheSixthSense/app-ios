//
//  ChallengeRegisterBuilder.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import Challenge
import Foundation
import RxRelay
import Repository

public protocol ChallengeRegisterDependency: Dependency {
    var challengeRepository: ChallengeRepository { get }
    var targetDate: PublishRelay<Date> { get }
}

public final class ChallengeRegisterComponent: Component<ChallengeRegisterDependency>,
                                                 ChallengeRecommendDependency {
    public var challengeRepository: ChallengeRepository { dependency.challengeRepository }
    public var targetDate: PublishRelay<Date> { dependency.targetDate }
    var useCase: ChallengeRegisterUseCase { ChallengeRegisterUseCaseImpl(challengeRepository: dependency.challengeRepository) }
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
                                                     dependency: component)
        interactor.listener = listener

        let recommendBuilder = ChallengeRecommendBuilder(dependency: component)
        return ChallengeRegisterRouter(interactor: interactor,
                                       viewController: viewController,
                                       recommendBuilder: recommendBuilder)
    }
}
