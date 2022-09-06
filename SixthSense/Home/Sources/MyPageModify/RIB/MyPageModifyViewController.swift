//
//  MyPageModifyViewController.swift
//  Home
//
//  Created by Allie Kim on 2022/09/06.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import SnapKit
import Then
import RIBs
import RxSwift
import UIKit
import DesignSystem

final class MyPageModifyViewController: UIViewController, MyPageModifyPresentable, MyPageModifyViewControllable {

    var handler: MyPageModifyPresenterHandler?
    var action: MyPageModifyPresenterAction?

    private var stackView = UIStackView().then {
        $0.alignment = .fill
        $0.distribution = .fill
        $0.axis = .vertical
        $0.spacing = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let backButton = UIBarButtonItem().then {
        $0.image = AppIcon.back
        $0.tintColor = .systemGray500
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension MyPageModifyViewController {

    private func configureUI() {
        view.backgroundColor = .white
//        stackView.do {
//                  $0.addArrangedSubviews(titleView, photoButton, commentHeaderLabel, commentField)
//                  $0.setCustomSpacing(16, after: titleView)
//                  $0.setCustomSpacing(30, after: photoButton)
//                  $0.setCustomSpacing(12, after: commentHeaderLabel)
//        }
    }

    private func configureLayout() {

    }

    private func bind() {

    }

    private func configureNavigationBar() {
        navigationItem.titleView = UILabel().then {
            $0.text = "개인 정보 수정"
            $0.font = AppFont.body1Bold
            $0.textColor = AppColor.systemBlack
            $0.numberOfLines = 1
            $0.sizeToFit()
        }

        navigationItem.leftBarButtonItem = backButton
    }
}

extension MyPageModifyViewController: MyPageModifyPresenterAction {

}
