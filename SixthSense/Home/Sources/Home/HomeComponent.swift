//
//  HomeComponent.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

final class HomeComponent: Component<HomeDependency>,
                           ChallengeDependency,
                           FeedDependency {
    
    private let rootViewController: ViewControllable

    init(dependency: HomeDependency,
         rootViewController: ViewControllable) {
        self.rootViewController = rootViewController
        super.init(dependency: dependency)
    }
}
