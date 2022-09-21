//
//  HomeTabBarItem.swift
//  Home
//
//  Created by 문효재 on 2022/08/07.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit

class HomeTabBarItem: UITabBarItem {
    init(image: UIImage) {
        super.init()
        configureImage(image: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureImage(image: UIImage) {
        self.image = image
        imageInsets.top = 7
        imageInsets.bottom = -5
    }
}
