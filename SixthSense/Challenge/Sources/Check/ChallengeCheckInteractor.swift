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
    }
}

extension ChallengeCheckInteractor: ChallengeCheckPresenterHandler {
    var doneButtonActive: Observable<Bool> { doneButtonActiveRelay.asObservable() }
}

struct ChallengeCheckRequest {
    var image: UIImage?
    var text: String?
}
