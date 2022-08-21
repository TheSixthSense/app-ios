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
            static var category = 48.0
            static var indicator = 3.0
            static var doneButton = 68.0
            static var tableRow = 78.0
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
            // TODO: - 추가
        case .description(let description):
            return UITableViewCell()
        case .item(let item):
            guard let cell = tableView.dequeue(ChallengeListItemCell.self, for: indexPath) as? ChallengeListItemCell else { return UITableViewCell() }
            cell.bind(item: item)
            return cell
        }
    }

    // MARK: - UI

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

    private var contentTableView = UITableView().then {
        $0.rowHeight = Constants.Height.tableRow
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
        categoryTabView.register(CategoryTabItemCell.self)
        contentTableView.register(ChallengeListItemCell.self)
        view.addSubviews(categoryTabView, indicatorView, contentTableView, doneButton)
    }

    private func configureLayout() {

        categoryTabView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
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
            $0.bottom.equalTo(doneButton.snp.top).offset(-10)
            $0.left.right.equalToSuperview().inset(20)
        }

        guard let tabBar = tabBarController?.tabBar else { return }

        doneButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(Constants.Height.doneButton)
            $0.bottom.equalTo(tabBar.snp.top).offset(-32)
        }
    }

    private func bind() {

        bindDataSources()

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

    private func bindDataSources() {

        guard let handler = handler else { return }

        disposeBag.insert {
            handler.categorySections
                .asDriver(onErrorJustReturn: [])
                .drive(categoryTabView.rx.items(dataSource: categoryDataSource))

            handler.challengeListSections
                .asDriver(onErrorJustReturn: [])
                .drive(contentTableView.rx.items(dataSource: challnegeDataSource))
        }
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
    var viewWillAppear: Observable<Void> { rx.viewWillAppear.asObservable().map { _ in () } }
    var didTapDoneButton: Observable<Void> {
        doneButton.rx.tap
            .throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance)
            .asObservable()
    }
}
