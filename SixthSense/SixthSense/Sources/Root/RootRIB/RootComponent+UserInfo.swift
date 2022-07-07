//
//  RootComponent+UserInfo.swift
//  SixthSense
//
//  Created by Allie Kim on 2022/07/03.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

extension RootComponent: UserInfoDependency {

    var network: Network {
        return self.dependency.network
    }
}
