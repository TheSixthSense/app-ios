//
//  ImageButton.swift
//  Account
//
//  Created by Allie Kim on 2022/07/20.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import SnapKit
import DesignSystem

public final class ImageButton: UIView {

    public var hasFocused: Bool = false {
        didSet {
            let title = textLabel.text ?? ""
            hasFocused ? setButtonTitleFocused(with: title) : setButtonTitle(with: title)
        }
    }

    var titleColor: AppColor = .systemGray500 {
        willSet {
            textLabel.textColor = newValue
        }
    }

    var borderColor: AppColor = .systemGray300 {
        willSet {
            layer.borderColor = newValue.cgColor
        }
    }

    private let imageView = UIImageView().then { view in
        view.contentMode = .scaleAspectFit
    }

    private let textLabel = UILabel().then { label in
        label.contentMode = .left
        label.numberOfLines = 0
    }

    var defaultImage: UIImage?
    var focusedImage: UIImage?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(defaultImage: UIImage, focusedImage: UIImage, text: String) {
        self.init(frame: .zero)
        self.defaultImage = defaultImage
        self.focusedImage = focusedImage
        textLabel.attributedText = NSAttributedString(
            string: text,
            attributes: [.font: AppFont.body1,
                             .foregroundColor: AppColor.systemGray500])

        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(18)
        }

        textLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.left)
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.bottom.equalToSuperview()
        }
    }

    private func configureUI() {
        addSubviews([imageView, textLabel])
        layer.borderWidth = 1
        layer.cornerRadius = 5
        layer.borderColor = AppColor.systemGray300.cgColor
        imageView.image = defaultImage
    }

    func setButtonTitle(with string: String) {
        backgroundColor = .white
        titleColor = .systemGray500
        borderColor = .systemGray300
        imageView.image = defaultImage
    }

    func setButtonTitleFocused(with string: String) {
        backgroundColor = .green100
        titleColor = .green700
        borderColor = .main
        imageView.image = focusedImage
    }
}
