//
//  ChallengeCalendarInteractor.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import Foundation
import RxRelay

protocol ChallengeCalendarRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ChallengeCalendarPresenterAction: AnyObject {
    var fetch: Observable<Void> { get }
    var selectMonth: Observable<Void> { get }
    var swipeCalendar: Observable<Date> { get }
    var monthBeginEditing: Observable<(row: Int, component: Int)> { get }
    var monthDidSelected: Observable<Void> { get }
    var todayDidTap: Observable<Void> { get }
    var dateDidSelected: Observable<Date> { get }
}

protocol ChallengeCalendarPresenterHandler: AnyObject {
    var basisDate: Observable<Date> { get }
    var calenarDataSource: Observable<[[Int]]> { get }
    var calendar: (startDate: Date, endDate: Date) { get }
    var reload: Observable<Void> { get }
    var dayStates: DayState { get }
}

protocol ChallengeCalendarPresentable: Presentable {
    var handler: ChallengeCalendarPresenterHandler? { get set }
    var action: ChallengeCalendarPresenterAction? { get set }
}

protocol ChallengeCalendarInteractorDependency {
    var targetDate: PublishRelay<Date> { get }
    var usecase: ChallengeCalendarUseCase { get }
    var fetchCalendar: PublishRelay<Void> { get }
}

protocol ChallengeCalendarListener: AnyObject { }

final class ChallengeCalendarInteractor: PresentableInteractor<ChallengeCalendarPresentable>, ChallengeCalendarInteractable {

    weak var router: ChallengeCalendarRouting?
    weak var listener: ChallengeCalendarListener?
    private let dependency: ChallengeCalendarInteractorDependency
    
    private let basisDateRelay: BehaviorRelay<Date> = .init(value: Date())
    private let calendarDataSourceRelay: PublishRelay<[[Int]]> = .init()
    private let reloadRelay: PublishRelay<Void> = .init()
    private var dayStatesConfiguration: DayState = { _ in .none }
    
    private var calendarConfiguration = CalendarConfiguration(startYear: 2022, endYear: 2026)
    
    init(presenter: ChallengeCalendarPresentable,
         dependency: ChallengeCalendarInteractorDependency) {
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
        dependency.fetchCalendar
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.fetch(by: owner.calendarConfiguration.basisDate)
            })
            .disposeOnDeactivate(interactor: self)
        
        guard let action = presenter.action else { return }
        
        action.selectMonth
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.calendarDataSourceRelay.accept(owner.calendarConfiguration.pickerDataSource)
            })
            .disposeOnDeactivate(interactor: self)
        
        action.fetch
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.fetch(by: owner.calendarConfiguration.basisDate)
            })
            .disposeOnDeactivate(interactor: self)
        
        action.swipeCalendar
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, date in
                owner.calendarConfiguration.setBasisDate(date: date)
                owner.basisDateRelay.accept(owner.calendarConfiguration.basisDate)
                owner.fetch(by: date)
            })
            .disposeOnDeactivate(interactor: self)
        
        action.monthBeginEditing
            .withUnretained(self)
            .subscribe(onNext: { owner, results in
                switch results.component {
                    case 0:
                        owner.calendarConfiguration.setYear(row: results.row)
                    case 1:
                        owner.calendarConfiguration.setMonth(row: results.row)
                    default:
                        break
                }
            })
            .disposeOnDeactivate(interactor: self)
        
        action.monthDidSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.basisDateRelay.accept(owner.calendarConfiguration.basisDate)
            })
            .disposeOnDeactivate(interactor: self)
        
        action.todayDidTap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.calendarConfiguration.setBasisDate(date: Date())
                owner.basisDateRelay.accept(owner.calendarConfiguration.basisDate)
            })
            .disposeOnDeactivate(interactor: self)
        
        action.dateDidSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, date in
                owner.dependency.targetDate.accept(date)
            })
            .disposeOnDeactivate(interactor: self)
    }
    
    private func fetch(by date: Date) {
        dependency.usecase.fetch(by: date)
            .withUnretained(self)
            .subscribe(onNext: { owner, config in
                owner.dayStatesConfiguration = config
                owner.reloadRelay.accept(())
            })
            .disposeOnDeactivate(interactor: self)
    }
}

extension ChallengeCalendarInteractor: ChallengeCalendarPresenterHandler {
    var calenarDataSource: Observable<[[Int]]> { calendarDataSourceRelay.asObservable() }
    var basisDate: Observable<Date> { basisDateRelay.asObservable() }
    var calendar: (startDate: Date, endDate: Date) {
        return (startDate: calendarConfiguration.startDate, endDate: calendarConfiguration.endDate)
    }
    var reload: Observable<Void> { reloadRelay.asObservable() }
    var dayStates: DayState { dayStatesConfiguration }
}
