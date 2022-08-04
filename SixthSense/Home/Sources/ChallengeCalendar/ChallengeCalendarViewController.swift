//
//  ChallengeCalendarViewController.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import DesignSystem
import JTAppleCalendar

protocol ChallengeCalendarPresentableListener: AnyObject { }

// TODO: 미완성된 뷰입니다 추후 완성할 예정
final class ChallengeCalendarViewController: UIViewController, ChallengeCalendarPresentable, ChallengeCalendarViewControllable {

    weak var listener: ChallengeCalendarPresentableListener?
    
    private enum Constants {
        enum Views {
            static let headerHeight: CGFloat = 44
            static let contentsHeight: CGFloat = 370
        }
    }
    
    private let headerView = CalendarHeaderView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let weekdayView = CalendarWeekdayView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private lazy var calendar = JTACMonthView(frame: .zero).then {
        $0.backgroundColor = .white
        $0.calendarDataSource = self
        $0.calendarDelegate = self

        $0.scrollDirection = .horizontal
        $0.scrollingMode = .stopAtEachCalendarFrame
        $0.showsHorizontalScrollIndicator = false

        $0.register(CalendarDayCell.self)
        
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0

        $0.isMultipleTouchEnabled = false
        
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private let bottomLineView = UIView().then {
        $0.backgroundColor = .systemGray300
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        configureViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureConstraints()
    }
    
    private func configureViews() {
        view.addSubviews(stackView, bottomLineView)
        stackView.addArrangedSubviews(headerView, weekdayView, calendar)
    }

    private func configureConstraints() {
        headerView.snp.makeConstraints {
            $0.height.equalTo(Constants.Views.headerHeight)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        }
        
        calendar.snp.makeConstraints {
            $0.height.equalTo(370)
        }
        
        bottomLineView.snp.makeConstraints {
            $0.top.equalTo(calendar.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

extension ChallengeCalendarViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        .init(startDate: "2022-08-01".toDate()!,
              endDate: "2022-08-31".toDate()!)
    }
}

extension ChallengeCalendarViewController: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let cell = calendar.dequeueReusableJTAppleCell(CalendarDayCell.self, for: indexPath) as? CalendarDayCell else { return }
        cell.configure(state: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        guard let cell = calendar.dequeueReusableJTAppleCell(CalendarDayCell.self, for: indexPath) as? CalendarDayCell else { return .init() }
        cell.configure(state: cellState)
        return cell
    }
}

extension String {
    func toDate() -> Date? { //"yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        return dateFormatter.string(from: self)
    }
}
