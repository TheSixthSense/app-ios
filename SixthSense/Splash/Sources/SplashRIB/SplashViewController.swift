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
        $0.image = UIImage(asset: DesignSystemAsset.biTitle)
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
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.876)
            $0.width.equalTo(103)
            $0.height.equalTo(130)
        }
        
        titleImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(93)
            $0.top.equalTo(logoImage.snp.bottom).offset(12)
        }
    }
}
