//
//  MyPageBuilder.swift
//  Home
//
//  Created by Allie Kim on 2022/09/01.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import Storage
import Repository

protocol MyPageDependency: Dependency {
    var userRepository: UserRepository { get }
    var persistence: LocalPersistence { get }
}

final class MyPageComponent: Component<MyPageDependency>, MyPageModifyDependency, MyPageWebViewDependency {
    var userRepository: UserRepository { dependency.userRepository }
    var myPageUseCase: MyPageUseCase
    var userInfoPayload: UserInfoPayload
    var persistence: LocalPersistence

    override init(dependency: MyPageDependency) {
        self.userInfoPayload = UserInfoPayload.init()
        myPageUseCase = MyPageUseCaseImpl(userRepository: dependency.userRepository,
                                          persistence: dependency.persistence)
        persistence = dependency.persistence
        super.init(dependency: dependency)
    }
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
        let interactor = MyPageInteractor(presenter: viewController, component: component)
        interactor.listener = listener

        let myPageWebViewBuilder = MyPageWebViewBuilder(dependency: component)
        let myPageModifyBuilder = MyPageModifyBuilder(dependency: component)
        return MyPageRouter(interactor: interactor, viewController: viewController, mypageModifyView: myPageModifyBuilder, myPageWebView: myPageWebViewBuilder)
    }
}
