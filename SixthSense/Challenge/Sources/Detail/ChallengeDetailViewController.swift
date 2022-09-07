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
    }
    
    private func configureConstraints() {
    }
    
    private func bind() {
        guard let handler = handler else { return }
    }
}

// MARK: - Action
extension ChallengeDetailViewController: ChallengeDetailPresenterAction {
}
