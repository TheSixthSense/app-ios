//
//  ChallengeListViewController.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import RxRelay
import UIKit
import RxAppState
import RxDataSources
import SnapKit
import Then

// TODO: 미완성된 뷰입니다 추후 완성할 예정
final class ChallengeListViewController: UIViewController, ChallengeListPresentable, ChallengeListViewControllable {
    typealias Section = RxTableViewSectionedReloadDataSource<ChallengeSection>
    private let disposeBag = DisposeBag()
    weak var handler: ChallengeListPresenterHandler?
    weak var action: ChallengeListPresenterAction?
    
    private let itemDeleteRelay: PublishRelay<IndexPath> = .init()
    
    private enum Constants { }
    
    private let tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.allowsMultipleSelection = false
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.alwaysBounceVertical = false
        $0.showsVerticalScrollIndicator = false
        $0.register(ChallengeSuccessItemCell.self)
        $0.register(ChallengeFailedItemCell.self)
        $0.register(ChallengeWaitingItemCell.self)
        $0.register(ChallengeAddCell.self)
        $0.register(ChallengeSpacingCell.self)
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
            case .spacing:
                guard let cell = tableView.dequeue(ChallengeSpacingCell.self, for: indexPath) as? ChallengeSpacingCell else { return .init() }
                return cell
            case .add:
                guard let cell = tableView.dequeue(ChallengeAddCell.self, for: indexPath) as? ChallengeAddCell else { return .init() }
                cell.configure()
                return cell
        }
    }
    
    private let emptyView = ChallengeEmptyView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isHidden = true
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
        view.addSubviews(tableView, emptyView)
    }
    
    private func configureConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 20, bottom: 0, right: 20))
        }
        
        emptyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bind() {
        tableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        guard let handler = handler else { return }
        
        handler.sections
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        handler.hasItem
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] hasItem in
                self?.listVisible(hasItem)
            })
            .disposed(by: self.disposeBag)
    }
}

extension ChallengeListViewController {
    private func listVisible(_ visible: Bool) {
        tableView.isHidden = !visible
        emptyView.isHidden = visible
    }
}

extension ChallengeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        tableView.subviews.forEach {
            if NSStringFromClass($0.classForCoder) == "_UITableViewCellSwipeContainerView" {
                $0.layer.cornerRadius = 10
                $0.clipsToBounds = true

                $0.subviews.forEach {
                    if NSStringFromClass($0.classForCoder) == "UISwipeActionPullView" {
                        $0.layer.cornerRadius = 10
                        $0.clipsToBounds = true
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch dataSource[indexPath.section].items[indexPath.row] {
            case .success, .failed, .waiting:
                return configureSwipeDeleteButton()
            case .add, .spacing:
                return UISwipeActionsConfiguration(actions: [])
        }
    }
    
    private func configureSwipeDeleteButton() -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: nil) { (contextualAction, view, completion) in completion(true) }.then {
            $0.image = UIImage(systemName: "trash",
                               withConfiguration: UIImage.SymbolConfiguration(
                                pointSize: 16,
                                weight: .regular,
                                scale: .default)
            )?.withTintColor(.white, renderingMode: .alwaysTemplate)
            $0.backgroundColor = .red500
        }
        return UISwipeActionsConfiguration(actions: [delete]).then {
            $0.performsFirstActionWithFullSwipe = true
        }
    }
}


extension ChallengeListViewController: ChallengeListPresenterAction {
    var viewDidAppear: Observable<Void> { rx.viewDidAppear.asObservable().map { _ in () } }
    var itemSelected: Observable<IndexPath> { tableView.rx.itemSelected
        .flatMap { index -> Observable<IndexPath> in .just(index)} }
    var itemDidDeleted: Observable<IndexPath> { itemDeleteRelay.asObservable() }
}
