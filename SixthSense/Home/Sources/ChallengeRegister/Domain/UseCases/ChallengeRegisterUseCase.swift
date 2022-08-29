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
    func fetchChallengeCategories() -> Observable<String>
    func fetchChallengeRegisterLists() -> Observable<String>
}

final class ChallengeRegisterUseCaseImpl: ChallengeRegisterUseCase {
    private let challengeRepository: ChallengeRepository

    init(challengeRepository: ChallengeRepository) {
        self.challengeRepository = challengeRepository
    }

    func fetchChallengeCategories() -> Observable<String> {
        return challengeRepository.categoryLists().asObservable()
    }

    func fetchChallengeRegisterLists() -> Observable<String> {
        return challengeRepository.registerLists().asObservable()
    }
}
