//
//  RootComponent+Splash.swift
//  SixthSense
//
//  Created by Allie Kim on 2022/07/03.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import Repository
import Account
import Splash
import Storage
import Home

final class RootComponent: Component<RootDependency>,
                           SplashDependency,
                           SignInDependency,
                           HomeDependency,
                           RootInteractorDependency {
    
    var network: Network { dependency.network }
    var persistence: LocalPersistence { dependency.persistence }
    var userRepository: UserRepository { dependency.userRepository }
    var challengeRepository: ChallengeRepository { dependency.challengeRepository }
    var tokenService: AccessTokenService { dependency.tokenService }
    var usecase: RootUseCase
    
    override init(dependency: RootDependency) {
        self.usecase = RootUseCaseImpl(persistence: dependency.persistence)
        
        super.init(dependency: dependency)
    }
}
