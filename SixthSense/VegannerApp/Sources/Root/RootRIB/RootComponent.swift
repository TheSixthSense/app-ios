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
                           HomeDependency {
    var network: Network { dependency.network }
    var persistence: LocalPersistence { dependency.persistence }
    var userRepository: UserRepository { dependency.userRepository }
    var challengeRepository: ChallengeRepository { dependency.challengeRepository }
    
    override init(dependency: RootDependency) {
        
        super.init(dependency: dependency)
    }
}
