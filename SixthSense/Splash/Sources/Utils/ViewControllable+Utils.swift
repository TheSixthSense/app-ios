//
//  ViewControllable+Extension.swift
//  VegannerAppDev
//
//  Created by 문효재 on 2022/07/12.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import RIBs

public final class NavigationControllerable: ViewControllable {
    
 public var uiviewController: UIViewController { self.navigationController }
 public let navigationController: UINavigationController
    
    public init(root: ViewControllable) {
        let navigation = UINavigationController(rootViewController: root.uiviewController)
        navigation.navigationBar.isTranslucent = false
        navigation.navigationBar.backgroundColor = .white
        navigation.navigationBar.scrollEdgeAppearance = navigation.navigationBar.standardAppearance
        
        self.navigationController = navigation
    }
}

public extension ViewControllable {
    
    func present(_ viewControllable: ViewControllable, animated: Bool, completion: (() -> Void)? = nil) {
        self.uiviewController.present(viewControllable.uiviewController, animated: animated, completion: completion)
    }
    
    func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
        self.uiviewController.dismiss(animated: animated, completion: completion)
    }
    
    func pushViewController(_ viewControllable: ViewControllable, animated: Bool) {
        if let nav = self.uiviewController as? UINavigationController {
            nav.pushViewController(viewControllable.uiviewController, animated: animated)
        } else {
            self.uiviewController.navigationController?.pushViewController(viewControllable.uiviewController, animated: animated)
        }
    }
    
    func popViewController(animated: Bool) {
        if let nav = self.uiviewController as? UINavigationController {
            nav.popViewController(animated: animated)
        } else {
            self.uiviewController.navigationController?.popViewController(animated: animated)
        }
    }
    
    func popToRoot(animated: Bool) {
        if let nav = self.uiviewController as? UINavigationController {
            nav.popToRootViewController(animated: animated)
        } else {
            self.uiviewController.navigationController?.popToRootViewController(animated: animated)
        }
    }
    
    func setViewControllers(_ viewControllerables: [ViewControllable]) {
        if let nav = self.uiviewController as? UINavigationController {
            nav.setViewControllers(viewControllerables.map(\.uiviewController), animated: true)
        } else {
            self.uiviewController.navigationController?.setViewControllers(viewControllerables.map(\.uiviewController), animated: true)
        }
    }
    
    var topViewControllable: ViewControllable {
        var top: ViewControllable = self
        
        while let presented = top.uiviewController.presentedViewController as? ViewControllable {
            top = presented
        }
        
        return top
    }
}
