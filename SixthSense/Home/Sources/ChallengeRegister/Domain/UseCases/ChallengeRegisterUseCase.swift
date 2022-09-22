//
//  ChallengeRegisterUseCase.swift
//  Home
//
//  Created by Allie Kim on 2022/08/21.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import RxSwift
import Repository
import Storage

public protocol ChallengeRegisterUseCase {
    func fetchChallengeCategories() -> Observable<[CategoryModel]>
    func fetchChallengeRegisterLists() -> Observable<[ChallengeRegisterModel]>
    func joinChallenge(request: ChallengeJoinRequest) -> Observable<String>
    func isLoggedIn() -> Bool
}

final class ChallengeRegisterUseCaseImpl: ChallengeRegisterUseCase {

    private let challengeRepository: ChallengeRepository
    private let persistence: LocalPersistence

    init(challengeRepository: ChallengeRepository,
         persistence: LocalPersistence) {
        self.challengeRepository = challengeRepository
        self.persistence = persistence
    }

    func fetchChallengeCategories() -> Observable<[CategoryModel]> {
        guard isLoggedIn() else { return .empty() }
        return challengeRepository.categoryLists()
            .compactMap({ DataModel<CategoryModel>(JSONString: $0)?.data }).asObservable()
    }

    func fetchChallengeRegisterLists() -> Observable<[ChallengeRegisterModel]> {
        guard isLoggedIn() else { return .empty() }
        return challengeRepository.registerLists()
            .compactMap({ DataModel<ChallengeRegisterModel>(JSONString: $0)?.data }).asObservable()
    }

    func joinChallenge(request: ChallengeJoinRequest) -> Observable<String> {
        return challengeRepository.joinChallenge(request: request).asObservable()
    }

    func isLoggedIn() -> Bool {
        guard let token: String = persistence.value(on: .accessToken) else { return false }
        return !token.isEmpty
    }
}
