//
//  ChallengeDetailViewController.swift
//  Challenge_Challenge
//
//  Created by 문효재 on 2022/09/07.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import RxRelay
import UIKit
import SnapKit
import Then
import DesignSystem
import Foundation
import Kingfisher

final class ChallengeDetailViewController: UIViewController, ChallengeDetailPresentable, ChallengeDetailViewControllable {
    private let disposeBag = DisposeBag()
    weak var handler: ChallengeDetailPresenterHandler?
    weak var action: ChallengeDetailPresenterAction?
    
    private enum Constants {
        static let dateTransform: (Date) -> String = {
            DateFormatter().then {
                $0.dateFormat = "yyyy.MM.dd(E)"
                $0.timeZone = TimeZone(identifier: "KST")
                $0.locale = Locale(identifier:"ko_KR")
            }.string(from: $0)
        }
    }
    private let itemDeleteRelay: PublishRelay<Void> = .init()
    
    private let headerView = UIView()
    private let titleLabel = UILabel().then {
        $0.text = "챌린지 인증"
        $0.font = AppFont.body1Bold
        $0.textColor = AppColor.systemBlack
        $0.numberOfLines = 1
        $0.sizeToFit()
    }
    private let closeButton = UIButton().then {
        $0.setImage(AppIcon.close, for: .normal)
        $0.setTitleColor(.systemGray500, for: .normal)
    }
    
    private let contentsView = UIView()
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.alignment = .fill
        $0.distribution = .fill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let imageView = UIImageView().then {
        $0.backgroundColor = .systemGray300
        $0.layer.cornerRadius = 30
        $0.clipsToBounds = true
    }
    private let dateLabel = UILabel().then {
        $0.font = AppFont.body1
        $0.textColor = .black.withAlphaComponent(0.4)
        $0.numberOfLines = 1
        $0.sizeToFit()
    }
    private let commentLabel = UILabel().then {
        $0.font = AppFont.body2
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    private let footerView = UIView()
    private let deleteButton = UIButton().then {
        $0.setTitle("삭제", for: .normal)
        $0.setTitleColor(.systemGray500, for: .normal)
        $0.titleLabel?.font = AppFont.body1
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
        view.backgroundColor = .white
        view.addSubviews(headerView, contentsView)
        contentsView.addSubviews(scrollView)
        scrollView.addSubviews(stackView)
        headerView.addSubviews(titleLabel, closeButton)
        stackView.addArrangedSubviews(imageView, dateLabel, commentLabel, footerView)
        footerView.addSubviews(deleteButton)
        stackView.do {
            $0.setCustomSpacing(10, after: imageView)
            $0.setCustomSpacing(24, after: dateLabel)
            $0.setCustomSpacing(40, after: commentLabel)
        }
    }
    
    private func configureConstraints() {
        headerView.snp.makeConstraints {
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16)
        }
        
        contentsView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-32)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.edges.equalTo(scrollView.contentLayoutGuide.snp.edges)
            $0.height.equalTo(scrollView.frameLayoutGuide.snp.height).priority(1)
        }
        
        imageView.snp.makeConstraints {
            $0.height.equalTo(imageView.snp.width)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        deleteButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.showDeleteConfirmAlert()
            })
            .disposed(by: self.disposeBag)
        
        guard let handler = handler else { return }
        
        handler.imageURL
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] in
                self?.imageView.kf.setImage(with: $0)
            })
            .disposed(by: self.disposeBag)
        
        handler.date
            .map(Constants.dateTransform)
            .bind(to: dateLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        handler.comment
            .bind(to: commentLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        handler.errorMessage
            .asDriver(onErrorJustReturn: .init())
            .drive(onNext: { [weak self] in
                self?.showToast($0, toastStyle: .error)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func showDeleteConfirmAlert() {
        showAlert(title: "챌린지 인증을 삭제할거야?",
                        message: "인증을 삭제하면, 챌린지는 대기상태로 돌아가요🫢",
                        actions: [.action(title: "아니요", style: .negative),
                                  .action(title: "예", style: .positive)])
        .filter { $0 == .positive }
        .withUnretained(self)
        .subscribe(onNext: { owner, _ in
            owner.itemDeleteRelay.accept(())
        })
        .disposed(by: self.disposeBag)
    }
}

// MARK: - Action
extension ChallengeDetailViewController: ChallengeDetailPresenterAction {
    var closeDidTap: Observable<Void> { closeButton.rx.tap.asObservable() }
    var deleteDidTap: Observable<Void> { itemDeleteRelay.asObservable() }
}
