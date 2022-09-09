//
//  UserChallengeRepository.swift
//  Repository
//
//  Created by 문효재 on 2022/09/09.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import RxSwift

public protocol UserChallengeRepository: AnyObject {
    func monthList(by date: String) -> Single<String>
    func dayList(by date: String) -> Single<String>
    func verify(request: ChallengeVerifyRequest) -> Single<String>
    func deleteVerify(id: Int) -> Single<String>
}

