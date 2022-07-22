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
import DesignSystem
import AssetsLibrary

protocol SplashPresentableListener: AnyObject {}

final class SplashViewController: UIViewController, SplashPresentable, SplashViewControllable {
    
    weak var listener: SplashPresentableListener?
    
    private let logoImage = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(asset: SplashAsset.splashLogo)
    }
    
    private let titleImage = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(asset: SplashAsset.splashTitle)
    }
    
    override func viewDidLoad() {
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .sub100
        view.addSubviews([logoImage, titleImage])
        configureConstraints()
    }
    
    private func configureConstraints() {
        logoImage.snp.makeConstraints {
            $0.centerX.equalToSuperview().multipliedBy(0.922)
            $0.centerY.equalToSuperview().multipliedBy(0.876)
            $0.width.equalTo(124)
            $0.height.equalTo(134)
        }
        
        titleImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(101.03)
            $0.height.equalTo(51.4)
            $0.top.equalTo(logoImage.snp.bottom).offset(9)
        }
    }
}
