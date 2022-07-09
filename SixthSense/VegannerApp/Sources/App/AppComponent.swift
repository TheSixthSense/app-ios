//
//  AppComponent.swift
//  SixthSense
//
//  Created by Allie Kim on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

class AppComponent: Component<EmptyDependency>, RootDependency {

    var network: Network

    init() {
        self.network = NetworkImpl(intercepter: NetworkInterceptableImpl(), logger: SwiftyLogger())
        super.init(dependency: EmptyComponent())
    }
}

