//
//  MyPageUseCase.swift
//  Home
//
//  Created by Allie Kim on 2022/09/09.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import RxSwift
import Repository

public protocol MyPageUseCase {
    func fetchUserData() -> Observable<UserInfoModel>
    func fetchUserChallengeStats() -> Observable<UserChallengeStatModel>

}
final class MyPageUseCaseImpl: MyPageUseCase {

    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
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
}
