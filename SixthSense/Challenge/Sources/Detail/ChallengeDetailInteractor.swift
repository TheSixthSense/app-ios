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
    var deleteDidTap: Observable<Void> { get }
}

protocol ChallengeDetailPresenterHandler: AnyObject {
    var imageURL: Observable<URL?> { get }
    var date: Observable<Date> { get }
    var comment: Observable<String?> { get }
}

protocol ChallengeDetailPresentable: Presentable {
    var handler: ChallengeDetailPresenterHandler? { get set }
    var action: ChallengeDetailPresenterAction? { get set }
}

public protocol ChallengeDetailListener: AnyObject {
    func detailDidTapClose()
    func showToast(message: String)
}

protocol ChallengeDetailInteractorDependency {
    var usecase: ChallengeDetailUseCase { get }
}

final class ChallengeDetailInteractor: PresentableInteractor<ChallengeDetailPresentable>,
                                        ChallengeDetailInteractable {

    weak var router: ChallengeDetailRouting?
    weak var listener: ChallengeDetailListener?
    private let dependency: ChallengeDetailInteractorDependency
    private let id: String
    
    private let imageURLRelay: PublishRelay<URL?> = .init()
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
        fetch()
    }
    
    private func bind() {
        guard let action = presenter.action else { return }
        
        action.closeDidTap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.listener?.detailDidTapClose()
            })
            .disposeOnDeactivate(interactor: self)
        
        action.deleteDidTap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.delete()
            })
            .disposeOnDeactivate(interactor: self)
    }
    
    private func fetch() {
        dependency.usecase
            .fetch(id: id)
            .withUnretained(self)
            .subscribe(onNext: { owner, data in
                owner.imageURLRelay.accept(data.imageURL)
                owner.dateRelay.accept(data.date)
                owner.commentRelay.accept(data.text)
            })
            .disposeOnDeactivate(interactor: self)
    }
    
    private func delete() {
        dependency.usecase
            .delete(id: id)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.listener?.detailDidTapClose()
                owner.listener?.showToast(message: "인증글 삭제가 완료되었어요")
            })
            .disposeOnDeactivate(interactor: self)
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: - Handler
extension ChallengeDetailInteractor: ChallengeDetailPresenterHandler {
    var imageURL: Observable<URL?> { imageURLRelay.asObservable() }
    var date: Observable<Date> { dateRelay.asObservable() }
    var comment: Observable<String?> { commentRelay.asObservable() }
}
