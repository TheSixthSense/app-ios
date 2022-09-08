//
//  AppAlertView.swift
//  UICore
//
//  Created by Allie Kim on 2022/08/23.
//

import Then
import SnapKit
import UIKit
import RxSwift
import RxCocoa
import DesignSystem

public enum Alert {
    enum View {
        static let tag: Int = 888
    }
}

public typealias AlertActionCompletion = ((AlertAction) -> Void)

public final class AppAlertView: UIView {

    private enum Constants {

        enum Inset {
            static let `default` = 20.0
            static let labelStackView = 40.0
        }

        enum Height {
            static let button = 50.0
        }

        enum Width {
            static let button = 142.0
        }

        enum Radius {
            static let alertView = 15.0
            static let button = 10.0
        }
    }

    private let alertTitle: String
    private let message: String

    private let alertView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = Constants.Radius.alertView
    }

    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .center
        $0.distribution = .fillEqually
    }

    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 1
        $0.font = AppFont.body2Bold
    }

    private let messageLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.font = AppFont.body2
    }

    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 11
        $0.distribution = .fillEqually
    }

    private let disposeBag = DisposeBag()

    init(alertTitle: String, message: String) {
        self.alertTitle = alertTitle
        self.message = message
        super.init(frame: UIScreen.main.bounds)
        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        backgroundColor = .black.withAlphaComponent(0.5)
        addSubview(alertView)
        alertView.addSubviews(labelStackView, buttonStackView)
        labelStackView.addArrangedSubviews(titleLabel, messageLabel)

        titleLabel.text = alertTitle
        messageLabel.text = message
    }

    private func configureLayout() {
        alertView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(Constants.Inset.default)
            $0.center.equalToSuperview()
        }

        labelStackView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(Constants.Inset.default)
            $0.top.equalToSuperview().offset(Constants.Inset.labelStackView)
            $0.bottom.equalTo(buttonStackView.snp.top).offset(-Constants.Inset.default)
        }

        buttonStackView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(Constants.Inset.default)
            $0.bottom.equalToSuperview().offset(-Constants.Inset.default)
            $0.height.equalTo(Constants.Height.button)
        }
    }

    private func makeButton(action: AlertAction) -> UIButton {
        let button = UIButton().then {
            $0.frame = CGRect(x: 0,
                              y: 0,
                              width: Constants.Width.button,
                              height: Constants.Height.button)
            $0.setAttributedTitle(NSAttributedString(string: action.title, attributes: action.style.attributes), for: .normal)
            $0.backgroundColor = action.style.background
            $0.layer.do {
                $0.borderColor = action.style.borderColor
                $0.borderWidth = 1
                $0.cornerRadius = Constants.Radius.button
                $0.masksToBounds = true
            }
        }
        return button
    }

    fileprivate func dismiss() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: AnimationOptions.curveEaseIn,
                       animations: {
                           self.alpha = 0
                       }, completion: { [weak self] _ in
                           self?.removeFromSuperview()
                       })
    }

    fileprivate func addButtons(action: AlertAction,
                                completion: AlertActionCompletion? = nil) {
        let button = makeButton(action: action)
        buttonStackView.addArrangedSubview(button)
        guard let completion = completion else { return }

        button.rx.tap
            .throttle(.seconds(2),
                      latest: false,
                      scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
            owner.dismiss()
            completion(action)
        })
            .disposed(by: disposeBag)
    }
}

public extension UIViewController {

    func showAlert(
        title: String,
        message: String,
        actions: [AlertAction]
    ) -> Observable<AlertAction.Style> {
        return Observable.create { observer in
            let alert = AppAlertView(alertTitle: title,
                                     message: message)

            actions.forEach { action in
                alert.addButtons(action: action) { action in
                    observer.onNext(action.style)
                    observer.onCompleted()
                }
            }

            if let prevAlert = UIWindow.key?.viewWithTag(Alert.View.tag) as? AppAlertView {
                prevAlert.removeFromSuperview()
            }
            UIWindow.key?.addSubview(alert)
            return Disposables.create { alert.dismiss() }
        }
    }

    func showErrorAlert(
        title: String,
        message: String,
        actionTitle: String
    ) -> Observable<Void> {
        return Observable.create { observer in
            let alert = AppAlertView(alertTitle: title,
                                     message: message)

            alert.addButtons(action: AlertAction.action(title: actionTitle, style: .error)) { _ in
                observer.onNext(())
                observer.onCompleted()
            }

            if let prevAlert = UIWindow.key?.viewWithTag(Alert.View.tag) as? AppAlertView {
                prevAlert.removeFromSuperview()
            }
            UIWindow.key?.addSubview(alert)
            return Disposables.create { alert.dismiss() }
        }
    }

}
