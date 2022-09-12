//
//  UserRepository.swift
//  SixthSense
//
//  Created by 문효재 on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RxSwift

public protocol UserRepository: AnyObject {
    func login(request: LoginRequest) -> Single<Void>
    func validateNickname(request: String) -> Single<String>
    func signUp(request: SignUpRequest) -> Single<String>
    func info() -> Single<String>
    func modifyUserInfo(request: UserInfoRequest) -> Single<String>
    func challengeStats() -> Single<String>
    func logout() -> Single<String>
    func withdraw() -> Single<String>
}
