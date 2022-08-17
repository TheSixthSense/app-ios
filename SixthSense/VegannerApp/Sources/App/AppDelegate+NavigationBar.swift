//
//  AppDelegate+NavigationBar.swift
//  VegannerApp
//
//  Created by Allie Kim on 2022/08/14.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit

extension AppDelegate {

    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()

        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBar.appearance().standardAppearance
        UINavigationBar.appearance().isTranslucent = false
    }
}
