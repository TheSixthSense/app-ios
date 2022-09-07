//
//  MyPageViewController.swift
//  Home
//
//  Created by Allie Kim on 2022/09/01.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RxAppState
import RxDataSources
import RxCocoa
import RxSwift
import RIBs
import Then
import SnapKit
import UIKit

final class MyPageViewController: UIViewController, MyPagePresentable, MyPageViewControllable {
    typealias MyPageSections = RxTableViewSectionedReloadDataSource<MyPageSection>

    var handler: MyPagePresenterHandler?
    var action: MyPagePresenterAction?

    private let myPageDataSource = MyPageSections { _, tableView, indexPath, item in
        switch item {
        case .item:
            guard let cell = tableView.dequeue(MyPageItemCell.self, for: indexPath) as? MyPageItemCell else { return UITableViewCell() }
                cell.bind()
                return cell
        case .header:
            guard let cell = tableView.dequeue(MyPageHeaderItemCell.self, for: indexPath) as? MyPageHeaderItemCell else {
                return UITableViewCell()
            }
            cell.bind()
            return cell
        }
    }

    private var myPageTableView = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 150
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceHorizontal = false
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
    }

    private var disposeBag = DisposeBag()

    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = HomeTabBarItem(image: HomeAsset.mypageTabBarIconUnselected.image)
        action = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureLayout()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}

extension MyPageViewController {

    private func configureUI() {
        view.backgroundColor = .white
        myPageTableView.register(MyPageHeaderItemCell.self, MyPageItemCell.self)
        view.addSubviews(myPageTableView)
    }

    private func configureLayout() {
        guard let tabBar = tabBarController?.tabBar else { return }

        myPageTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalTo(tabBar.snp.top).offset(-10)
        }
    }

    private func bind() {
        bindHandler()
    }

    private func bindHandler() {
        guard let handler = handler else { return }
        disposeBag.insert {

            handler.myPageSections
                .asDriver(onErrorJustReturn: [])
                .drive(myPageTableView.rx.items(dataSource: myPageDataSource))
        }
    }
}
extension MyPageViewController: MyPagePresenterAction {
    var viewWillAppear: Observable<Void> { rx.viewWillAppear.map { _ in () }.asObservable() }
}