//
//  ChallengeCalendarViewController.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import RIBs
import RxSwift
import RxRelay
import UIKit
import DesignSystem
import JTAppleCalendar
import RxDataSources

// TODO: 미완성된 뷰입니다 추후 완성할 예정
final class ChallengeCalendarViewController: UIViewController, ChallengeCalendarPresentable, ChallengeCalendarViewControllable {
    weak var handler: ChallengeCalendarPresenterHandler?
    weak var action: ChallengeCalendarPresenterAction?
    
    private enum Constants {
        enum Views {
            static let headerHeight: CGFloat = 44
            static let contentsHeight: CGFloat = 370
        }
        
        enum Picker {
            static let suffix: (Int) -> String = {
                switch $0 {
                    case 0: return "년"
                    case 1: return "월"
                    default: return .init()
                }
            }
            static let dateToYearMonth: (Date) -> String = {
                let dateFormatter = DateFormatter().then {
                    $0.dateFormat = "yyyy년 MM월"
                    $0.timeZone = TimeZone(identifier: "KST")
                }
                
                return dateFormatter.string(from: $0)
            }
        }
    }
    
    let swipeCalendarRelay: PublishRelay<Date> = .init()
    let dateSelectRelay: PublishRelay<Date> = .init()
    private let fetchRelay: PublishRelay<Void> = .init()
    
    private let disposeBag = DisposeBag()
    private let pickerAdapter = RxPickerViewStringAdapter<[[Int]]>(
        components: [],
        numberOfComponents: { _,_,_  in 2 },
        numberOfRowsInComponent: { _, _, items, component -> Int in
            return items[component].count
        },
        titleForRow: { _, _, items, row, component -> String? in
            return "\(items[component][row])\(Constants.Picker.suffix(component))"
        }
    )

    let headerView = CalendarHeaderView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let pickerView = UIPickerView().then {
        $0.backgroundColor = .white
    }
    let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: nil).then {
        $0.tintColor = .systemGray500
    }
    let todayButton = UIBarButtonItem(title: "오늘", style: .plain, target: nil, action: nil)
    let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: nil, action: nil)

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
        action = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureConstraints()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchRelay.accept(())
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func configureViews() {
        view.addSubviews(stackView, bottomLineView)
        stackView.addArrangedSubviews(headerView, weekdayView, calendar)
        configureDatePicker()
    }
    
    private func configureDatePicker() {
        let toolbar = UIToolbar().then {
            $0.barTintColor = .white
            $0.sizeToFit()
            $0.setItems([cancelButton,
                         UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                         todayButton,
                         UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                         doneButton], animated: true)
        }
        
        headerView.monthLabel.do {
            $0.inputAccessoryView = toolbar
            $0.inputView = pickerView
            $0.tintColor = .clear
        }
    }


    private func configureConstraints() {
        headerView.snp.makeConstraints {
            $0.height.equalTo(Constants.Views.headerHeight)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        }
        
        calendar.snp.makeConstraints {
            $0.height.equalTo(338)
        }
        
        bottomLineView.snp.makeConstraints {
            $0.top.equalTo(calendar.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    private func bind() {
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.headerView.monthLabel.resignFirstResponder()
            })
            .disposed(by: self.disposeBag)
        
        guard let handler = handler else { return }
        
        handler.basisDate
            .asDriver(onErrorJustReturn: .init())
            .drive(onNext: { [weak self] in
                self?.calendar.scrollToDate($0, animateScroll: false)
            })
            .disposed(by: self.disposeBag)
        
        handler.basisDate
            .map(Constants.Picker.dateToYearMonth)
            .asDriver(onErrorJustReturn: .init())
            .drive(onNext: { [weak self] in
                self?.headerView.monthLabel.text = $0
                self?.headerView.monthLabel.resignFirstResponder()
            })
            .disposed(by: self.disposeBag)
        
        handler.reload
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                self?.calendar.reloadData()
            })
            .disposed(by: self.disposeBag)
        
        handler.calenarDataSource
            .bind(to: pickerView.rx.items(adapter: pickerAdapter))
            .disposed(by: self.disposeBag)
    }
}

extension ChallengeCalendarViewController: ChallengeCalendarPresenterAction {
    var fetch: Observable<Void> { fetchRelay.asObservable() }
    var selectMonth: Observable<Void> { headerView.rx.tap }
    var monthBeginEditing: Observable<(row: Int, component: Int)> {
        pickerView.rx.itemSelected.asObservable()
    }
    var monthDidSelected: Observable<Void> { doneButton.rx.tap.asObservable() }
    var todayDidTap: Observable<Void> { todayButton.rx.tap.asObservable() }
    var swipeCalendar: Observable<Date> { swipeCalendarRelay.asObservable() }
    var dateDidSelected: Observable<Date> { dateSelectRelay.asObservable() }
}
