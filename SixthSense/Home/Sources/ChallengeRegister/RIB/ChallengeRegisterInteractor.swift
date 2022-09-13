//
//  ChallengeRegisterInteractor.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import Then
import RIBs
import RxCocoa
import RxSwift
import Repository

public protocol ChallengeRegisterRouting: ViewableRouting {
    func routeToRecommend(id: String)
    func routeToHome()
}

protocol ChallengeRegisterPresentable: Presentable {
    var handler: ChallengeRegisterPresenterHandler? { get set }
    var action: ChallengeRegisterPresenterAction? { get set }
}

protocol ChallengeRegisterPresenterAction: AnyObject {
    var viewWillAppear: Observable<Void> { get }
    var didChangeCategory: Observable<(Int, CategorySectionItem)> { get }
    var didSelectChallenge: Observable <(IndexPath, ChallengeListSectionItem)> { get }
    var didTapDoneButton: Observable<Void> { get }
    var didTapCalendarView: Observable<Void> { get }
    var calendarBeginEditing: Observable<(row: Int, component: Int)> { get }
    var calendarDidSelected: Observable<Void> { get }
}

protocol ChallengeRegisterPresenterHandler: AnyObject {
    var basisDate: Observable<Date> { get }
    var calenarDataSource: Observable<[[Int]]> { get }
    var categorySections: Observable<[CategorySection]> { get }
    var challengeListSections: Observable<[ChallengeListSection]> { get }
    var updateCategoryIndex: Observable<Int> { get }
    var showErrorMessage: Observable<String> { get }
    var buttonState: Observable<Bool> { get }
}

public protocol ChallengeRegisterListener: AnyObject {
}

