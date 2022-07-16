//
//  SplashViewController.swift
//  VegannerAppDev
//
//  Created by 문효재 on 2022/07/12.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import Then
import Lottie

protocol SplashPresentableListener: AnyObject {}

final class SplashViewController: UIViewController, SplashPresentable, SplashViewControllable {
    
    weak var listener: SplashPresentableListener?
    
    private let logoImage = AnimationView().then {
        $0.contentMode = .scaleToFill
        $0.animation = Animation.named("temp_logo", bundle: .module)
        $0.loopMode = .loop
        $0.play()
    }
    
//    private let logoImage = UIImageView().then {
//        $0.contentMode = .scaleAspectFit
//        $0.image = .init(systemName:  "plus.rectangle")
//    }
    
    override func viewDidLoad() {
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(logoImage)
        configureConstraints()
    }
    
    private func configureConstraints() {
        logoImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(200)
        }
    }
}
