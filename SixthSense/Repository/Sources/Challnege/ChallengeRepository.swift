//
//  ChallengeRepository.swift
//  Repository
//
//  Created by Allie Kim on 2022/08/21.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import RxSwift

public protocol ChallengeRepository: AnyObject {
    func registerLists() -> Single<String>
    func recommendLists(itemId: String) -> Single<String>
}
