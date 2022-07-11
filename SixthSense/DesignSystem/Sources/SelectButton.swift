//
//  SelectButton.swift
//  DesignSystem
//
//  Created by Allie Kim on 2022/07/12.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit

//public enum SelectButtonType {
//    case singleLine
//    case doubleLine
//}

public final class SelectButton: UIButton {
    
    /// .touchUpInside event때 사용
    public var hasfocused: Bool = false {
        willSet {
            backgroundColor = newValue ? .main : .systemGray100
            titleColor = newValue ? .white : .systemGray300
        }
    }

    public var titleText: String {
        return titleLabel?.text ?? ""
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public convenience init(title: String) {
        self.init(frame: .zero)
        setButtonTitle(with: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private var titleColor: AppColor = .systemGray500 {
        willSet {
            setTitleColor(newValue, for: .normal)
        }
    }

    private func setButtonTitle(with string: String) {
        setAttributedTitle(NSAttributedString(
            string: string,
            attributes: [.font: AppFont.body1Bold]
        ), for: .normal)
        setTitleColor(titleColor, for: .normal)
    }

//    private func setButtonType(with type: SelectButtonType) {
//        switch type {
//        case .singleLine:
//            return contentHorizontalAlignment = .center
//        case .doubleLine:
//            contentHorizontalAlignment = .leading
//            contentVerticalAlignment = .top
//            return
//        }
//    }
}
