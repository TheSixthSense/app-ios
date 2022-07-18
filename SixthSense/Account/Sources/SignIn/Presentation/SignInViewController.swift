//
//  SignInViewController.swift
//  Account
//
//  Created by 문효재 on 2022/07/15.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Lottie
import DesignSystem
import AuthenticationServices

protocol SignInPresentableListener: AnyObject {
    func signIn()
    func skip()
}

final class SignInViewController: UIViewController, SignInPresentable, SignInViewControllable {

    weak var listener: SignInPresentableListener?
    private let disposeBag: DisposeBag = .init()
    
    private let logoImage = AnimationView().then {
        $0.contentMode = .scaleToFill
        $0.animation = .logo
        $0.loopMode = .loop
        $0.play()
    }
    
    private let catchphraseLabel = UILabel().then {
        $0.text = "브랜드 관련 캐치프라이즈 영역\n두줄정도면 좋을 것 같아요"
        $0.textAlignment = .center
        $0.font = AppFont.body1Bold
        $0.textColor = AppColor.systemBlack
        $0.numberOfLines = 2
        $0.sizeToFit()
    }
    
    private lazy var signInButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black).then {
        $0.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside)
    }
    
    // FIXME: - 추후 디자인시스템으로 변경해요
    private let skipButton = UIButton().then {
        $0.setTitle("회원가입 없이 시작하기", for: .normal)
        $0.titleLabel?.font = AppFont.body1Bold
        $0.titleLabel?.textColor = .white
        $0.backgroundColor = .main
        $0.layer.cornerRadius = 5
        $0.addTarget(self, action: #selector(skipButtonDidTap), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        configureUI()
    }
        
    func configureUI() {
        [logoImage, catchphraseLabel, signInButton, skipButton].forEach {
            view.addSubview($0)
        }
        
        configureConstraints()
    }
    
    func configureConstraints() {
        logoImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(188)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(150)
        }
        
        catchphraseLabel.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        signInButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(skipButton.snp.top).offset(-12)
            $0.height.equalTo(50)
        }
        
        skipButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-92)
            $0.height.equalTo(50)
        }
    }
}

// MARK: - Bind Method
extension SignInViewController {
    @objc
    private func signInWithApple() {
        self.listener?.signIn()
    }
    
    @objc
    private func skipButtonDidTap() {
        self.listener?.skip()
    }
}
