//
//  NavigateViewControllable.swift
//  SixthSense
//
//  Created by Allie Kim on 2022/07/03.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import RIBs

protocol NavigateViewControllable: ViewControllable {
    func presentViewController(_ viewController: ViewControllable)
    func dismissViewController(_ viewController: ViewControllable)
    func pushViewController(_ viewController: ViewControllable)
    func popViewController(_ viewController: ViewControllable)
    func replaceRootNavigationViewController(root: ViewControllable)
}

extension NavigateViewControllable {

    func presentViewController(_ viewController: ViewControllable) {
        uiviewController.present(viewController.uiviewController, animated: true, completion: nil)
    }

    func dismissViewController(_ viewController: ViewControllable) {
        viewController.uiviewController.dismiss(animated: true, completion: nil)
    }

    func pushViewController(_ viewController: ViewControllable) {
        uiviewController.navigationController?.pushViewController(viewController.uiviewController, animated: true)
    }

    func popViewController(_ viewController: ViewControllable) {
        uiviewController.navigationController?.popToViewController(viewController.uiviewController, animated: false)
    }

    func replaceRootNavigationViewController(root: ViewControllable) {
        let navi = UINavigationController(rootViewController: root.uiviewController)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navi
        window.makeKeyAndVisible()
    }
}
