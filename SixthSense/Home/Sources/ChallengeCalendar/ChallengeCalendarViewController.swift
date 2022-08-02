//
//  ChallengeCalendarViewController.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol ChallengeCalendarPresentableListener: AnyObject { }

// TODO: 미완성된 뷰입니다 추후 완성할 예정
final class ChallengeCalendarViewController: UIViewController, ChallengeCalendarPresentable, ChallengeCalendarViewControllable {

    weak var listener: ChallengeCalendarPresentableListener?
    
    private enum Constants {
        enum Views {
            static let headerHeight: CGFloat = 44
            static let contentsHeight: CGFloat = 370
        }
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "캘린더뷰"
        $0.textColor = UIColor.gray
        $0.textAlignment = .center
        $0.numberOfLines = 2
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
        view.backgroundColor = .yellow
    }
    
    private func configureViews() {
        view.addSubviews(titleLabel)
    }
    
    private func configureConstraints() {
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(Constants.Views.headerHeight + Constants.Views.contentsHeight)
        }
    }
}
