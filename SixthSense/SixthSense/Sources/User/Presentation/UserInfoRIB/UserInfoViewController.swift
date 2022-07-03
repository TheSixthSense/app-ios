//
//  UserInfoViewController.swift
//  SixthSense
//
//  Created by Allie Kim on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import SnapKit
import RIBs
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

protocol UserInfoPresentableListener: AnyObject {

    var userInfo: BehaviorRelay<[UserItemsSection]> { get }
}

final class UserInfoViewController: UIViewController, UserInfoPresentable, UserInfoViewControllable {

    weak var listener: UserInfoPresentableListener?

    private let disposeBag = DisposeBag()

    private let userTableView = UITableView().then { table in
        table.estimatedRowHeight = 100
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
    }

    private let userDataSource = RxTableViewSectionedReloadDataSource<UserItemsSection>(
        configureCell: { _, tableView, index, item in
            let userCell = tableView.dequeueReusableCell(with: UserTableViewCell.self, for: index)
            userCell.configure()
            return userCell
        }
    )

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Method is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(userTableView)
        bindUI()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        bindLayout()
    }
}

extension UserInfoViewController {

    private func bindUI() {
        userTableView.register(cellType: UserTableViewCell.self)

        guard let listener = listener else { return }

        listener.userInfo
            .bind(to: userTableView.rx.items(dataSource: userDataSource))
            .disposed(by: disposeBag)
    }

    private func bindLayout() {
        userTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
