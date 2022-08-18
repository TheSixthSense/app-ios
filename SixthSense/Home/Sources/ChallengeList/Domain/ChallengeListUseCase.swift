//
//  ChallengeListUseCase.swift
//  Home
//
//  Created by 문효재 on 2022/08/18.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import RxSwift

protocol ChallengeListUseCase {
    func list(by date: Date) -> Observable<[ChallengeItem]>
}

struct ChallengeListUseCaseImpl: ChallengeListUseCase {
    func list(by date: Date) -> Observable<[ChallengeItem]> {
    }
}
