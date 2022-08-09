//
//  AppToast.swift
//  DesignSystem
//
//  Created by Allie Kim on 2022/08/07.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit

public enum Toast {

    public enum Style {
        case notice
        case error
    }

    public enum View {
        static let tag: Int = 999
    }
}

public final class AppToast: UILabel {

    private enum Constants {

        enum Frame {
            static let x: CGFloat = 20.0
            static let initalY: CGFloat = UIScreen.main.bounds.height * 0.15
            static let changedY: CGFloat = -40.0
            static let width: CGFloat = UIScreen.main.bounds.width - 40
            static let height: CGFloat = 48.0
            static let inset: CGFloat = 20.0
        }

        static let animation: CGFloat = 0.2
        static let radius: CGFloat = 24.0
    }

    init(type toastType: Toast.Style) {
        super.init(frame: CGRect(x: Constants.Frame.x,
                                 y: 0,
                                 width: Constants.Frame.width,
                                 height: Constants.Frame.height))
        configureUI(style: toastType)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets(top: 0, left: Constants.Frame.inset, bottom: 0, right: Constants.Frame.inset)))
    }


    func showToast(_ message: String, duration: Double = 2.0) {
        setTextLabel(message)

        UIView.animate(withDuration: Constants.animation, animations: {
            self.frame = CGRect(x: Constants.Frame.x,
                                y: Constants.Frame.initalY,
                                width: self.frame.width,
                                height: self.frame.height)
        }, completion: { (isCompleted) in
            if isCompleted {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    UIView.animate(withDuration: Constants.animation, animations: {
                        self.frame = CGRect(x: Constants.Frame.x,
                                            y: Constants.Frame.changedY,
                                            width: self.frame.width,
                                            height: self.frame.height)

                    }, completion: { _ in
                        self.removeFromSuperview()
                    })
                }
            }
        })
    }

    private func configureUI(style toastStyle: Toast.Style) {
        self.tag = Toast.View.tag
        self.backgroundColor = toastStyle == .notice ? AppColor.systemBlack.withAlphaComponent(0.9) : AppColor.red500.withAlphaComponent(0.9)
        self.textColor = UIColor.white
        self.textAlignment = .center
        self.layer.cornerRadius = Constants.radius
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
        let swipe = UIPanGestureRecognizer(target: self, action: #selector(toastSwiped))
        self.addGestureRecognizer(swipe)
    }

    private func setTextLabel(_ message: String) {
        self.attributedText = NSAttributedString(
            string: message,
            attributes: [.font: AppFont.body1Bold]
        )
    }

    @objc
    private func toastSwiped(_ gesture: UIPanGestureRecognizer) {
        let minVelocity: CGFloat = 80.0
        if gesture.state == .began {
            if abs(gesture.velocity(in: self).y) > minVelocity {
                UIView.animate(withDuration: 0.1, animations: {
                    self.frame = CGRect(x: Constants.Frame.x,
                                        y: Constants.Frame.changedY,
                                        width: self.frame.width,
                                        height: self.frame.height)

                }, completion: { _ in
                    self.removeFromSuperview()
                })
            }
        }
    }
}

public extension UIViewController {

    func showToast(_ message: String, toastStyle: Toast.Style = .notice) {
        guard let window = UIApplication.shared.windows.first else { return }
        if let prevToast = window.viewWithTag(Toast.View.tag) as? AppToast {
            prevToast.removeFromSuperview()
        }
        let toast = AppToast(type: toastStyle)
        window.addSubview(toast)
        toast.showToast(message)
    }
}
