//
//  ChallengeRecommendInteractor.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/16.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxCocoa
import RxSwift

protocol ChallengeRecommendRouting: ViewableRouting {
}

protocol ChallengeRecommendPresentable: Presentable {
    var handler: ChallengeRecommendPresenterHandler? { get set }
    var action: ChallengeRecommendPresenterAction? { get set }
}

protocol ChallengeRecommendPresenterAction: AnyObject {
    var viewWillAppear: Observable<Void> { get }
}

protocol ChallengeRecommendPresenterHandler: AnyObject {
    var sections: Observable<[RecommendSection]> { get }
}

protocol ChallengeRecommendListener: AnyObject {
}

final class ChallengeRecommendInteractor: PresentableInteractor<ChallengeRecommendPresentable>, ChallengeRecommendInteractable {

    weak var router: ChallengeRecommendRouting?
    weak var listener: ChallengeRecommendListener?

    private let sectionsRelay: PublishRelay<[RecommendSection]> = .init()

    override init(presenter: ChallengeRecommendPresentable) {
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

        action.viewWillAppear
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
            owner.makeListSections()
        }).disposeOnDeactivate(interactor: self)
    }

    // FIXME: - API
    private func makeListSections() {
        sectionsRelay.accept([
                .init(identity: .item, items: [.item("1"), .item("1"), .item("1")])
        ])
    }
}
extension ChallengeRecommendInteractor: ChallengeRecommendPresenterHandler {
    var sections: Observable<[RecommendSection]> { sectionsRelay.asObservable() }
}
