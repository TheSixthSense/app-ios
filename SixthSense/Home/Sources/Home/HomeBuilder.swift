//
//  HomeBuilder.swift
//  Home
//
//  Created by 문효재 on 2022/08/01.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import Challenge
import Repository
import Storage

public protocol HomeDependency: Dependency {
    var network: Network { get }
    var challengeRepository: ChallengeRepository { get }
    var userRepository: UserRepository { get }
    var persistence: LocalPersistence { get }
}

// MARK: - Builder

public protocol HomeBuildable: Buildable {
    func build(withListener listener: HomeListener) -> HomeRouting
}

public final class HomeBuilder: Builder<HomeDependency>, HomeBuildable {

    public override init(dependency: HomeDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: HomeListener) -> HomeRouting {
        let tabBar = RootTabBarController()
        let component = HomeComponent(
            dependency: dependency,
            rootViewController: tabBar
        )

        let interactor = HomeInteractor(presenter: tabBar)
        interactor.listener = listener

        let challenge = ChallengeBuilder(dependency: component)
        let mypage = MyPageBuilder(dependency: component)
        let challengeRegister = ChallengeRegisterBuilder(dependency: component)

        return HomeRouter(
            interactor: interactor,
            viewController: tabBar,
            challengeHome: challenge,
            challengeRegisterHome: challengeRegister,
            mypageHome: mypage)
    }
}
