//
//  TextFieldErrorView.swift
//  Challenge
//
//  Created by 문효재 on 2022/09/06.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import DesignSystem

final class TextFieldErrorView: UIView {
    private enum Constants {
        static let description: (Int) -> String = { "\($0)자가 넘어갔어!" }
    }
    
    private let icon = UIImageView(image: AppIcon.error)
    
    private let descriptionLabel = UILabel().then {
        $0.font = AppFont.caption
        $0.textColor = .red500
    }
        
    private let disposeBag = DisposeBag()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
        configureConstraints()
    }
    
    init(maxCount: Int) {
        super.init(frame: .zero)
        descriptionLabel.text = Constants.description(maxCount)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViews() {
        addSubviews(icon, descriptionLabel)
    }
    
    func configureConstraints() {
        icon.snp.makeConstraints {
            $0.left.centerY.equalToSuperview()
            $0.size.equalTo(12)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.left.equalTo(icon.snp.right).offset(4)
        }
    }
}
