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
import UICore
import netfox

final class ChallengeRegisterViewController: UIViewController, ChallengeRegisterPresentable, ChallengeRegisterViewControllable {

    typealias CategorySections = RxCollectionViewSectionedReloadDataSource<CategorySection>
    typealias ChallengeSections = RxTableViewSectionedReloadDataSource<ChallengeListSection>

    weak var handler: ChallengeRegisterPresenterHandler?
    weak var action: ChallengeRegisterPresenterAction?

    private enum Constants {
        static var selectedCategoryIndex = 0

        enum Height {
            static let calenderView = 44.0
            static let calenderButton = 20.0
            static let category = 48.0
            static let indicator = 3.0
            static let doneButton = 68.0
            static let tableRow = 58.0
        }

        enum Inset {
            static let base = 20.0
            static let calenderButtonLeft = 12.0
            static let tableViewBottom = -10.0
            static let doneButtonBottom = -102.0
        }

        enum Picker {
            static let suffix: (Int) -> String = {
                switch $0 {
                case 0: return "년"
                case 1: return "월"
                case 2: return "일"
                default: return .init()
                }
            }

            static let dateToFullString: (Date) -> String = {
                let dateFormatter = DateFormatter().then {
                    $0.dateFormat = "yyyy년 MM월 dd일 EEEE"
                    $0.locale = .init(identifier: "ko_KR")
                    $0.timeZone = TimeZone(identifier: "KST")
                }
                return dateFormatter.string(from: $0)
            }
        }
    }

    private let categoryDataSource = CategorySections { _, collectionView, indexPath, item in
        switch item {

        case .item(let item):
            guard let cell = collectionView.dequeue(CategoryTabItemCell.self, for: indexPath) as? CategoryTabItemCell else { return UICollectionViewCell() }
            cell.setCategory(with: item.title)
            if(indexPath.row == Constants.selectedCategoryIndex) {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
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
            return "\(items[component][row])\(Constants.Picker.suffix(component))"
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
        $0.isMultipleTouchEnabled = false
    }

    private let categoryCollectionLayout = UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width / 3.0,
                                      height: Constants.Height.category)
        $0.itemSize = CGSize(width: UIScreen.main.bounds.width / 3.0,
                             height: Constants.Height.category)
        $0.scrollDirection = .horizontal
        $0.minimumInteritemSpacing = 0
        $0.minimumLineSpacing = 0
    }

    private let indicatorView = UIView().then {
        $0.backgroundColor = .black
    }

    // Content
    private let contentTableView = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = Constants.Height.tableRow
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceHorizontal = false
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
    }

    private let doneButton = AppButton(title: "실천하러 가볼까?").then {
        $0.hasFocused = false
        $0.layer.cornerRadius = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let emptyView = UIView().then {
        $0.backgroundColor = .white
        $0.isHidden = true
    }

    private let emptyIcon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = HomeAsset.challengeDayDone.image
        $0.clipsToBounds = true
    }

    private let emptyTitleLabel = UILabel().then {
        $0.attributedText = NSAttributedString(string: "여기는 챌린지 등록 공간이야 😉", attributes: [.kern: -0.41, .font: AppFont.subtitleBold, .foregroundColor: AppColor.systemBlack])
        $0.numberOfLines = 1
    }

    private let emptySubtitleLabel = UILabel().then {
        let paragraphStyle = NSMutableParagraphStyle().then {
            $0.lineHeightMultiple = 1.08
            $0.alignment = .center
        }

        $0.attributedText = NSAttributedString(string: "로그인하면 비건 챌린지를 바로 \n시작해 볼 수 있어!", attributes: [.kern: -0.41, .paragraphStyle: paragraphStyle, .font: AppFont.body1, .foregroundColor: AppColor.systemBlack])
        $0.numberOfLines = 0
    }

    private let loginButton = UIButton().then {
        $0.backgroundColor = .main
        $0.setAttributedTitle(NSAttributedString(string: "로그인 하러가기", attributes: [.font: AppFont.body1Bold, .foregroundColor: UIColor.white]), for: .normal)
        $0.layer.cornerRadius = 10
    }

    private var disposeBag = DisposeBag()

    // MARK: - LifeCycle

    init() {
        super.init(nibName: nil, bundle: nil)
        action = self
        tabBarItem = HomeTabBarItem(image: HomeAsset.challengeRegisterTabBarIconUnselected.image)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
        configureLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func routeToHome() {
        tabBarController?.selectedIndex = 0
    }
}

private extension ChallengeRegisterViewController {

