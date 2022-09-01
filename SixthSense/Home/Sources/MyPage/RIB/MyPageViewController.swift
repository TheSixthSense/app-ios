//
//  MyPageViewController.swift
//  Home
//
//  Created by Allie Kim on 2022/09/01.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa
import Then
import SnapKit
import UIKit

final class MyPageViewController: UIViewController, MyPagePresentable, MyPageViewControllable {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
    }
}

extension MyPageViewController {

    private func configureUI() {
        tabBarItem = HomeTabBarItem(image: HomeAsset.mypageTabBarIconUnselected.image)
    }

    private func configureLayout() {

    }
}
