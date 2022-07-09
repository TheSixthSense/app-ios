//
//  AppDelegate.swift
//  SixthSense
//
//  Created by 문효재 on 2022/06/27.
//

import RIBs
import Then
import UIKit
import Storage

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var launchRouter: LaunchRouting?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        configureDebug()

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        let launchRouter = RootBuilder(dependency: AppComponent()).build()
        self.launchRouter = launchRouter
        launchRouter.launch(from: window)

        return true
    }
}

