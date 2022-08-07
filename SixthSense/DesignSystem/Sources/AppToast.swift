//
//  AppToast.swift
//  DesignSystem
//
//  Created by Allie Kim on 2022/08/07.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit

public enum ToastType {
    case notice
    case error
}

final class AppToast: UILabel {

    init(type toastType: ToastType) {
        let window = UIApplication.shared.windows.first!
        super.init(frame: CGRect(x: 20,
                                 y: 0,
                                 width: window.frame.width - 40,
                                 height: 48))
        configureUI(style: toastType)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)))
    }


    func showToast(_ message: String, duration: Double = 2.0) {
        self.attributedText = NSAttributedString(
            string: message,
            attributes: [.font: AppFont.body1Bold]
        )

        let window = UIApplication.shared.windows.first!
        UIView.animate(withDuration: 0.2, animations: {
            self.frame = CGRect(x: 20,
                                y: window.frame.height * 0.15,
                                width: self.frame.width,
                                height: self.frame.height)
        }, completion: { (isCompleted) in
            if isCompleted {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.frame = CGRect(x: 20,
                                            y: 0,
                                            width: self.frame.width,
                                            height: self.frame.height)

                    }, completion: { _ in
                        self.removeFromSuperview()
                    })
                }
            }
        })
    }

    private func configureUI(style toastStyle: ToastType) {
        self.backgroundColor = toastStyle == .notice ? AppColor.systemBlack.withAlphaComponent(0.9) : AppColor.red500.withAlphaComponent(0.9)
        self.textColor = UIColor.white
        self.textAlignment = .center
        self.layer.cornerRadius = 24
        self.clipsToBounds = true
    }
}

public extension UIViewController {

    func showToast(_ message: String, toastType: ToastType = .notice) {
        let toast = AppToast(type: toastType)
        self.view.addSubview(toast)
        toast.showToast(message)
    }
}
