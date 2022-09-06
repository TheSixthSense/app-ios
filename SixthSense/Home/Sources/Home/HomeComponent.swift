//
//  HomeComponent.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import Challenge
import Repository

final class HomeComponent: Component<HomeDependency>,
                            ChallengeDependency,
                            MyPageDependency,
                           ChallengeRegisterDependency {

    var challengeRegisterUseCase: ChallengeRegisterUseCase
    var challengeRepository: ChallengeRepository
    var network: Network
    private let rootViewController: ViewControllable

    init(dependency: HomeDependency,
         rootViewController: ViewControllable) {
        self.rootViewController = rootViewController
        self.network = dependency.network
        self.challengeRepository = dependency.challengeRepository
        self.challengeRegisterUseCase = ChallengeRegisterUseCaseImpl(challengeRepository: dependency.challengeRepository)
        super.init(dependency: dependency)
    }
}
