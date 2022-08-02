//
//  FeedBuilder.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol FeedDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class FeedComponent: Component<FeedDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol FeedBuildable: Buildable {
    func build(withListener listener: FeedListener) -> FeedRouting
}

final class FeedBuilder: Builder<FeedDependency>, FeedBuildable {

    override init(dependency: FeedDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FeedListener) -> FeedRouting {
        let component = FeedComponent(dependency: dependency)
        let viewController = FeedViewController()
        let interactor = FeedInteractor(presenter: viewController)
        interactor.listener = listener
        return FeedRouter(interactor: interactor, viewController: viewController)
    }
}
