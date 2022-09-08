//
//  ChallengeListInteractor.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import RxRelay
import Foundation
import UIKit

protocol ChallengeListRouting: ViewableRouting {
    func attachCheck()
    func detachCheck()
    func attachDetail(id: String)
    func detachDetail()
    func routeToRegister()
}

protocol ChallengeListPresenterAction: AnyObject {
    var viewDidAppear: Observable<Void> { get }
    var itemSelected: Observable<IndexPath> { get }
    var itemDidDeleted: Observable<IndexPath> { get }
}

protocol ChallengeListPresenterHandler: AnyObject {
    var sections: Observable<[ChallengeSection]> { get }
    var hasItem: Observable<Bool> { get }
    var showToast: Observable<String> { get }
}

protocol ChallengeListPresentable: Presentable {
    var handler: ChallengeListPresenterHandler? { get set }
    var action: ChallengeListPresenterAction? { get set }
}

protocol ChallengeListListener: AnyObject {
}

protocol ChallengeListInteractorDependency {
    var targetDate: PublishRelay<Date> { get }
    var usecase: ChallengeListUseCase { get }
}

final class ChallengeListInteractor: PresentableInteractor<ChallengeListPresentable>,
                                     ChallengeListInteractable {
    private enum Constants {
        static let itemWithSpacing: ([ChallengeSectionItem]) -> [ChallengeSectionItem] = {
            return zip($0, Array(repeating: ChallengeSectionItem.spacing, count: $0.count)).flatMap { [$0, $1] }
        }
    }
    
    weak var router: ChallengeListRouting?
    weak var listener: ChallengeListListener?
    private let dependency: ChallengeListInteractorDependency
    
    private var sectionsItem: [ChallengeSection] = []
    private var targetDate: Date = .init()
    
    private let sectionsRelay: PublishRelay<[ChallengeSection]> = .init()
    private let hasItemRelay: PublishRelay<Bool> = .init()
    private let showToastRelay: PublishRelay<String> = .init()
    
    init(presenter: ChallengeListPresentable, dependency: ChallengeListInteractorDependency) {
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
        action.viewDidAppear
            .take(1)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.fetch(by: Date())
            })
            .disposeOnDeactivate(interactor: self)
        
        action.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, index in
                owner.itemSelected(index)
            })
            .disposeOnDeactivate(interactor: self)
        
        action.itemDidDeleted
            .withUnretained(self)
            .subscribe(onNext: { owner, index in
                owner.itemDelete(index)
            })
            .disposeOnDeactivate(interactor: self)
        
        dependency.targetDate
            .withUnretained(self)
            .subscribe(onNext: { owner, date in
                owner.targetDate = date
                owner.fetch(by: date)
            })
            .disposeOnDeactivate(interactor: self)
    }
    
    private func fetch(by date: Date) {
        dependency.usecase.list(by: date)
            .map { $0.compactMap(ChallengeSectionItem.init) }
            .withUnretained(self)
            .subscribe(onNext: { owner, items in
                // TODO: 미완성된 기능입니다
                var sections: [ChallengeSection] = [
                    .init(identity: .item, items: Constants.itemWithSpacing(items) )
                ]
                
                guard let dateType = owner.dependency.usecase.compareToday(with: date) else { return }
                
                if [DateType.today, .afterToday].contains(dateType) {
                    sections.append(.init(identity: .add, items: [.add]))
                }
                owner.sectionsRelay.accept(sections)
                owner.sectionsItem = sections
//                owner.hasItemRelay.accept(!items.isEmpty)
                owner.hasItemRelay.accept(false)

            })
            .disposeOnDeactivate(interactor: self)
    }
    
    private func itemSelected(_ indexPath: IndexPath) {
        // FIXME: Array에 safe를 적용해요
        let item = sectionsItem[indexPath.section].items[indexPath.row]
        switch item {
            case .success(let viewModel):
                router?.attachDetail(id: viewModel.id)
            // TODO: 오늘 날짜 이후인데 waiting 상태인 경우 분기처리 추가
            case .waiting:
                router?.attachCheck()
            case .add:
                router?.routeToRegister()
            case .failed, .spacing:
                break
        }
    }
    
    private func itemDelete(_ indexPath: IndexPath) {
        let item = sectionsItem[indexPath.section].items[indexPath.row]
        switch item {
            case .success(let viewModel), .failed(let viewModel), .waiting(let viewModel):
                deleteChallenge(id: viewModel.id)
            case .add, .spacing:
                break
        }
    }
    
    private func deleteChallenge(id: String) {
        dependency.usecase.delete(id: id)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.fetch(by: owner.targetDate)
                owner.showToastRelay.accept("챌린지 삭제가 완료되었어요")
            })
            .disposeOnDeactivate(interactor: self)
    }

    
    func challengeCheckDidTapClose() {
        router?.detachCheck()
    }
    
    func detailDidTapClose() {
        router?.detachDetail()
    }
    
    func showToast(message: String) {
        showToastRelay.accept(message)
    }
}



extension ChallengeListInteractor: ChallengeListPresenterHandler {
    var sections: Observable<[ChallengeSection]> { sectionsRelay.asObservable() }
    var hasItem: Observable<Bool> { hasItemRelay.asObservable() }
    var showToast: Observable<String> { showToastRelay.asObservable() }
}

extension ChallengeSectionItem: RawRepresentable {
    typealias RawValue = ChallengeItem?
    var rawValue: ChallengeItem? { nil }
    
    init?(rawValue: ChallengeItem?) {
        guard let item = rawValue else { return nil }
        let viewModel = ChallengeItemCellViewModel(item: item)
        switch item.status {
            case .success:
                self = .success(viewModel)
            case .failed:
                self = .failed(viewModel)
            case .waiting:
                self = .waiting(viewModel)
        }
    }
}

extension ChallengeItemCellViewModel {
    init(item: ChallengeItem) {
        self.id = item.id
        self.emoji = item.emoji
        self.title = item.title
    }
}
