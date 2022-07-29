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
import Storage

public protocol SignInUseCase {
    func continueWithApple() -> Observable<SignType>
}

public struct SignInUseCaseImpl: SignInUseCase {
    private let userRepository: UserRepository
    private let persistence: LocalPersistence
    
    public init(
        userRepository: UserRepository,
        persistence: LocalPersistence
    ) {
        self.userRepository = userRepository
        self.persistence = persistence
    }
    
    public func continueWithApple() -> Observable<SignType> {
        return requestAppleLogin()
            .compactMap(makePayload)
            .do(onNext: { persistence.save(value: $0.id, on: .appleID) })
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
    
    private func makePayload(_ credential: ASAuthorizationAppleIDCredential) -> SignInfo? {
        guard let identityToken = credential.identityToken,
              let token = String(data: identityToken, encoding: .utf8) else { return nil }
        return SignInfo(id: credential.user, token: token, email: credential.email)
    }
    
    private func signInIfNeeded(_ info: SignInfo) -> Observable<SignType> {
        if shouldSignIn(info) {
            return requestSignIn(info)
        } else {
            return .just(.signUp(info))
        }
    }
    
    private func shouldSignIn(_ info: SignInfo) -> Bool {
        return info.email == nil
    }
        
    private func requestSignIn(_ info: SignInfo) -> Observable<SignType> {
        let request = LoginRequest(appleID: info.id, clientSecret: info.token)
        return self.userRepository.login(request: request)
            .debug("😀")
            .asObservable()
            .do(onNext: {
                print("🦊 \($0)")
            })
            .map { _ in .signIn }
    }
    
//    private func saveAccessToken(token: )
}

public enum SignType {
    case signIn
    case signUp(SignInfo)
}

public struct SignInfo {
   public var id: String
   public var token: String
   public var email: String?
}
