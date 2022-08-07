//
//  FeedViewController.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol FeedPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

// TODO: 미완성화면입니다
final class FeedViewController: UIViewController, FeedPresentable, FeedViewControllable {

    weak var listener: FeedPresentableListener?
    
    private let titleLabel = UILabel().then {
        $0.text = "피드뷰"
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
        view.backgroundColor = .systemGreen
    }
    
    private func configureViews() {
        view.addSubviews(titleLabel)
        tabBarItem = HomeTabBarItem(image: HomeAsset.feedTabBarIconUnselected.image)
    }
    
    private func configureConstraints() {
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
