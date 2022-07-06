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

    var userInfoRelay: BehaviorRelay<[UserItemsSection]> { get }
}

final class UserInfoViewController: UIViewController, UserInfoPresentable, UserInfoViewControllable {

    weak var listener: UserInfoPresentableListener?

    private let disposeBag = DisposeBag()

    private let userTableView = UITableView().then { table in
        table.estimatedRowHeight = 500
        table.rowHeight = 500
        table.separatorStyle = .singleLine
        table.separatorInset = .zero
        table.backgroundColor = .clear
        table.showsVerticalScrollIndicator = true
        table.showsHorizontalScrollIndicator = false
    }

    private let userDataSource = RxTableViewSectionedReloadDataSource<UserItemsSection>(
        configureCell: { _, tableView, index, item in
            let userCell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.className, for: index) as? UserTableViewCell
            guard let userCell = userCell else { return UITableViewCell() }
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
        userTableView.register(UserTableViewCell.self,
                               forCellReuseIdentifier: UserTableViewCell.className)

        guard let listener = listener else { return }

        listener.userInfoRelay
            .bind(to: userTableView.rx.items(dataSource: userDataSource))
            .disposed(by: disposeBag)
    }

    private func bindLayout() {
        userTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
