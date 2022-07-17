//
//  AuthenticationService+Rx.swift
//  Account
//
//  Created by 문효재 on 2022/07/16.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RxSwift
import AuthenticationServices

@available(iOS 13.0, *)
extension Reactive where Base: ASAuthorizationAppleIDProvider {
    public func login(scope: [ASAuthorization.Scope]? = nil) -> Observable<ASAuthorization> {

        let request = base.createRequest()
        request.requestedScopes = scope

        let controller = ASAuthorizationController(authorizationRequests: [request])

        let proxy = ASAuthorizationControllerProxy.proxy(for: controller)

        controller.presentationContextProvider = proxy
        controller.performRequests()

        return proxy.didComplete
    }
}

@available(iOS 13.0, *)
extension Reactive where Base: ASAuthorizationAppleIDButton {
    public func login(scope: [ASAuthorization.Scope]? = nil) -> Observable<ASAuthorization> {
        return ASAuthorizationAppleIDProvider().rx.login(scope: scope)
    }
 }
