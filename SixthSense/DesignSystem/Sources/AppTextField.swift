//
//  AppTextField.swift
//  DesignSystem
//
//  Created by Allie Kim on 2022/07/11.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit

public final class AppTextField: UITextField {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func enablePlaceholder(with string: String) {
        attributedPlaceholder = NSAttributedString(
            string: string,
            attributes: [.foregroundColor: AppColor.systemGray500, .font: AppFont.body1]
        )
    }
}

extension AppTextField {

    private func configure() {
        textColor = .systemBlack
        layer.borderColor = AppColor.systemGray300.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0

        leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0))
        leftViewMode = .always
    }
}

//extension AppTextField: UITextFieldDelegate {
//    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let text = textField.text,
//            let rangeOfTextToReplace = Range(range, in: text) else {
//            return false
//        }
//        let substringToReplace = text[rangeOfTextToReplace]
//        let count = text.count - substringToReplace.count + string.count
//        return count <= 10
//    }
//}
