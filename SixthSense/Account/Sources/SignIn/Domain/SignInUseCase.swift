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
    func continueWithApple() -> Observable<Void>
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
    
    public func continueWithApple() -> Observable<Void> {
        return requestAppleLogin()
            .compactMap(makePayload)
            .do(onNext: { persistence.save(value: $0.id, on: .appleID) })
            .flatMap(requestSignIn)
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
    
    private func requestSignIn(_ info: SignInfo) -> Observable<Void> {
        let request = LoginRequest(appleID: info.id, clientSecret: info.token)
        return self.userRepository.login(request: request)
            .asObservable()
            .map { _ in () }
            .catch {  _ in
                return .error(SignInUseCaseError.signInError(.init(id: info.id, token: info.token)))
            }
    }
}

public enum SignInUseCaseError: Error {
    case signInError(SignInfo)
}

public struct SignInfo {
   public var id: String
   public var token: String
   public var email: String?
}
