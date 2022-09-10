//
//  ChallengeCheckInteractor.swift
//  Challenge
//
//  Created by 문효재 on 2022/08/23.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import RxRelay
import UIKit

public protocol ChallengeCheckRouting: ViewableRouting {
}

protocol ChallengeCheckPresenterAction: AnyObject {
    var backDidTap: Observable<Void> { get }
    var imageDidLoaded: Observable<UIImage?> { get }
    var commentAvailable: Observable<Bool> { get }
    var doneDidTap: Observable<ChallengeCheckRequest> { get }
}

protocol ChallengeCheckPresenterHandler: AnyObject {
    var doneButtonActive: Observable<Bool> { get }
    var showDonePopUp: Observable<ChallengeCheckComplete> { get }
}

protocol ChallengeCheckPresentable: Presentable {
    var handler: ChallengeCheckPresenterHandler? { get set }
    var action: ChallengeCheckPresenterAction? { get set }
}

public protocol ChallengeCheckListener: AnyObject {
    func challengeCheckDidTapClose()
}

protocol ChallengeCheckInteractorDependency {
    var usecase: ChallengeCheckUseCase { get }
}

final class ChallengeCheckInteractor: PresentableInteractor<ChallengeCheckPresentable>,
                                        ChallengeCheckInteractable {

    weak var router: ChallengeCheckRouting?
    weak var listener: ChallengeCheckListener?
    private let dependency: ChallengeCheckInteractorDependency
    
    private let doneButtonActiveRelay: PublishRelay<Bool> = .init()
    private let showDonePopUpRelay: PublishRelay<ChallengeCheckComplete> = .init()

    init(presenter: ChallengeCheckPresentable,
         dependency: ChallengeCheckInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.handler = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        bind()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    private func bind() {
        guard let action = presenter.action else { return }
        action.backDidTap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.listener?.challengeCheckDidTapClose()
            })
            .disposeOnDeactivate(interactor: self)
        
        Observable.combineLatest(action.imageDidLoaded, action.commentAvailable) { ($0 != nil) && $1 }
            .withUnretained(self)
            .subscribe(onNext: { owner, available in
                owner.doneButtonActiveRelay.accept(available)
            })
            .disposeOnDeactivate(interactor: self)
        
        action.doneDidTap
            .withUnretained(self)
            .subscribe(onNext: { owner, request in
                owner.registerChallenge(request: request)
            })
            .disposeOnDeactivate(interactor: self)
    }
    
    private func registerChallenge(request: ChallengeCheckRequest) {
        dependency.usecase.register(request: request)
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                owner.showDonePopUpRelay.accept(response)
            })
            .disposeOnDeactivate(interactor: self)
    }
}

extension ChallengeCheckInteractor: ChallengeCheckPresenterHandler {
    var doneButtonActive: Observable<Bool> { doneButtonActiveRelay.asObservable() }
    var showDonePopUp: Observable<ChallengeCheckComplete> { showDonePopUpRelay.asObservable() }
}
