//
//  SignUpUseCase.swift
//  Account
//
//  Created by Allie Kim on 2022/07/28.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift
import Repository

public protocol SignUpUseCase {
    func validateUserNickname(request: String) -> Observable<String>
    func fetchSignUp(reqeust: SignUpRequest) -> Observable<String>
}

final class SignUpUseCaseImpl: SignUpUseCase {

    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func validateUserNickname(request: String) -> Observable<String> {
        return userRepository.validateNickname(request: request)
            .asObservable()
    }

    func fetchSignUp(reqeust: SignUpRequest) -> Observable<String> {
        return userRepository.signUp(request: reqeust).debug().asObservable()
    }

}
