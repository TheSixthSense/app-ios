//
//  ChallengeCheckUseCase.swift
//  Challenge
//
//  Created by 문효재 on 2022/09/05.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import RxSwift
import UIKit
import Repository

protocol ChallengeCheckUseCase {
    func register(id: Int, request: ChallengeCheckRequest) -> Observable<ChallengeCheckComplete>
}

final class ChallengeCheckUseCaseImpl: ChallengeCheckUseCase {
    private let repository: UserChallengeRepository
    
    init(repository: UserChallengeRepository) {
        self.repository = repository
    }
    
    func register(id: Int, request: ChallengeCheckRequest) -> Observable<ChallengeCheckComplete> {
        let request: ChallengeVerifyRequest = .init(id: id,
                                                    image: request.image,
                                                    text: request.text)
        
        return repository.verify(request: request)
            .asObservable()
            .compactMap { Response<ChallengeCheck>(JSONString: $0) }
            .map(\.data)
            .flatMap { response -> Observable<ChallengeCheckComplete> in
                dump(response)
                return .just(.init(
                    titleImageURL: URL(string: response.titleImage),
                    contentsImageURL: URL(string: response.contentImage)))
            }
    }
}

struct ChallengeCheckRequest {
    var image: UIImage?
    var text: String?
}

struct ChallengeCheckComplete {
    var titleImageURL: URL?
    var contentsImageURL: URL?
}
