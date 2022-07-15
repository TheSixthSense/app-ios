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

extension RootComponent: SplashDependency {
    var network: Network { dependency.network }
}
