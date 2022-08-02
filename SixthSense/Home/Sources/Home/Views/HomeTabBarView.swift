//
//  HomeTabBarView.swift
//  Home
//
//  Created by 문효재 on 2022/08/01.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import Then
import SnapKit
import UIKit

struct HomeTabBarViewModel {
    let image: UIImage?
    let tapHandler: () -> Void
    
    init(image: UIImage?, tapHandler: @escaping () -> Void) {
        self.image = image
        self.tapHandler = tapHandler
    }
}

final class HomeTabBarView: UIView {
    
    init(viewModel: HomeTabBarViewModel) {
        super.init(frame: .zero)
        
        update(with: viewModel)
        configureUI()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private var tapHandler: (() -> Void)?
    
    private func update(with viewModel: HomeTabBarViewModel) {
        imageView.image = viewModel.image
        tapHandler = viewModel.tapHandler
    }
    
    private let imageView = UIImageView().then {
        $0.tintColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
        
    private func configureUI() {
        addSubviews(imageView)
        backgroundColor = .white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tap)
    }
    
    private func configureConstraints() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.center.equalToSuperview()
            $0.top.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(18)
        }
    }
    
    @objc
    private func didTap() {
        tapHandler?()
    }
}
