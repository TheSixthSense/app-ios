//
//  MyPageModifyBuilder.swift
//  Home
//
//  Created by Allie Kim on 2022/09/06.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs

protocol MyPageModifyDependency: Dependency {
}

final class MyPageModifyComponent: Component<MyPageModifyDependency> {
}

// MARK: - Builder

protocol MyPageModifyBuildable: Buildable {
    func build(withListener listener: MyPageModifyListener) -> MyPageModifyRouting
}

final class MyPageModifyBuilder: Builder<MyPageModifyDependency>, MyPageModifyBuildable {

    override init(dependency: MyPageModifyDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MyPageModifyListener) -> MyPageModifyRouting {
        let component = MyPageModifyComponent(dependency: dependency)
        let viewController = MyPageModifyViewController()
        let interactor = MyPageModifyInteractor(presenter: viewController)
        interactor.listener = listener
        return MyPageModifyRouter(interactor: interactor, viewController: viewController)
    }
}
