//
//  AppButton.swift
//  DesignSystem
//
//  Created by Allie Kim on 2022/07/12.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit

public final class AppButton: UIButton, ButtonProtocol {

    /// .touchUpInside event때 사용
    public var hasFocused: Bool = false {
        didSet {
            didFocused(hasFocused)
        }
    }

    public var titleText: String {
        get {
            return titleLabel?.text ?? ""
        }
        set {
            setButtonTitle(with: newValue)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public convenience init(title: String) {
        self.init(frame: .zero)
        setButtonTitle(with: title)
        backgroundColor = .systemGray100
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func didFocused(_ focused: Bool) {
        backgroundColor = focused ? .main : .systemGray100
        titleColor = focused ? .white : .systemGray300
        isUserInteractionEnabled = focused
    }

    // MARK: - ButtonProtocol

    var titleColor: AppColor = .systemGray300 {
        willSet {
            setTitleColor(newValue, for: .normal)
        }
    }

    func setButtonTitle(with string: String) {
        setAttributedTitle(NSAttributedString(
            string: string,
            attributes: [.font: AppFont.body1Bold]
        ), for: .normal)
        setTitleColor(titleColor, for: .normal)
    }
}
