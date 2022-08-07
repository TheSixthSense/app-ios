//
//  RootTabBarController.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import RIBs

protocol HomePresentableListener: AnyObject { }

final class RootTabBarController: UITabBarController, HomeViewControllable, HomePresentable {
    var listener: HomePresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .main
        tabBar.barTintColor = .white
        tabBar.unselectedItemTintColor = .systemGray300
        tabBar.backgroundColor = .white
        
        configureTabBarCornerRadius()
        configureTabBarShadow()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func configureTabBarCornerRadius() {
        tabBar.isTranslucent = true
        tabBar.layer.cornerRadius = 20
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func configureTabBarShadow() {
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)
    }
    
    func setViewControllers(_ viewControllers: [ViewControllable]) {
        super.setViewControllers(viewControllers.map(\.uiviewController), animated: false)
    }
}
