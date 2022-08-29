//
//  ChallengeRecommendUseCase.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/28.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import RxSwift
import Repository

public protocol ChallengeRecommendUseCase {
    func fetchChallengeRecommendLists(itemId: String) -> Observable<[ChallengeRecommendModel]>
}

final class ChallengeRecommendUseCaseImpl: ChallengeRecommendUseCase {
    private let challengeRepository: ChallengeRepository

    init(challengeRepository: ChallengeRepository) {
        self.challengeRepository = challengeRepository
    }

    func fetchChallengeRecommendLists(itemId: String) -> Observable<[ChallengeRecommendModel]> {
        return challengeRepository.recommendLists(itemId: itemId)
            .compactMap({ DataModel(JSONString: $0)?.data }).asObservable()
    }
}
