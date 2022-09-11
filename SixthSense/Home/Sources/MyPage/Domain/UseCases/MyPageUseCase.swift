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
    func isLoggedIn() -> Observable<Bool>

}
final class MyPageUseCaseImpl: MyPageUseCase {

    private let userRepository: UserRepository
    private let persistence: LocalPersistence

    init(userRepository: UserRepository, persistence: LocalPersistence) {
        self.userRepository = userRepository
        self.persistence = persistence
    }

    func fetchUserData() -> Observable<UserInfoModel> {
        return userRepository.info()
            .compactMap { UserInfoModel(JSONString: $0) }
            .asObservable()
    }

    func fetchUserChallengeStats() -> Observable<UserChallengeStatModel> {
        return userRepository.challengeStats()
            .compactMap { UserChallengeStatModel(JSONString: $0) }
            .asObservable()
    }

    func isLoggedIn() -> Observable<Bool> {
        guard let token: String = persistence.value(on: .accessToken) else { return .just(false) }
        return .just(!token.isEmpty)
    }

    func logout() -> Observable<Void> {
        return userRepository.logout()
            .do(onSuccess: { [weak self] _ in self?.persistence.delete(on: .accessToken) })
            .flatMap({ _ in .just(()) })
            .asObservable()
    }
}
