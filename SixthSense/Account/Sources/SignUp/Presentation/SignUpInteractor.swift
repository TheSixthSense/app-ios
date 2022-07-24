//
//  SignUpInteractor.swift
//  VegannerApp
//
//  Created by Allie Kim on 2022/07/14.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import Foundation
import RxSwift
import RxRelay

public protocol SignUpRouting: ViewableRouting { }

protocol SignUpPresenterAction: AnyObject {
    var nicknameDidInput: Observable<String?> { get }
}

protocol SignUpPresenterHandler: AnyObject {
    var visibleNicknameValid: Observable<Bool> { get }
}


protocol SignUpPresentable: Presentable {
    var handler: SignUpPresenterHandler? { get set }
    var action: SignUpPresenterAction? { get set }
}

public protocol SignUpListener: AnyObject { }

final class SignUpInteractor: PresentableInteractor<SignUpPresentable>, SignUpInteractable {

    weak var router: SignUpRouting?
    weak var listener: SignUpListener?

    override init(presenter: SignUpPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}
