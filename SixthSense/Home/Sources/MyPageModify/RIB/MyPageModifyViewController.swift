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
import RxCocoa
import UIKit
import RxAppState
import DesignSystem

final class MyPageModifyViewController: UIViewController, MyPageModifyPresentable, MyPageModifyViewControllable {

    weak var handler: MyPageModifyPresenterHandler?
    weak var action: MyPageModifyPresenterAction?

    private var stackView = UIStackView().then {
        $0.distribution = .fill
        $0.axis = .vertical
        $0.spacing = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private var nameSubView = UserInfoview().then {
        $0.titleLabel.do {
            $0.text = "이름"
            $0.sizeToFit()
        }
    }

    private var genderSubView = UserInfoview().then {
        $0.titleLabel.do {
            $0.text = "성별"
            $0.sizeToFit()
        }
    }

    private var birthSubView = UserInfoview().then {
        $0.titleLabel.do {
            $0.text = "생일"
            $0.sizeToFit()
        }
    }

    private var veganStageSubView = UserInfoview().then {
        $0.titleLabel.do {
            $0.text = "비건단계"
            $0.sizeToFit()
        }
    }

    private var withdrawButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setAttributedTitle(NSAttributedString(
            string: "계정 탈퇴",
            attributes: [.font: AppFont.body2,
                             .foregroundColor: AppColor.systemGray500]
        ), for: .normal)
    }

    private let backButton = UIBarButtonItem().then {
        $0.image = AppIcon.back
        $0.tintColor = .systemGray500
    }

    private let withDrawRelay: PublishRelay<Void> = .init()

    private let disposeBag = DisposeBag()

    init() {
        super.init(nibName: nil, bundle: nil)
        action = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension MyPageModifyViewController {

    private func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        view.addSubviews(stackView, withdrawButton)
        stackView.addArrangedSubviews(nameSubView, genderSubView, birthSubView, veganStageSubView)
    }

    private func configureLayout() {
        stackView.snp.makeConstraints {
            $0.height.equalTo(232)
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().inset(16)
        }

        withdrawButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview().inset(150)
        }
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

    private func bind() {
        bindHandler()

        withdrawButton.rx.tap
            .throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
            owner.presentWithDrawAlert()
        }).disposed(by: disposeBag)
    }

    private func bindHandler() {
        guard let handler = handler else { return }

        disposeBag.insert {

            handler.userInfoPayload
                .map(\.nickname)
                .bind(to: nameSubView.userDataLabel.rx.text)

            handler.userInfoPayload
                .map(\.gender.localized)
                .bind(to: genderSubView.userDataLabel.rx.text)

            handler.userInfoPayload
                .map(\.birthDay)
                .bind(to: birthSubView.userDataLabel.rx.text)

            handler.userInfoPayload
                .map(\.vegannerStage.localized)
                .bind(to: veganStageSubView.userDataLabel.rx.text)

        }
    }

    private func presentWithDrawAlert() {
        showAlert(title: "비거너 계정을 삭제할거야?",
                  message: "그동안 비거너를 이용해 주셔서 감사해요\n그리고.. 삭제 시 챌린지와 인증글은 모두 사라져요😢",
                  actions: [.action(title: "앗.. 잘못 눌렀어..", style: .negative),
                                .action(title: "응, 잘 지내..ㅠㅠ", style: .positive)])
            .filter { $0 == .positive }
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
            owner.withDrawRelay.accept(())
        }).disposed(by: disposeBag)
    }
}

extension MyPageModifyViewController: MyPageModifyPresenterAction {
    var viewWillAppear: Observable<Void> { rx.viewWillAppear.map { _ in () } }
    var didTapBackButton: Observable<Void> { backButton.rx.tap.throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance) }
    var withDrawConfirmed: Observable<Void> { withDrawRelay.asObservable() }
}
