//
//  ChallengeEmptyView.swift
//  Home
//
//  Created by 문효재 on 2022/08/23.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import RxSwift
import DesignSystem
import SnapKit

final class ChallengeEmptyView: UIView {
    private let background = UIView().then {
        $0.backgroundColor = .green100
        $0.layer.cornerRadius = 15
    }
    private let container = UIView()
    private let image = UIImageView(image: HomeAsset.challengeEmpty.image)
    private let caption = UILabel().then {
        $0.text = "등록한 챌린지가 없어요!"
        $0.textColor = .green700
        $0.font = AppFont.caption
        $0.numberOfLines = 1
        $0.sizeToFit()
    }
    private let title = UILabel().then {
        $0.text = "비건 한번 도전해 볼까?"
        $0.textColor = .systemBlack
        $0.font = AppFont.body2Bold
        $0.numberOfLines = 1
        $0.sizeToFit()
    }
    let button = AppButton(title: "도전 하기").then {
        $0.layer.cornerRadius = 10
        $0.hasFocused = true
    }

    private let disposeBag = DisposeBag()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        addSubviews(background)
        background.addSubviews(container)
        container.addSubviews(image, caption, title, button)
    }
    
    func configureConstraints() {
        background.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20))
        }
        
        container.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        image.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(42)
            $0.height.equalTo(53)
        }
        
        caption.snp.makeConstraints {
            $0.top.equalTo(image.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        title.snp.makeConstraints {
            $0.top.equalTo(caption.snp.bottom).offset(2)
            $0.centerX.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.left.right.bottom.equalToSuperview()
            $0.width.equalTo(139)
            $0.height.equalTo(50)
        }
    }
}

extension Reactive where Base: ChallengeEmptyView {
    var tap: Observable<Void> {
        base.button.rx.controlEvent(.editingDidBegin).map { _ in () }
    }
}
