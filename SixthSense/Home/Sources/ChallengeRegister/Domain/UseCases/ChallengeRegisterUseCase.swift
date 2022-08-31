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

public protocol ChallengeRegisterUseCase {
    func fetchChallengeCategories() -> Observable<[CategoryModel]>
    func fetchChallengeRegisterLists() -> Observable<[ChallengeRegisterModel]>
    func joinChallenge(request: ChallengeJoinRequest) -> Observable<String>
}

final class ChallengeRegisterUseCaseImpl: ChallengeRegisterUseCase {

    private let challengeRepository: ChallengeRepository

    init(challengeRepository: ChallengeRepository) {
        self.challengeRepository = challengeRepository
    }

    func fetchChallengeCategories() -> Observable<[CategoryModel]> {
        return challengeRepository.categoryLists()
            .compactMap({ DataModel<CategoryModel>(JSONString: $0)?.data }).asObservable()
    }

    func fetchChallengeRegisterLists() -> Observable<[ChallengeRegisterModel]> {
        return challengeRepository.registerLists()
            .compactMap({ DataModel<ChallengeRegisterModel>(JSONString: $0)?.data }).asObservable()
    }

    func joinChallenge(request: ChallengeJoinRequest) -> Observable<String> {
        return challengeRepository.joinChallenge(request: request).asObservable()
    }
}
