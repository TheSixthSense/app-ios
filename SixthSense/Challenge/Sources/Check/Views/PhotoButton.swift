//
//  PhotoInputButton.swift
//  Challenge
//
//  Created by 문효재 on 2022/08/29.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import DesignSystem

final class PhotoButton: UIView {
    private let disposeBag = DisposeBag()
    private let cameraIcon = UIImageView(image: ChallengeAsset.camera.image)
    let preview = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    let button = UIButton()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        self.do {
            $0.backgroundColor = .green100
        }
        
        addSubviews(cameraIcon, preview, button)
    }
    
    func configureConstraints() {
        cameraIcon.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(52)
        }
        
        preview.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension Reactive where Base: PhotoButton {
    var tap: Observable<Void> { base.button.rx.tap.map { _ in () } }
}
