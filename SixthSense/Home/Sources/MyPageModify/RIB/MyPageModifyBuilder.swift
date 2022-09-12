//
//  MyPageModifyBuilder.swift
//  Home
//
//  Created by Allie Kim on 2022/09/06.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import Repository

protocol MyPageModifyDependency: Dependency {
    var userRepository: UserRepository { get }
}

final class MyPageModifyComponent: Component<MyPageModifyDependency>, MyPageModifyInfoDependency {
    var userRepository: UserRepository { dependency.userRepository }
    var useCase: MyPageModifyUseCase { MyPageModifyUseCaseImpl(userRepository: dependency.userRepository) }
}

// MARK: - Builder

protocol MyPageModifyBuildable: Buildable {
    func build(withListener listener: MyPageModifyListener, userData: UserInfoPayload) -> MyPageModifyRouting
}

final class MyPageModifyBuilder: Builder<MyPageModifyDependency>, MyPageModifyBuildable {

    override init(dependency: MyPageModifyDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MyPageModifyListener, userData: UserInfoPayload) -> MyPageModifyRouting {
        let component = MyPageModifyComponent(dependency: dependency)
        let viewController = MyPageModifyViewController()
        let interactor = MyPageModifyInteractor(presenter: viewController, userPayload: userData, useCase: component.useCase)
        interactor.listener = listener

        let infoBuilder = MyPageModifyInfoBuilder(dependency: component)
        return MyPageModifyRouter(interactor: interactor, viewController: viewController, modifyInfoBuilder: infoBuilder)
    }
}
