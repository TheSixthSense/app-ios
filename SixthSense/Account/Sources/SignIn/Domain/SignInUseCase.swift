//
//  SignInUseCase.swift
//  Account
//
//  Created by 문효재 on 2022/07/17.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import RxSwift
import AuthenticationServices

public protocol SignInUseCase {
    func continueWithApple() -> Observable<SignType>
}

public struct SignInUseCaseImpl: SignInUseCase {
    public init() { }
    
    public func signInWithApple() -> Observable<ASAuthorizationAppleIDCredential> {
        return Observable<ASAuthorizationAppleIDProvider>
            .just(ASAuthorizationAppleIDProvider())
            .flatMap { provider -> Observable<ASAuthorization> in
                return provider.rx.login(scope: [.fullName, .email])
            }
            .compactMap { $0.credential as? ASAuthorizationAppleIDCredential }
    }

public enum SignType {
    case signIn
    case signUp
}
