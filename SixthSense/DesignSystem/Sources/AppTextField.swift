//
//  AppTextField.swift
//  DesignSystem
//
//  Created by Allie Kim on 2022/07/11.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit

public final class AppTextField: UITextField {

    public var maxLength: Int = 0

    public var isValidText: Bool = true {
        willSet {
            newValue ? validTextField() : invalidTextField()
        }
    }

    /// errorString 적용
    public var errorString: String = "" {
        willSet {
            enableErrorLabel(message: newValue)
        }
    }

    private lazy var errorIcon: UIImageView = {
        let imageView = UIImageView(image: AppIcon.error)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    /// placeholder 적용
    public var placeholderString: String = "" {
        willSet {
            attributedPlaceholder = NSAttributedString(
                string: newValue,
                attributes: [.foregroundColor: AppColor.systemGray500,
                                 .font: AppFont.body1]
            )
        }
    }

    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        addObserver()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AppTextField {

    private func configure() {
        textColor = .systemBlack
        layer.borderWidth = 1.0
        layer.cornerRadius = 10.0
        leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0))
        leftViewMode = .always

        validTextField()
    }

    private func validTextField() {
        layer.borderColor = AppColor.systemGray300.cgColor
        errorLabel.isHidden = true
        errorIcon.isHidden = true
    }

    private func invalidTextField() {
        layer.borderColor = AppColor.red500.cgColor
        errorLabel.isHidden = false
        errorIcon.isHidden = false
    }

    private func enableErrorLabel(message: String) {
        addSubview(errorLabel)
        addSubview(errorIcon)
        errorLabel.attributedText = NSAttributedString(
            string: message,
            attributes: [.foregroundColor: AppColor.red500,
                             .font: AppFont.caption]
        )

        NSLayoutConstraint.activate([
            errorIcon.topAnchor.constraint(equalTo: bottomAnchor),
            errorIcon.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorIcon.widthAnchor.constraint(equalToConstant: 16),
            errorIcon.heightAnchor.constraint(equalToConstant: 16),
            errorLabel.topAnchor.constraint(equalTo: bottomAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: errorIcon.trailingAnchor, constant: 4),
        ])
    }

    private func addObserver() {
        addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
    }

    @objc
    private func checkMaxLength() {
        guard let text = self.text else { return }
        if text.count > maxLength {
            deleteBackward()
        }
    }
}
