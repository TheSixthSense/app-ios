//
//  UserRepository.swift
//  SixthSense
//
//  Created by 문효재 on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RxSwift

public protocol UserRepository: AnyObject {
    func user() -> Single<String>
    func login(request: LoginRequest) -> Single<Void>
    func validateNickname(request: String) -> Single<String>
    func signUp(request: SignUpRequest) -> Single<String>
}
