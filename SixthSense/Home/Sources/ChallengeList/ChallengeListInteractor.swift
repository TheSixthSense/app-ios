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
    func attachDetail()
    func detachDetail()
    func routeToRegister()
}

protocol ChallengeListPresenterAction: AnyObject {
    var viewDidAppear: Observable<Void> { get }
}

protocol ChallengeListPresenterHandler: AnyObject {
    var sections: Observable<[ChallengeSection]> { get }
    var hasItem: Observable<Bool> { get }
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
    
    private let sectionsRelay: PublishRelay<[ChallengeSection]> = .init()
    private let hasItemRelay: PublishRelay<Bool> = .init()
    
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
        
        dependency.targetDate
            .withUnretained(self)
            .subscribe(onNext: { owner, date in
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
                
                // TODO: Usecase로 로직 이동시켜요
                let calendar = Calendar.current
                let interval = calendar.dateComponents([.year, .month, .day], from: Date(), to: date)
            
                if let intervalDay = interval.day, intervalDay >= 0 {
                    sections.append(.init(identity: .add, items: [.add]))
                }
                owner.sectionsRelay.accept(sections)
//                owner.hasItemRelay.accept(!items.isEmpty)
                owner.hasItemRelay.accept(false)

            })
            .disposeOnDeactivate(interactor: self)
    }
}



extension ChallengeListInteractor: ChallengeListPresenterHandler {
    var sections: Observable<[ChallengeSection]> { sectionsRelay.asObservable() }
    var hasItem: Observable<Bool> { hasItemRelay.asObservable() }
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
        self.emoji = item.emoji
        self.title = item.title
    }
}
