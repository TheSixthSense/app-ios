//
//  MyPageWebViewBuilder.swift
//  Home
//
//  Created by Allie Kim on 2022/09/06.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol MyPageWebViewDependency: Dependency {
}

final class MyPageWebViewComponent: Component<MyPageWebViewDependency> {
}

// MARK: - Builder

protocol MyPageWebViewBuildable: Buildable {
    func build(withListener listener: MyPageWebViewListener, urlString: String, titleString: String) -> MyPageWebViewRouting
}

final class MyPageWebViewBuilder: Builder<MyPageWebViewDependency>, MyPageWebViewBuildable {

    override init(dependency: MyPageWebViewDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MyPageWebViewListener, urlString: String, titleString: String) -> MyPageWebViewRouting {
        let component = MyPageWebViewComponent(dependency: dependency)
        let viewController = MyPageWebViewViewController.init(urlString: urlString, titleString: titleString)
        let interactor = MyPageWebViewInteractor(presenter: viewController)
        interactor.listener = listener
        return MyPageWebViewRouter(interactor: interactor, viewController: viewController)
    }
}
