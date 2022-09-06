//
//  MyPageBuilder.swift
//  Home
//
//  Created by Allie Kim on 2022/09/01.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol MyPageDependency: Dependency {
}

final class MyPageComponent: Component<MyPageDependency>, MyPageWebViewDependency {
}

// MARK: - Builder

protocol MyPageBuildable: Buildable {
    func build(withListener listener: MyPageListener) -> MyPageRouting
}

final class MyPageBuilder: Builder<MyPageDependency>, MyPageBuildable {

    override init(dependency: MyPageDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MyPageListener) -> MyPageRouting {
        let component = MyPageComponent(dependency: dependency)
        let viewController = MyPageViewController()
        let interactor = MyPageInteractor(presenter: viewController)
        interactor.listener = listener

        let myPageWebViewBuilder = MyPageWebViewBuilder(dependency: component)
        return MyPageRouter(interactor: interactor, viewController: viewController, myPageWebView: myPageWebViewBuilder)
    }
}
