//
//  ChallengeRecommendViewController.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/16.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import DesignSystem
import RIBs
import RxAppState
import RxDataSources
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class ChallengeRecommendViewController: UIViewController, ChallengeRecommendPresentable, ChallengeRecommendViewControllable {

    weak var handler: ChallengeRecommendPresenterHandler?
    weak var action: ChallengeRecommendPresenterAction?

    typealias ChallengeSections = RxCollectionViewSectionedReloadDataSource<RecommendSection>

    private enum Constants {
        enum Height {
            static let button = 68.0
        }

        enum Inset {
            static let base = 20.0
            static let collectionTop = 32.0
            static let collectionBottom = -44.0
            static let pageControlBottom = -70.0
        }
    }

    private let dataSource = ChallengeSections { _, collectionView, indexPath, item in
        switch item {
        case .item(let item):
            guard let cell = collectionView.dequeue(RecommendItemCell.self, for: indexPath) as? RecommendItemCell else { return UICollectionViewCell() }
            cell.bind(item: item)
            return cell
        }
    }

    // MARK: - UI

    private var skipButton = UIButton().then {
        $0.backgroundColor = .white
        $0.setAttributedTitle(
            NSAttributedString(
                string: "건너뛰기",
                attributes: [.font: AppFont.body2, .foregroundColor: AppColor.systemGray500]),
            for: .normal)
    }

    private var collectionLayout = UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = .zero
        $0.itemSize = CGSize(width: UIScreen.main.bounds.width,
                             height: UIScreen.main.bounds.height * 0.435)
        $0.scrollDirection = .horizontal
        $0.minimumInteritemSpacing = 0
        $0.minimumLineSpacing = 0
    }

    private lazy var recommendCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionLayout
    ).then {
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
        $0.decelerationRate = .fast
    }

    private var pageControl = AppPageControl().then {
        $0.otherPagesImage = ChallengeAsset.indicatorDefault.image
        $0.currentPageImage = ChallengeAsset.indicatorSelected.image
        $0.currentPage = 0
        $0.numberOfPages = 3
        $0.isUserInteractionEnabled = false
    }

    private var doneButton = AppButton(title: "함께 실천하러 가기!").then {
        $0.isHidden = true
        $0.layer.cornerRadius = 10
    }

    private let disposeBag = DisposeBag()

    // MARK: - LifeCycle

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
        bind()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureLayout()
    }
}

private extension ChallengeRecommendViewController {

    private func configureUI() {
        view.backgroundColor = .white
        recommendCollectionView.register(RecommendItemCell.self)
        view.addSubviews(skipButton, recommendCollectionView, pageControl, doneButton)
    }

    private func configureLayout() {

        skipButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(Constants.Inset.base)
            $0.top.equalToSuperview().inset(view.safeAreaInsets.top + 11)
        }

        recommendCollectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(skipButton.snp.bottom).offset(Constants.Inset.collectionTop)
            $0.bottom.equalTo(pageControl.snp.top).offset(Constants.Inset.collectionBottom)
        }

        pageControl.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(doneButton.snp.top).offset(Constants.Inset.pageControlBottom)
        }

        doneButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(Constants.Inset.base)
            $0.bottom.equalToSuperview().inset(view.safeAreaInsets.bottom + 24)
            $0.height.equalTo(Constants.Height.button)
        }
    }

    private func bind() {
        guard let handler = handler else { return }

        disposeBag.insert {

            didScroll()

            skipButton.rx.tap
                .throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance)
                .map { return 2 }
                .bind(to: pageControl.rx.currentPage,
                      recommendCollectionView.rx.didHorizontalScroll,
                      doneButton.rx.isLastPage,
                      skipButton.rx.isLastPage)

            handler.sections
                .asDriver(onErrorJustReturn: [])
                .drive(recommendCollectionView.rx.items(dataSource: dataSource))
        }
    }

    private func didScroll() -> Disposable {
        return recommendCollectionView.rx
            .willEndDragging
            .withUnretained(self)
            .map({ owner, event -> Int in
            let cellWidth = UIScreen.main.bounds.width
            let offset = owner.recommendCollectionView.contentOffset.x / cellWidth
            let cellIndex: CGFloat = round(offset)

            event.targetContentOffset.pointee = CGPoint(
                x: cellIndex * cellWidth - owner.recommendCollectionView.contentInset.left,
                y: 0)
            return Int(cellIndex)
        }).bind(to: pageControl.rx.currentPage,
                recommendCollectionView.rx.didHorizontalScroll,
                doneButton.rx.isLastPage,
                skipButton.rx.isLastPage)
    }
}

extension ChallengeRecommendViewController: ChallengeRecommendPresenterAction {

    var viewWillAppear: Observable<Void> { rx.viewWillAppear.map { _ in () }.asObservable() }
}

private extension Reactive where Base: UICollectionView {

    var didHorizontalScroll: Binder<Int> {
        return Binder(self.base) { view, index in
            view.scrollToItem(at: IndexPath(row: index, section: 0), at: .left, animated: true)
        }
    }
}

private extension Reactive where Base: AppButton {

    var isLastPage: Binder<Int> {
        return Binder(self.base) { view, index in
            let enableButton = (index == 2) ? true : false
            view.isHidden = !enableButton
            view.hasFocused = enableButton
            view.isUserInteractionEnabled = enableButton
        }
    }
}

private extension Reactive where Base: UIButton {

    var isLastPage: Binder<Int> {
        return Binder(self.base) { view, index in
            let enableButton = (index == 2) ? false : true
            view.isHidden = !enableButton
            view.isUserInteractionEnabled = enableButton
        }
    }
}
