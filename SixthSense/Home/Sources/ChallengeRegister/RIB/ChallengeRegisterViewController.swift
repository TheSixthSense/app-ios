//
//  ChallengeRegisterViewController.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import DesignSystem
import RIBs
import RxAppState
import RxDataSources
import RxSwift
import RxCocoa
import SnapKit
import Then
import UIKit

final class ChallengeRegisterViewController: UIViewController, ChallengeRegisterPresentable, ChallengeRegisterViewControllable {

    typealias CategorySections = RxCollectionViewSectionedReloadDataSource<CategorySection>
    typealias ChallengeSections = RxTableViewSectionedReloadDataSource<ChallengeListSection>

    weak var handler: ChallengeRegisterPresenterHandler?
    weak var action: ChallengeRegisterPresenterAction?

    private enum Constants {
        enum Height {
            static var calenderView = 44.0
            static var calenderButton = 20.0
            static var category = 48.0
            static var indicator = 3.0
            static var doneButton = 68.0
            static var tableRow = 58.0
        }

        enum Inset {
            static var base = 20.0
            static var calenderButtonLeft = 12.0
            static var tableViewBottom = -10.0
            static var doneButtonBottom = -32.0
        }
    }

    private let categoryDataSource = CategorySections { _, collectionView, indexPath, item in
        switch item {
        case .item(let item):
            guard let cell = collectionView.dequeue(CategoryTabItemCell.self, for: indexPath) as? CategoryTabItemCell else { return UICollectionViewCell() }
            cell.setCategory(with: item)
            // default selection
            if indexPath.row == 0 {
                cell.isSelected = true
                collectionView.selectItem(at: indexPath,
                                          animated: false,
                                          scrollPosition: .right)
            }
            return cell
        }
    }

    private let challnegeDataSource = ChallengeSections { _, tableView, indexPath, item in
        switch item {
        case .description(let description):
            guard let cell = tableView.dequeue(ChallengeListDescriptionCell.self, for: indexPath) as? ChallengeListDescriptionCell else { return UITableViewCell() }
            cell.add(description: description)
            return cell
        case .item(let item):
            guard let cell = tableView.dequeue(ChallengeListItemCell.self, for: indexPath) as? ChallengeListItemCell else { return UITableViewCell() }
            cell.bind(item: item)
            return cell
        }
    }

    private let pickerAdapter = RxPickerViewStringAdapter<[[Int]]>(
        components: [],
        numberOfComponents: { _, _, _ in 3 },
        numberOfRowsInComponent: { _, _, items, component -> Int in
            return items[component].count
        },
        titleForRow: { _, _, items, row, component -> String? in
            return "\(items[component][row])"
        }
    )

    // MARK: - UI

    // Calander
    private let calenderView = UIView().then {
        $0.layer.borderColor = AppColor.systemGray300.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
    }

    let calenderLabel = UITextField().then {
        $0.font = AppFont.body1
        $0.sizeToFit()
    }

    private let calenderSelectButton = UIButton().then {
        $0.setImage(AppIcon.calendar, for: .normal)
    }

    private let pickerView = UIPickerView()

    private let pickerDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
    private let barButtonSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

    // Category
    private lazy var categoryTabView = UICollectionView(
        frame: .zero,
        collectionViewLayout: categoryCollectionLayout
    ).then {
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
    }

    private var categoryCollectionLayout = UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width / 3.0,
                                      height: Constants.Height.category)
        $0.itemSize = CGSize(width: UIScreen.main.bounds.width / 3.0,
                             height: Constants.Height.category)
        $0.scrollDirection = .horizontal
        $0.minimumInteritemSpacing = 0
        $0.minimumLineSpacing = 0
    }

    private var indicatorView = UIView().then {
        $0.backgroundColor = .black
    }

    // Content
    private var contentTableView = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = Constants.Height.tableRow
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceHorizontal = false
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
    }

    private var doneButton = AppButton(title: "챌린지 선택 완료").then {
        $0.hasFocused = true // TEST
        $0.layer.cornerRadius = 10
    }

    private let disposeBag = DisposeBag()

    // MARK: - LifeCycle

    init() {
        super.init(nibName: nil, bundle: nil)
        action = self
        tabBarItem = HomeTabBarItem(image: HomeAsset.challengeRegisterIconUnselected.image)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureLayout()
    }
}

private extension ChallengeRegisterViewController {

    private func configureUI() {
        view.backgroundColor = .white
        setNavigationBar()
        makePicker()
        registerCells()
        view.addSubviews(calenderView, categoryTabView, indicatorView, contentTableView, doneButton)
        calenderView.addSubviews(calenderSelectButton, calenderLabel)
    }