    private func configureUI() {
        view.backgroundColor = .white
        setNavigationBar()
        makePicker()
        registerCells()
        view.addSubviews(calenderView, categoryTabView, indicatorView, contentTableView, doneButton, emptyView)
        emptyView.addSubviews(emptyIcon, emptyTitleLabel, emptySubtitleLabel, loginButton)
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

        doneButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(Constants.Inset.base)
            $0.height.equalTo(Constants.Height.doneButton)
            $0.bottom.equalToSuperview().offset(Constants.Inset.doneButtonBottom)
        }

        emptyView.snp.makeConstraints { $0.edges.equalToSuperview() }

        emptyTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(116)
        }
        
        emptyIcon.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emptyTitleLabel.snp.bottom).offset(54)
            $0.width.equalTo(94)
            $0.height.equalTo(119)
        }
        
        emptySubtitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emptyIcon.snp.bottom).offset(35)
        }

        loginButton.snp.makeConstraints {
            $0.top.equalTo(emptySubtitleLabel.snp.bottom).offset(62)
            $0.left.right.equalToSuperview().inset(Constants.Inset.base)
            $0.height.equalTo(68)
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
                .map(Constants.Picker.dateToFullString)
                .withUnretained(self)
                .subscribe(onNext: { owner, dateString in
                owner.calenderLabel.text = dateString
                owner.calenderLabel.resignFirstResponder()
            })

            handler.calenarDataSource
                .bind(to: pickerView.rx.items(adapter: pickerAdapter))

            handler.updateCategoryIndex
                .withUnretained(self)
                .bind(onNext: { owner, row in
                owner.updateIndicator(row)
                Constants.selectedCategoryIndex = row
            })

            handler.showErrorMessage
                .withUnretained(self)
                .bind(onNext: { owner, message in
                owner.showToast(message, toastStyle: .error)
            })

            handler.presentEmptyView
                .withUnretained(self)
                .bind(onNext: { owner, _ in
                owner.emptyView.isHidden = false
            })

            handler.buttonState
                .bind(to: doneButton.rx.hasFocused)
        }
    }

    private func bindLists() {
        disposeBag.insert {

            categoryTabView.rx.itemSelected
                .withUnretained(self)
                .bind(onNext: { owner, index in
                owner.categoryTabView.selectItem(at: index, animated: false, scrollPosition: .right)
            })

            contentTableView.rx.itemSelected
                .withUnretained(self)
                .bind(onNext: { owner, index in
                let cell = owner.contentTableView.cellForRow(at: index) as? ChallengeListItemCell
                cell?.isSelected = true
            })

            contentTableView.rx.itemDeselected
                .withUnretained(self)
                .bind(onNext: { owner, index in
                let cell = owner.contentTableView.cellForRow(at: index) as? ChallengeListItemCell
                cell?.isSelected = false
            })
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

    private func updateIndicator(_ rowIndex: Int) {
        indicatorView.snp.remakeConstraints {
            $0.height.equalTo(Constants.Height.indicator)
            $0.width.equalTo(view.frame.width / 3)
            $0.bottom.equalTo(categoryTabView.snp.bottom)
            $0.left.equalTo(CGFloat(rowIndex) * (indicatorView.frame.width))
        }
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.view.layoutIfNeeded()
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
}

extension ChallengeRegisterViewController: ChallengeRegisterPresenterAction {
    var viewWillAppear: Observable<Void> { rx.viewWillAppear.map { _ in () }.asObservable() }
    var didChangeCategory: Observable<(Int, CategorySectionItem)> {
        Observable.zip(categoryTabView.rx.itemSelected.map { $0.row }, categoryTabView.rx.modelSelected(CategorySectionItem.self))
            .distinctUntilChanged(\.0)
    }
    var didSelectChallenge: Observable <(IndexPath, ChallengeListSectionItem)> {
        Observable.zip(contentTableView.rx.itemSelected, contentTableView.rx.modelSelected(ChallengeListSectionItem.self))
            .distinctUntilChanged(at: \.1.id)
    }
    var didTapDoneButton: Observable<Void> {
        doneButton.rx.tap
            .throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance)
            .asObservable()
    }
    var didTapCalendarView: Observable<Void> { calenderLabel.rx.controlEvent(.editingDidBegin).map { () }.asObservable() }
    var calendarBeginEditing: Observable<(row: Int, component: Int)> { pickerView.rx.itemSelected.asObservable() }
    var calendarDidSelected: Observable<Void> { pickerDoneButton.rx.tap.asObservable() }
    var didTapLoginButton: Observable<Void> { loginButton.rx.tap.asObservable() }
}
