//
//  SelectButton.swift
//  DesignSystem
//
//  Created by Allie Kim on 2022/07/12.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit

public enum SelectButtonType {
    case singleLine
    case doubleLine
}

public final class SelectButton: UIButton, ButtonProtocol {

    public var hasFocused: Bool = false {
        didSet {
            didFocused(hasFocused)
        }
    }

    var titleColor: AppColor = .systemGray500 {
        willSet {
            setTitleColor(newValue, for: .normal)
        }
    }

    var borderColor: AppColor = .systemGray300 {
        willSet {
            layer.borderColor = newValue.cgColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public convenience init(title: String, type: SelectButtonType = .singleLine) {
        self.init(frame: .zero)
        layer.borderWidth = 1
        layer.cornerRadius = 5
        layer.borderColor = AppColor.systemGray300.cgColor
        setButtonTitle(with: title)
        setButtonType(with: type)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func didFocused(_ focused: Bool) {
        let title = titleLabel?.text ?? ""
        focused ? setButtonTitleFocused(with: title) : setButtonTitle(with: title)
    }

    func setButtonTitle(with string: String) {

        backgroundColor = .white
        titleColor = .systemGray500
        borderColor = .systemGray300

        setAttributedTitle(NSAttributedString(
            string: string,
            attributes: [.font: AppFont.body1]
        ), for: .normal)
    }

    func setButtonTitleFocused(with string: String) {
        backgroundColor = .green100
        titleColor = .green700
        borderColor = .main
    }
}

private extension SelectButton {

    private func setButtonType(with type: SelectButtonType) {
        switch type {
        case .singleLine:
            return contentHorizontalAlignment = .center
        case .doubleLine:
            contentEdgeInsets.left = 20
            contentHorizontalAlignment = .left
            titleLabel?.lineBreakMode = .byWordWrapping
            return
        }
    }
}
