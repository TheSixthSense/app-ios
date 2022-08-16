//
//  ChallengeListViewController.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import RxAppState
import RxDataSources

// TODO: 미완성된 뷰입니다 추후 완성할 예정
final class ChallengeListViewController: UIViewController, ChallengeListPresentable, ChallengeListViewControllable {
    typealias Section = RxTableViewSectionedReloadDataSource<ChallengeSection>
    private let disposeBag = DisposeBag()
    weak var handler: ChallengeListPresenterHandler?
    weak var action: ChallengeListPresenterAction?
    
    private enum Constants { }
    
    private let tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .white
        $0.allowsSelection = false
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.alwaysBounceVertical = false
        $0.showsVerticalScrollIndicator = false
        $0.register(ChallengeSuccessItemCell.self)
        $0.register(ChallengeFailedItemCell.self)
        $0.register(ChallengeWaitingItemCell.self)
        $0.register(ChallengeAddCell.self)
    }
    
    private let dataSource = Section { _, tableView, indexPath, item in
        switch item {
            case .success(let viewModel):
                guard let cell = tableView.dequeue(ChallengeSuccessItemCell.self, for: indexPath) as? ChallengeSuccessItemCell else { return UITableViewCell() }
                cell.configure(viewModel: viewModel)
                return cell
            case .failed(let viewModel):
                guard let cell = tableView.dequeue(ChallengeFailedItemCell.self, for: indexPath) as? ChallengeFailedItemCell else { return UITableViewCell() }
                cell.configure(viewModel: viewModel)
                return cell
            case .waiting(let viewModel):
                guard let cell = tableView.dequeue(ChallengeWaitingItemCell.self, for: indexPath) as? ChallengeWaitingItemCell else { return UITableViewCell() }
                cell.configure(viewModel: viewModel)
                return cell
            case .add:
                guard let cell = tableView.dequeue(ChallengeAddCell.self, for: indexPath) as? ChallengeAddCell else { return .init() }
                cell.configure()
                return cell
        }
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
    
    private func configureViews() {
        view.addSubviews(tableView)
    }
    
    private func configureConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 20, bottom: 0, right: 20))
        }
    }
    
    private func bind() {
        guard let handler = handler else { return }
        handler.sections
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
}

extension ChallengeListViewController: ChallengeListPresenterAction {
    var viewDidAppear: Observable<Void> { rx.viewDidAppear.asObservable().map { _ in () } }
}
