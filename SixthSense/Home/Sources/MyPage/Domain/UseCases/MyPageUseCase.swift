//
//  MyPageUseCase.swift
//  Home
//
//  Created by Allie Kim on 2022/09/09.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import RxSwift
import Storage
import Repository

public protocol MyPageUseCase {
    func fetchUserData() -> Observable<UserInfoModel>
    func fetchUserChallengeStats() -> Observable<UserChallengeStatModel>
    func logout() -> Observable<Void>
    func isLoggedIn() -> Bool

}
final class MyPageUseCaseImpl: MyPageUseCase {

    private let userRepository: UserRepository
    private let persistence: LocalPersistence

    init(userRepository: UserRepository, persistence: LocalPersistence) {
        self.userRepository = userRepository
        self.persistence = persistence
    }

    func fetchUserData() -> Observable<UserInfoModel> {
        guard isLoggedIn() else { return .empty() }
        return userRepository.info()
            .compactMap { UserInfoModel(JSONString: $0) }
            .asObservable()
    }

    func fetchUserChallengeStats() -> Observable<UserChallengeStatModel> {
        guard isLoggedIn() else { return .empty() }
        return userRepository.challengeStats()
            .compactMap { UserChallengeStatModel(JSONString: $0) }
            .asObservable()
    }

    func isLoggedIn() -> Bool {
        guard let token: String = persistence.value(on: .accessToken) else { return false }
        return !token.isEmpty
    }

    func logout() -> Observable<Void> {
        return userRepository.logout()
            .asObservable()
            .do(onNext: { [weak self] _ in
                self?.persistence.delete(on: .appleID)
                self?.persistence.delete(on: .accessToken)
                self?.persistence.delete(on: .refreshToken)

            })
            .map { _ in () }
    }
}
