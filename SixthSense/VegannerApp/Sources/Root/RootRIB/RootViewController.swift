//
//  RootViewController.swift
//  SixthSense
//
//  Created by Allie Kim on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

public protocol RootPresentableListener: AnyObject {}

final class RootViewController: UINavigationController, RootPresentable, RootViewControllable {
    
    weak var listener: RootPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
