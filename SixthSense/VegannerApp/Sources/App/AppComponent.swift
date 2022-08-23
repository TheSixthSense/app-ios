//
//  AppComponent.swift
//  SixthSense
//
//  Created by Allie Kim on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import Repository
import Utils
import Storage
import Foundation

class AppComponent: Component<EmptyDependency>, RootDependency {
    var network: Network
    var persistence: LocalPersistence
    var tokenService: AccessTokenService
    var userRepository: UserRepository
    var challengeRepository: ChallengeRepository

    init() {
        self.network = NetworkImpl(intercepter: NetworkInterceptableImpl(), plugins: [RequestLoggingPlugin(logger: SwiftyLogger())])
        self.persistence = LocalPersistenceImpl(source: UserDefaults.standard)
        self.tokenService = AccessTokenServiceImpl(network: network, persistence: persistence)
        self.userRepository = UserRepositoryImpl(network: network, tokenService: tokenService)
        self.challengeRepository = ChallengeRepositoryImpl(network: network)
        super.init(dependency: EmptyComponent())
    }
}

