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
        
        tabBar.isTranslucent = false
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
    }
    
    
    func setViewControllers(_ viewControllers: [ViewControllable]) {
        super.setViewControllers(viewControllers.map(\.uiviewController), animated: false)
    }
}
