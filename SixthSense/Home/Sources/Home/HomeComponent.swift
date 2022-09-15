//
//  HomeComponent.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import Challenge
import RxRelay
import Foundation
import Repository
import Storage

final class HomeComponent: Component<HomeDependency>,
                            ChallengeDependency,
                            MyPageDependency,
                            ChallengeRegisterDependency {

    var challengeRegisterUseCase: ChallengeRegisterUseCase
    var userChallengeRepository: UserChallengeRepository
    var challengeRepository: ChallengeRepository
    var userRepository: UserRepository
    var network: Network
    var targetDate: PublishRelay<Date>
    var persistence: LocalPersistence { dependency.persistence }
    private let rootViewController: ViewControllable

    init(dependency: HomeDependency,
         rootViewController: ViewControllable) {
        self.rootViewController = rootViewController
        self.network = dependency.network
        self.userRepository = dependency.userRepository
        self.challengeRepository = dependency.challengeRepository
        self.userChallengeRepository = UserChallengeRepositoryImpl(network: dependency.network)
        self.targetDate = .init()
        self.challengeRegisterUseCase = ChallengeRegisterUseCaseImpl(challengeRepository: dependency.challengeRepository)
        super.init(dependency: dependency)
    }
}
