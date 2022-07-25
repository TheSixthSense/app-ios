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
import Repository

public protocol SignInUseCase {
    func continueWithApple() -> Observable<SignType>
}

public struct SignInUseCaseImpl: SignInUseCase {
    private let userRepository: UserRepository
    
    public init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }
    
    public func continueWithApple() -> Observable<SignType> {
        return requestAppleLogin()
            .compactMap(makePayload)
            .flatMap(signInIfNeeded)
    }
    
    private func requestAppleLogin() -> Observable<ASAuthorizationAppleIDCredential> {
        return Observable<ASAuthorizationAppleIDProvider>
            .just(ASAuthorizationAppleIDProvider())
            .flatMap { provider -> Observable<ASAuthorization> in
                return provider.rx.login(scope: [.fullName, .email])
            }
            .compactMap { $0.credential as? ASAuthorizationAppleIDCredential }
    }
    
    private func makePayload(_ credential: ASAuthorizationAppleIDCredential) -> Payload? {
        guard let identityToken = credential.identityToken,
              let token = String(data: identityToken, encoding: .utf8) else { return nil }
        return Payload(id: credential.user, token: token, email: credential.email)
    }
    
    private func signInIfNeeded(_ payload: Payload) -> Observable<SignType> {
        if shouldSignIn(payload) {
            return requestSignIn(payload)
        } else {
            return .just(.signUp)
        }
    }
    
    private func shouldSignIn(_ payload: Payload) -> Bool {
        return payload.email == nil
    }
        
    private func requestSignIn(_ payload: Payload) -> Observable<SignType> {
        let request = LoginRequest(appleID: payload.id)
        return self.userRepository.login(request: request)
            .asObservable()
            .map { _ in .signIn }
    }
}

// MARK: - Payload
extension SignInUseCaseImpl {
    struct Payload {
        var id: String
        var token: String
        var email: String?
    }
}

public enum SignType {
    case signIn
    case signUp
}
