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

public protocol ChallengeRecommendRouting: ViewableRouting { }

protocol ChallengeRecommendPresentable: Presentable {
    var handler: ChallengeRecommendPresenterHandler? { get set }
    var action: ChallengeRecommendPresenterAction? { get set }
}

protocol ChallengeRecommendPresenterAction: AnyObject {
    var doneButtonDidTap: Observable<Void> { get }
}

protocol ChallengeRecommendPresenterHandler: AnyObject {
    var sections: Observable<[RecommendSection]> { get }
}

public protocol ChallengeRecommendListener: AnyObject {
    func returnToHome()
}

final class ChallengeRecommendInteractor: PresentableInteractor<ChallengeRecommendPresentable>, ChallengeRecommendInteractable {

    weak var router: ChallengeRecommendRouting?
    weak var listener: ChallengeRecommendListener?

    private let dependency: ChallengeRecommendComponent
    private let sectionsRelay: PublishRelay<[RecommendSection]> = .init()

    private let selectedChallengeId: String

    init(presenter: ChallengeRecommendPresentable,
         component: ChallengeRecommendComponent,
         selectedChallengeId: String) {
        self.dependency = component
        self.selectedChallengeId = selectedChallengeId
        super.init(presenter: presenter)
        presenter.handler = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        makeListSections()
        bind()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    private func bind() {

        guard let action = presenter.action else { return }

        action.doneButtonDidTap
            .withUnretained(self)
            .bind(onNext: { owner, _ in
            owner.listener?.returnToHome()
        }).disposeOnDeactivate(interactor: self)
    }

    private func makeListSections() {

        dependency.useCase.fetchChallengeRecommendLists(itemId: selectedChallengeId)
            .catch({ error in
            return .empty()
        })
            .debug()
            .compactMap({ $0.compactMap { ChallengeRecommendViewModel(model: $0) }.sorted(by: <) })
            .withUnretained(self)
            .subscribe(onNext: { owner, data in

            let sections: [RecommendSection] = [
                    .init(identity: .item,
                          items: data.compactMap(RecommendSectionItem.init))
            ]

            owner.sectionsRelay.accept(sections)
        })
            .disposeOnDeactivate(interactor: self)
    }
}

extension ChallengeRecommendInteractor: ChallengeRecommendPresenterHandler {
    var sections: Observable<[RecommendSection]> { sectionsRelay.asObservable() }
}
