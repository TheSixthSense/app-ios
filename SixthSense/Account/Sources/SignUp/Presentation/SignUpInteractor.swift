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
    
    private let visibleNicknameValidRelay: BehaviorRelay<Bool> = .init(value: false)

    override init(presenter: SignUpPresentable) {
        super.init(presenter: presenter)
        presenter.handler = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.bind()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func bind() {
        guard let action = presenter.action else { return }

        action.nicknameDidInput
            .debug("😀")
            .skip(1)
            .subscribe(onNext: { [weak self] in
                guard let text = $0, !text.isEmpty else {
                    self?.visibleNicknameValidRelay.accept(true)
                    return
                }
            
                let isValid = self?.isValidNickname(text) ?? false
                self?.visibleNicknameValidRelay.accept(isValid)

                // Data에 저장
                
            })
            .disposeOnDeactivate(interactor: self)
    }
    
    private func isValidNickname(_ nickname: String) -> Bool {
        let nicknameRegex = "^[ㄱ-ㅎ|가-힣|a-z|A-Z|0-9]+$"
        let nicknameTest = NSPredicate(format: "SELF MATCHES %@",
                                       nicknameRegex)
        return nicknameTest.evaluate(with: nickname)
    }
}

extension SignUpInteractor: SignUpPresenterHandler {
    var visibleNicknameValid: Observable<Bool> {
        return visibleNicknameValidRelay.asObservable()
    }
}
