//
//  ChallengeDetailUseCase.swift
//  Challenge
//
//  Created by 문효재 on 2022/09/08.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import RxSwift
import Repository

protocol ChallengeDetailUseCase {
    func delete(id: Int) -> Observable<Void>
}

final class ChallengeDetailUseCaseImpl: ChallengeDetailUseCase {
    private let repository: UserChallengeRepository
    
    init(repository: UserChallengeRepository) {
        self.repository = repository
    }
    
    func delete(id: Int) -> Observable<Void> {
        return repository.deleteVerify(id: id)
            .asObservable()
            .flatMap { _ -> Observable<Void> in
                return .just(())
            }
    }
}
