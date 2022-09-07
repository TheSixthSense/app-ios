//
//  ChallengeDetailViewController.swift
//  Challenge_Challenge
//
//  Created by 문효재 on 2022/09/07.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import Then
import DesignSystem

final class ChallengeDetailViewController: UIViewController, ChallengeDetailPresentable, ChallengeDetailViewControllable {
    private let disposeBag = DisposeBag()
    weak var handler: ChallengeDetailPresenterHandler?
    weak var action: ChallengeDetailPresenterAction?
    
    private enum Constants { }
    
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
        view.addSubviews(headerView)
        headerView.addSubviews(titleLabel, closeButton)
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
    }
    
    private func bind() {
        guard let handler = handler else { return }
    }
}

// MARK: - Action
extension ChallengeDetailViewController: ChallengeDetailPresenterAction {
    var closeDidTap: Observable<Void> { closeButton.rx.tap.asObservable() }
}
