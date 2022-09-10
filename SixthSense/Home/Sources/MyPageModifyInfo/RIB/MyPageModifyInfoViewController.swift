//
//  MyPageModifyInfoViewController.swift
//  Home
//
//  Created by Allie Kim on 2022/09/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Account
import RxAppState
import DesignSystem

final class MyPageModifyInfoViewController: UIViewController, MyPageModifyInfoPresentable, MyPageModifyInfoViewControllable {

    weak var handler: MyPageModifyInfoPresenterHandler?
    weak var action: MyPageModifyInfoPresenterAction?

    private let modifyType: ModifyType

    private var iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = false
    }

    private var doneButton = AppButton(title: "수정").then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let backButton = UIBarButtonItem().then {
        $0.image = AppIcon.back
        $0.tintColor = .systemGray500
    }

    let nicknameView: NicknameStepViewController = .init()
    let genderView: GenderStepViewController = .init()
    let birthView: BirthStepViewController = .init()
    let veganStageView: VeganStepViewController = .init()

    var currentView: UIViewController?

    private let disposeBag = DisposeBag()

    init(type: ModifyType) {
        self.modifyType = type
        super.init(nibName: nil, bundle: nil)
        action = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
}

extension MyPageModifyInfoViewController {

    private func configureUI() {
        view.backgroundColor = .white
        getModifyView()
        configureNavigationBar()

        guard let currentView = currentView else { return }

        view.addSubviews(iconImageView, currentView.view, doneButton)
        iconImageView.image = modifyType.stepIcon
    }

    private func configureLayout() {
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.top.equalToSuperview().offset(48)
            make.size.equalTo(80)
        }

        doneButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(view.safeAreaInsets.bottom + 44)
        }

        guard let currentView = currentView else { return }

        currentView.view.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(24)
            make.left.right.bottom.equalToSuperview()
        }
    }

    private func getModifyView() {
        switch modifyType {
        case .nickname:
            self.currentView = nicknameView
        case .gender:
            self.currentView = genderView
        case .birthday:
            self.currentView = birthView
        case .veganStage:
            self.currentView = veganStageView
        }
    }

    private func configureNavigationBar() {
        navigationItem.titleView = UILabel().then {
            $0.text = "회원 정보 수정"
            $0.font = AppFont.body1Bold
            $0.textColor = AppColor.systemBlack
            $0.numberOfLines = 1
            $0.sizeToFit()
        }

        navigationItem.leftBarButtonItem = backButton
    }

    private func bind() {
        rx.viewDidLayoutSubviews
            .take(1)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
            owner.configureLayout()
        }).disposed(by: disposeBag)
    }
}

extension MyPageModifyInfoViewController: MyPageModifyInfoPresenterAction {
    var didTapBackButton: Observable<Void> { backButton.rx.tap.throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance) }
}
