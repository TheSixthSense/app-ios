//
//  ASAuthorizationControllerProxy.swift
//  Account
//
//  Created by 문효재 on 2022/07/16.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import AuthenticationServices
import UIKit

import RxSwift
import RxCocoa

@available(iOS 13.0, *)
extension ASAuthorizationController: HasDelegate {
    public typealias Delegate = ASAuthorizationControllerDelegate
}


@available(iOS 13.0, *)
class ASAuthorizationControllerProxy: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate>, DelegateProxyType, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    var presentationWindow: UIWindow = UIWindow()

    public init(controller: ASAuthorizationController) {
        super.init(parentObject: controller, delegateProxy: ASAuthorizationControllerProxy.self)
    }

    // MARK: - DelegateProxyType

    public static func registerKnownImplementations() {
        self.register { ASAuthorizationControllerProxy(controller: $0) }
    }

// MARK: - Proxy Subject

    internal lazy var didComplete = PublishSubject<ASAuthorization>()

    // MARK: - ASAuthorizationConrollerDelegate

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        didComplete.onNext(authorization)
        didComplete.onCompleted()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        didComplete.onCompleted()
    }


    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return presentationWindow
    }

    // MARK: - Completed

    deinit {
        self.didComplete.onCompleted()
    }
}