final class ChallengeRegisterInteractor: PresentableInteractor<ChallengeRegisterPresentable>,
    ChallengeRegisterInteractable {

    weak var router: ChallengeRegisterRouting?
    weak var listener: ChallengeRegisterListener?
    private var dependency: ChallengeRegisterComponent

    private var calendarConfiguration = CalendarConfiguration(startYear: 2022, endYear: 2026)

    private let basisDateRelay: BehaviorRelay<Date> = .init(value: Date())
    private let categorySectionsRelay: PublishRelay<[CategorySection]> = .init()
    private let challengeListSectionsRelay: PublishRelay<[ChallengeListSection]> = .init()
    private let calendarDataSourceRelay: PublishRelay<[[Int]]> = .init()
    private let updateCategoryIndexRelay: PublishRelay<Int> = .init() // CollectionView Cell Index
    private let buttonStateRelay: PublishRelay<Bool> = .init()

    private let categoryIndex: BehaviorRelay<Int> = .init(value: 1) // 카테고리 ID
    private lazy var dataObservable = Observable.combineLatest(
        self.fetchChallengeCategories(), self.fetchChallengeLists(), self.categoryIndex
    )

    private let errorRelay: PublishRelay<String> = .init()
    private let basisDateCalculateRelay: BehaviorRelay<Date> = .init(value: Date())

    private var request: ChallengeJoinRequest = ChallengeJoinRequest.init()
    private var selectedChallengeId: Int = -1

    init(presenter: ChallengeRegisterPresentable,
         dependency: ChallengeRegisterComponent) {
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

    func returnToHome() {
        router?.routeToHome()
    }

    private func configureRequestModel(date: String) {
        self.request = request.with {
            $0.challengeDate = date
            $0.challengeId = selectedChallengeId
        }
    }

    private func bind() {
        dependency.targetDate
            .bind(to: basisDateRelay)
            .disposeOnDeactivate(interactor: self)

        dependency.targetDate
            .withUnretained(self)
            .subscribe(onNext: { owner, date in
            owner.calendarConfiguration.setBasisDate(date: date)
        }).disposeOnDeactivate(interactor: self)

        basisDateCalculateRelay
            .withUnretained(self)
            .bind(onNext: { owner, date in
            if date.isPast(comparisonDate: Date()) {
                owner.errorRelay.accept("앗.. 이미 지난 날짜예요! 한번 더 확인해주세요")
            }
        }).disposeOnDeactivate(interactor: self)

        guard let action = presenter.action else { return }

        action.viewWillAppear
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
            owner.makeListSections()
        }).disposeOnDeactivate(interactor: self)

        action.didChangeCategory
            .withUnretained(self)
            .subscribe(onNext: { owner, item in
            owner.didChangedCategory(index: item.0, categoryId: item.1.categoryId)
        }).disposeOnDeactivate(interactor: self)

        action.didSelectChallenge
            .withUnretained(self)
            .subscribe(onNext: { owner, item in
            owner.selectedChallengeId = item.1.id
            owner.buttonStateRelay.accept(true)
        }).disposeOnDeactivate(interactor: self)

        action.didTapDoneButton
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
            owner.configureRequestModel(date: owner.calendarConfiguration.basisFullDate.toString(dateFormat: "YYYY-MM-dd"))
            owner.joinChallenge(request: owner.request)
        }).disposeOnDeactivate(interactor: self)

        action.didTapCalendarView
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
            owner.calendarDataSourceRelay.accept(owner.calendarConfiguration.pickerFullDataSource)
        }).disposeOnDeactivate(interactor: self)

        action.calendarBeginEditing
            .withUnretained(self)
            .subscribe(onNext: { owner, results in
            switch results.component {
            case 0:
                owner.calendarConfiguration.setYear(row: results.row)
            case 1:
                owner.calendarConfiguration.setMonth(row: results.row)
            case 2:
                owner.calendarConfiguration.setDay(row: results.row)
            default:
                break
            }
        }).disposeOnDeactivate(interactor: self)

        action.calendarDidSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
            owner.didSelectedCalendar(date: owner.calendarConfiguration.basisFullDate)
        }).disposeOnDeactivate(interactor: self)
    }

    private func makeListSections() {
        dataObservable
            .distinctUntilChanged(at: \.2)
            .withUnretained(self)
            .subscribe(onNext: { (owner, values) in
            let (categories, challenges, index) = values

            let categorySections: [CategorySection] = [
                    .init(identity: .item,
                          items: categories.compactMap(CategorySectionItem.init))
            ]

            let sections: [ChallengeListSection] = [
                    .init(identity: .description,
                          items: [.description(categories[index - 1].description)]),
                    .init(identity: .item,
                          items: challenges.filter { $0.categoryId == index }.compactMap(ChallengeListSectionItem.init))
            ]

            owner.buttonStateRelay.accept(false)
            owner.challengeListSectionsRelay.accept(sections)
            owner.categorySectionsRelay.accept(categorySections)
        }).disposeOnDeactivate(interactor: self)
    }

    private func fetchChallengeCategories() -> Observable<[CategoryCellViewModel]> {
        return dependency.useCase
            .fetchChallengeCategories()
            .catch({ [weak self] error in
            self?.errorRelay.accept(error.localizedDescription)
            return .empty()
        })
            .compactMap({ $0.compactMap { CategoryCellViewModel(model: $0) }.sorted(by: <) })
    }

    private func fetchChallengeLists() -> Observable<[ChallengeListItemCellViewModel]> {
        return dependency.useCase
            .fetchChallengeRegisterLists()
            .catch({ [weak self] error in
            self?.errorRelay.accept(error.localizedDescription)
            return .empty()
        })
            .compactMap({ $0.compactMap { ChallengeListItemCellViewModel(model: $0) }.sorted(by: <) })
    }

    // TODO: - 에러 팝업
    private func joinChallenge(request: ChallengeJoinRequest) {
        dependency.useCase
            .joinChallenge(request: request)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
            owner.router?.routeToRecommend(id: String(request.challengeId))
        }).disposeOnDeactivate(interactor: self)
    }

    private func changeButtonState(to enabled: Bool) {
        guard !calendarConfiguration.basisFullDate.isPast(comparisonDate: Date()) else {
            buttonStateRelay.accept(false)
            return
        }
        buttonStateRelay.accept(enabled)
    }

    private func didSelectedCalendar(date: Date) {
        basisDateCalculateRelay.accept(date)
        dependency.targetDate.accept(date)
    }

    private func didChangedCategory(index: Int, categoryId: Int) {
        selectedChallengeId = -1
        updateCategoryIndexRelay.accept(index)
        categoryIndex.accept(categoryId)
        changeButtonState(to: false)
    }
}

extension ChallengeRegisterInteractor: ChallengeRegisterPresenterHandler {
    var basisDate: Observable<Date> { basisDateRelay.asObservable() }
    var categorySections: Observable<[CategorySection]> { categorySectionsRelay.asObservable() }
    var challengeListSections: Observable<[ChallengeListSection]> { challengeListSectionsRelay.asObservable() }
    var calenarDataSource: Observable<[[Int]]> { calendarDataSourceRelay.asObservable() }
    var updateCategoryIndex: Observable<Int> { updateCategoryIndexRelay.asObservable() }
    var showErrorMessage: Observable<String> { errorRelay.asObservable() }
    var buttonState: Observable<Bool> { buttonStateRelay.asObservable() }
}

extension ChallengeJoinRequest: Then { }
