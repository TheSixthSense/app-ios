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

protocol ChallengeRegisterPresentableListener: AnyObject {
    func didTapBackButton()
}

final class ChallengeRegisterViewController: UIViewController, ChallengeRegisterPresentable, ChallengeRegisterViewControllable {

    typealias CategorySections = RxCollectionViewSectionedReloadDataSource<CategorySection>
    typealias ChallengeSections = RxTableViewSectionedReloadDataSource<ChallengeListSection>

    weak var listener: ChallengeRegisterPresentableListener?
    weak var handler: ChallengeRegisterPresenterHandler?
    weak var action: ChallengeRegisterPresenterAction?

    private enum Constants {
        enum Height {
            static var category = 48.0
            static var indicator = 3.0
            static var doneButton = 44.0
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
            // TODO
        case .description(let description):
            print(description)
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
        $0.register(CategoryTabItemCell.self)
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
    }

    private lazy var categoryCollectionLayout = UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = CGSize(width: view.frame.width / 3.0,
                                      height: Constants.Height.category)
        $0.itemSize = CGSize(width: view.frame.width / 3.0,
                             height: Constants.Height.category)
        $0.scrollDirection = .horizontal
        $0.minimumInteritemSpacing = 0
        $0.minimumLineSpacing = 0
    }

    private lazy var indicatorView = UIView().then {
        $0.backgroundColor = .black
    }

    private lazy var contentTableView = UITableView().then {
        $0.register(ChallengeListItemCell.self)
        $0.rowHeight = Constants.Height.tableRow
        $0.estimatedRowHeight = Constants.Height.tableRow
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceHorizontal = false
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
    }

    private lazy var doneButton = AppButton(title: "챌린지 선택 완료")

    private let disposeBag = DisposeBag()

    init() {
        super.init(nibName: nil, bundle: nil)
        action = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        super.viewWillDisappear(animated)
    }
}

private extension ChallengeRegisterViewController {

    private func configureUI() {
        view.backgroundColor = .white
        setNavigationBar()
        view.addSubviews(categoryTabView, indicatorView, contentTableView, doneButton)
        bind()
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

        doneButton.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(view.safeAreaInsets.bottom + Constants.Height.doneButton)
        }

        contentTableView.snp.makeConstraints {
            $0.top.equalTo(indicatorView.snp.bottom)
            $0.bottom.equalTo(doneButton.snp.top)
            $0.left.right.equalToSuperview().inset(20)
        }
    }

    private func bind() {

        bindDataSources()

        disposeBag.insert {
            rx.viewDidLayoutSubviews
                .take(1)
                .withUnretained(self)
                .bind(onNext: { owner, _ in
                owner.configureLayout()
            })

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
        // FIXME: - navigation title
//        guard let navigationBar = navigationController?.navigationBar else { return }

//        let titleLabel: UILabel = UILabel().then {
//            $0.attributedText = NSAttributedString(
//                string: "챌린지 등록",
//                attributes: titleTextAttributes
//            )
//            $0.sizeToFit()
//        }

//        let titleTextAttributes: [NSAttributedString.Key: Any] = [
//                .font: AppFont.subtitleBold,
//                .foregroundColor: AppColor.systemBlack.cgColor]

        let backButton = UIButton().then {
            $0.setImage(AppIcon.back, for: .normal)
            $0.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        }

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    @objc
    private func didTapBackButton() {
        listener?.didTapBackButton()
    }
}

extension ChallengeRegisterViewController: ChallengeRegisterPresenterAction {
    var viewWillAppear: Observable<Void> { rx.viewWillAppear.asObservable().map { _ in () }
    }
}
