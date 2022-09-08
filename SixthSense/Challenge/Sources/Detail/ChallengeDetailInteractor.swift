//
//  ChallengeDetailInteractor.swift
//  Challenge_Challenge
//
//  Created by 문효재 on 2022/09/07.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import RxRelay
import UIKit

public protocol ChallengeDetailRouting: ViewableRouting { }

protocol ChallengeDetailPresenterAction: AnyObject {
    var closeDidTap: Observable<Void> { get }
}

protocol ChallengeDetailPresenterHandler: AnyObject {
    var image: Observable<UIImage> { get }
    var date: Observable<Date> { get }
    var comment: Observable<String?> { get }
}

protocol ChallengeDetailPresentable: Presentable {
    var handler: ChallengeDetailPresenterHandler? { get set }
    var action: ChallengeDetailPresenterAction? { get set }
}

public protocol ChallengeDetailListener: AnyObject {
    func detailDidTapClose()
}

protocol ChallengeDetailInteractorDependency { }

final class ChallengeDetailInteractor: PresentableInteractor<ChallengeDetailPresentable>,
                                        ChallengeDetailInteractable {

    weak var router: ChallengeDetailRouting?
    weak var listener: ChallengeDetailListener?
    private let dependency: ChallengeDetailInteractorDependency
    private let id: String
    
    private let imageRelay: PublishRelay<UIImage> = .init()
    private let dateRelay: PublishRelay<Date> = .init()
    private let commentRelay: PublishRelay<String?> = .init()
    
    init(presenter: ChallengeDetailPresentable,
         dependency: ChallengeDetailInteractorDependency,
         id: String) {
        self.dependency = dependency
        self.id = id
        super.init(presenter: presenter)
        presenter.handler = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        bind()
    }
    
    private func bind() {
        guard let action = presenter.action else { return }
        
        action.closeDidTap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.listener?.detailDidTapClose()
            })
            .disposeOnDeactivate(interactor: self)
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: - Handler
extension ChallengeDetailInteractor: ChallengeDetailPresenterHandler {
    var image: Observable<UIImage> { imageRelay.asObservable() }
    var date: Observable<Date> { dateRelay.asObservable() }
    var comment: Observable<String?> { commentRelay.asObservable() }
}
