//
//  ChallengeViewController.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol ChallengePresentableListener: AnyObject { }

final class ChallengeViewController: UIViewController, ChallengePresentable, ChallengeViewControllable {
    weak var listener: ChallengePresentableListener?
    
    private let stackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 4
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func configureViews() {
        view.backgroundColor = .white
        // FIXME: 탭바 아이콘 변경
        tabBarItem = UITabBarItem(
            title: nil,
            image: HomeAsset.homeTabBarIcon.image,
            selectedImage: HomeAsset.homeTabBarIcon.image)

        view.addSubviews(stackView)
    }
    
    private func configureConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func addDashBoard(_ view: ViewControllable) {
        view.uiviewController.do {
            addChild($0)
            stackView.addArrangedSubviews($0.view)
            $0.didMove(toParent: self)
        }
    }
}