    private func configureLayout() {
        calenderView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.Inset.base)
            $0.left.right.equalToSuperview().inset(Constants.Inset.base)
            $0.height.equalTo(Constants.Height.calenderView)
        }

        calenderSelectButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(Constants.Inset.calenderButtonLeft)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(Constants.Height.calenderButton)
        }

        calenderLabel.snp.makeConstraints {
            $0.left.equalTo(calenderSelectButton.snp.right).offset(Constants.Inset.base)
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        categoryTabView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(calenderView.snp.bottom).offset(Constants.Inset.base)
            $0.height.equalTo(Constants.Height.category)
        }

        indicatorView.snp.makeConstraints {
            $0.height.equalTo(Constants.Height.indicator)
            $0.width.equalTo(view.frame.width / 3)
            $0.bottom.equalTo(categoryTabView.snp.bottom)
            $0.left.equalToSuperview()
        }

        contentTableView.snp.makeConstraints {
            $0.top.equalTo(indicatorView.snp.bottom)
            $0.bottom.equalTo(doneButton.snp.top).offset(Constants.Inset.tableViewBottom)
            $0.left.right.equalToSuperview().inset(Constants.Inset.base)
        }

        guard let tabBar = tabBarController?.tabBar else { return }

        doneButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(Constants.Inset.base)
            $0.height.equalTo(Constants.Height.doneButton)
            $0.bottom.equalTo(tabBar.snp.top).offset(Constants.Inset.doneButtonBottom)
        }
    }

    private func bind() {

        bindHandler()
        bindLists()

        calenderSelectButton.rx.tap
            .subscribe(onNext: { [weak self] in
            self?.calenderLabel.becomeFirstResponder()
        }).disposed(by: disposeBag)
    }

    private func bindHandler() {

        guard let handler = handler else { return }

        disposeBag.insert {
            handler.categorySections
                .asDriver(onErrorJustReturn: [])
                .drive(categoryTabView.rx.items(dataSource: categoryDataSource))

            handler.challengeListSections
                .asDriver(onErrorJustReturn: [])
                .drive(contentTableView.rx.items(dataSource: challnegeDataSource))

            handler.basisDate
                .map(dateToFullString)
                .withUnretained(self)
                .subscribe(onNext: { owner, dateString in
                owner.calenderLabel.text = dateString
                owner.calenderLabel.resignFirstResponder()
            })

            handler.calenarDataSource
                .bind(to: pickerView.rx.items(adapter: pickerAdapter))
        }
    }

    private func bindLists() {
        disposeBag.insert {
            categoryTabView.rx
                .itemSelected
                .distinctUntilChanged()
                .withUnretained(self)
                .bind(onNext: { owner, index in
                owner.indicatorView.snp.updateConstraints {
                    $0.left.equalTo(CGFloat(index.row) * (owner.indicatorView.frame.width))
                }
                UIView.animate(withDuration: 0.25) {
                    owner.view.layoutIfNeeded()
                }
            })

            // FIXME: - cell data API 추가
            Observable
                .zip(contentTableView.rx.itemSelected, contentTableView.rx.modelSelected(ChallengeListSectionItem.self))
                .withUnretained(self)
                .bind(onNext: { owner, item in
                let cell = owner.contentTableView.cellForRow(at: item.0) as? ChallengeListItemCell
                cell?.selected()
            })

            contentTableView.rx.itemDeselected
                .withUnretained(self)
                .bind { owner, index in
                let cell = owner.contentTableView.cellForRow(at: index) as? ChallengeListItemCell
                cell?.deselected()
            }
        }
    }

    private func makePicker() {
        let toolbar = UIToolbar().then {
            $0.sizeToFit()
            $0.setItems([barButtonSpace, pickerDoneButton], animated: true)
        }
        calenderLabel.do {
            $0.inputAccessoryView = toolbar
            $0.inputView = pickerView
            $0.tintColor = .clear
        }
    }

    private func registerCells() {
        categoryTabView.register(CategoryTabItemCell.self)
        contentTableView.register(ChallengeListItemCell.self, ChallengeListDescriptionCell.self)
    }

    private func setNavigationBar() {
        let titleLabel: UILabel = UILabel().then {
            $0.attributedText = NSAttributedString(
                string: "챌린지 등록",
                attributes: [.font: AppFont.body1Bold, .foregroundColor: AppColor.systemBlack]
            )
            $0.sizeToFit()
        }
        self.navigationItem.titleView = titleLabel
    }

    private func dateToFullString(_ date: Date) -> String {
        let dateFormatter = DateFormatter().then {
            $0.dateFormat = "yyyy년 MM월 dd일 E요일"
            $0.timeZone = TimeZone(identifier: "KST")
        }
        return dateFormatter.string(from: date)
    }
}

extension ChallengeRegisterViewController: ChallengeRegisterPresenterAction {
    var viewWillAppear: Observable<Void> { rx.viewWillAppear.asObservable().map { _ in () } }
    var didTapDoneButton: Observable<Void> {
        doneButton.rx.tap
            .throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance)
            .asObservable()
    }
    var didTapCalendarView: Observable<Void> { calenderLabel.rx.controlEvent(.editingDidBegin).map { () }.asObservable() }
    var calendarBeginEditing: Observable<(row: Int, component: Int)> { pickerView.rx.itemSelected.asObservable() }
    var calendarDidSelected: Observable<Void> { pickerDoneButton.rx.tap.asObservable() }
}
