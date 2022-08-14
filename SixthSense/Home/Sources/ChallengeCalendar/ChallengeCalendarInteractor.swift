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
    var selectMonth: Observable<Void> { get }
    var swipeCalendar: Observable<Date> { get }
    var monthBeginEditing: Observable<(row: Int, component: Int)> { get }
    var monthDidSelected: Observable<Void> { get }
}

protocol ChallengeCalendarPresenterHandler: AnyObject {
    var basisDate: Observable<Date> { get }
    var calenarDataSource: Observable<[[Int]]> { get }
    var calendar: (startDate: Date, endDate: Date) { get }
}

protocol ChallengeCalendarPresentable: Presentable {
    var listener: ChallengeCalendarPresentableListener? { get set }
    var handler: ChallengeCalendarPresenterHandler? { get set }
    var action: ChallengeCalendarPresenterAction? { get set }
}

protocol ChallengeCalendarListener: AnyObject { 
    func routeToChallengeRegister()
}

final class ChallengeCalendarInteractor: PresentableInteractor<ChallengeCalendarPresentable>, ChallengeCalendarInteractable, ChallengeCalendarPresentableListener {

    weak var router: ChallengeCalendarRouting?
    weak var listener: ChallengeCalendarListener?
    
    
    private let basisDateRelay: BehaviorRelay<Date> = .init(value: Date())
    private let calendarDataSourceRelay: PublishRelay<[[Int]]> = .init()
    
    private var calendarConfiguration = CalendarConfiguration(startYear: 2022, endYear: 2026)
    
    override init(presenter: ChallengeCalendarPresentable) {
        super.init(presenter: presenter)
        presenter.handler = self
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        bind()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func didTapAddButton() {
        listener?.routeToChallengeRegister()
    }

    private func bind() {
        guard let action = presenter.action else { return }
        
        action.selectMonth
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.calendarDataSourceRelay.accept(owner.calendarConfiguration.pickerDataSource)
            })
            .disposeOnDeactivate(interactor: self)
        
        action.swipeCalendar
            .withUnretained(self)
            .subscribe(onNext: { owner, date in
                owner.calendarConfiguration.setBasisDate(date: date)
                owner.basisDateRelay.accept(owner.calendarConfiguration.basisDate)
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
    }
}

extension ChallengeCalendarInteractor: ChallengeCalendarPresenterHandler {
    var calenarDataSource: Observable<[[Int]]> { calendarDataSourceRelay.asObservable() }
    var basisDate: Observable<Date> { basisDateRelay.asObservable() }
    var calendar: (startDate: Date, endDate: Date) {
        return (startDate: calendarConfiguration.startDate, endDate: calendarConfiguration.endDate)
    }

}
