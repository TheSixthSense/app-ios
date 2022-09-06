//
//  MyPageWebViewViewController.swift
//  Home
//
//  Created by Allie Kim on 2022/09/06.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import SnapKit
import RIBs
import RxCocoa
import RxSwift
import UIKit
import WebKit
import DesignSystem

protocol MyPageWebViewPresentableListener: AnyObject {
    func pop()
}

final class MyPageWebViewViewController: UIViewController, MyPageWebViewPresentable, MyPageWebViewViewControllable {

    weak var listener: MyPageWebViewPresentableListener?

    private var webView = WKWebView().then {
        $0.scrollView.showsVerticalScrollIndicator = true
        $0.scrollView.showsHorizontalScrollIndicator = false
    }

    private let backButton = UIBarButtonItem().then {
        $0.image = AppIcon.back
        $0.tintColor = .systemGray500
    }

    private var navigationTitleView = UILabel().then {
        $0.font = AppFont.body1Bold
        $0.textColor = AppColor.systemBlack
        $0.numberOfLines = 1
        $0.sizeToFit()
    }

    private let disposeBag = DisposeBag()

    init(urlString: String, titleString: String) {
        navigationTitleView.text = titleString
        super.init(nibName: nil, bundle: nil)
        guard let url = URL(string: urlString) else { return }
        webView.load(URLRequest(url: url))
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
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
    }
}
extension MyPageWebViewViewController {

    private func configureUI() {
        view.backgroundColor = .white
        webView.backgroundColor = .white
        view.addSubview(webView)
        configureNavigationBar()
    }

    private func configureLayout() {
        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func configureNavigationBar() {
        navigationItem.titleView = navigationTitleView
        navigationItem.leftBarButtonItem = backButton
    }

    private func bind() {
        backButton.rx.tap
            .throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
            owner.listener?.pop()
        }).disposed(by: disposeBag)
    }
}
