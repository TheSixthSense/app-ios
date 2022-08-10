//
//  ChallengeRegisterViewController.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import Then
import DesignSystem

protocol ChallengeRegisterPresentableListener: AnyObject {
}

final class ChallengeRegisterViewController: UIViewController, ChallengeRegisterPresentable, ChallengeRegisterViewControllable {

    weak var listener: ChallengeRegisterPresentableListener?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

private extension ChallengeRegisterViewController {

    private func configureUI() {
        view.backgroundColor = .white
        setNavigationBar()
    }

    private func setNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
                .font: AppFont.title1Bold,
                .foregroundColor: AppColor.systemBlack.cgColor]
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationBar.isTranslucent = false
        appearance.titleTextAttributes = titleTextAttributes
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance

        let backButton = UIButton().then {
            $0.setImage(AppIcon.back, for: .normal)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        // TODO: title 넣기
    }
}
