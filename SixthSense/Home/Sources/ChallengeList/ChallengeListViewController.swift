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

// TODO: 미완성된 뷰입니다 추후 완성할 예정
protocol ChallengeListPresentableListener: AnyObject { }

final class ChallengeListViewController: UIViewController, ChallengeListPresentable, ChallengeListViewControllable {

    weak var listener: ChallengeListPresentableListener?
    
    private enum Constants { }
    
    private let titleLabel = UILabel().then {
        $0.text = "리스트뷰"
        $0.textColor = UIColor.gray
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
    
    private func configureViews() {
        view.addSubviews(titleLabel)
    }
    
    private func configureConstraints() {
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
