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

protocol ChallengeCheckUseCase {
    func register(request: ChallengeCheckRequest) -> Observable<ChallengeCheckComplete>
}

final class ChallengeCheckUseCaseImpl: ChallengeCheckUseCase {
    func register(request: ChallengeCheckRequest) -> Observable<ChallengeCheckComplete> {
        return .just(.init(
            titleImageURL: URL(string: "https://user-images.githubusercontent.com/69489688/189118480-d6c79102-d678-4037-a1e5-0e0a4f4dd8bb.png"),
            contentsImageURL: URL(string: "https://user-images.githubusercontent.com/69489688/189118476-0915fdbf-0bcf-4cc8-b2f7-cc9fd1911443.png")))
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
