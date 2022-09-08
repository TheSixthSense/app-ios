//
//  ChallengeCheckCompletePopUp.swift
//  Challenge
//
//  Created by 문효재 on 2022/09/08.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//


import Then
import SnapKit
import RxRelay
import UIKit
import DesignSystem
import UICore
import Lottie
import Kingfisher

final class ChallengeCheckCompletePopUp: UIViewController {
    private let celebrate = AnimationView().then {
        $0.contentMode = .scaleToFill
        $0.animation = Animation.celebrate
        $0.loopMode = .loop
        $0.play()
    }
    
    private let popUpView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 25
    }
    private let closeButton = UIButton().then {
        $0.setImage(AppIcon.close, for: .normal)
        $0.tintColor = .systemGray500
    }
    private let icon = UIImageView(image: DesignSystemAsset.brandIcon.image)
    private let titleImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    private let contentsImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    private let doneButton = AppButton(title: "다음에 또 함께할게!").then {
        $0.layer.cornerRadius = 10
        $0.hasFocused = true
    }
    
    // MARK: Properties
    private weak var dismissRelay: PublishRelay<Void>?
    
    init(dismissRelay: PublishRelay<Void>, data: ChallengeCheckComplete) {
        self.dismissRelay = dismissRelay
        super.init(nibName: nil, bundle: nil)
        configure(data: data)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureConstraints()
        bind()
    }
    
    func configure(data: ChallengeCheckComplete) {
        titleImageView.kf.setImage(with: data.titleImageURL)
        contentsImageView.kf.setImage(with: data.contentsImageURL)
    }
    
    func bind() {
        doneButton.addTarget(self, action: #selector(didTapDismissButton(_:)), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(didTapDismissButton(_:)), for: .touchUpInside)
    }
    
    func configureUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
               
        view.addSubviews(celebrate, popUpView, icon)
        popUpView.addSubviews(closeButton, titleImageView, contentsImageView, doneButton)
    }
    
    func configureConstraints() {
        celebrate.snp.makeConstraints {
            $0.width.equalTo(335)
            $0.width.equalTo(335)
            $0.centerY.equalTo(popUpView.snp.top)
            $0.centerX.equalTo(popUpView)
        }
        
        popUpView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(335)
            $0.height.equalTo(329)
        }
        
        icon.snp.makeConstraints {
            $0.width.equalTo(92)
            $0.height.equalTo(116)
            $0.centerX.equalTo(popUpView)
            $0.centerY.equalTo(popUpView.snp.top)
        }
        
        closeButton.snp.makeConstraints {
            $0.size.equalTo(12)
            $0.top.right.equalToSuperview().inset(20)
        }
        
        titleImageView.snp.makeConstraints {
            $0.height.equalTo(54)
            $0.left.right.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(icon.snp.bottom).offset(19)
        }
        
        contentsImageView.snp.makeConstraints {
            $0.height.equalTo(78)
            $0.left.right.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleImageView.snp.bottom).offset(14)
        }
        
        doneButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(25)
            $0.height.equalTo(50)
        }
    }
    
    @objc func didTapDismissButton(_ sender: UIButton) {
        dismiss(animated: true) { [weak self] in
            self?.dismissRelay?.accept(())
        }
    }
}
