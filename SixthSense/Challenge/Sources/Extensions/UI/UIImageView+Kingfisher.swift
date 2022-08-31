//
//  UIImageView+Kingfisher.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/29.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import SVGKit
import Kingfisher

extension UIImageView {

    func setImage(with urlString: String) {
        let url = URL(string: urlString) ?? URL(string: "")
        self.kf.indicatorType = .activity

        self.kf.setImage(
            with: url,
            placeholder: nil,
            options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
            ],
            progressBlock: nil,
            completionHandler: { _ in })
    }

    func setImage(with urlString: String, imageSize: CGSize) {
        let url = URL(string: urlString) ?? URL(string: "")
        let imageProcessor = DownsamplingImageProcessor(size: imageSize)
        self.kf.indicatorType = .activity

        self.kf.setImage(
            with: url,
            placeholder: nil,
            options: [
                    .processor(imageProcessor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
            ],
            progressBlock: nil,
            completionHandler: { _ in })
    }
}
