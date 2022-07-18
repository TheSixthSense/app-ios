//
//  AppLabel.swift
//  DesignSystem
//
//  Created by Allie Kim on 2022/07/15.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit

public final class AppLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public convenience init() {
        self.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setText(_ text: String, font: UIFont) {
        attributedText = NSAttributedString(
            string: text,
            attributes: [.font: font]
        )
    }
}

private extension AppLabel {

    private func configure() {
        textColor = .systemBlack
        textAlignment = .left
        lineBreakMode = .byWordWrapping
        numberOfLines = .zero
    }
}
