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
import DesignSystem
import AuthenticationServices
import Then

protocol SignInPresentableListener: AnyObject {
    func signIn()
    func skip()
}

final class SignInViewController: UIViewController, SignInPresentable, SignInViewControllable {

    weak var listener: SignInPresentableListener?
    private let disposeBag: DisposeBag = .init()
    
    private let logoImage = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(asset: DesignSystemAsset.biTitleWhite)
    }
    
    private let catchphraseLabel = UILabel().then {
        $0.text = "완벽하지 않아도 괜찮아요\n지구를 위한 작은 하루 실천 하나"
        $0.textAlignment = .center
        $0.font = AppFont.body1
        $0.textColor = .white
        $0.numberOfLines = 2
        $0.sizeToFit()
    }
    
    private var signInButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.setTitle("Apple로 계속하기", for: .normal)
        $0.setImage(.init(systemName: "applelogo"), for: .normal)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .white
        $0.tintColor = .black
        $0.titleLabel?.font = UIFont(font: AppFont.Pretendard.bold, size: 17)
        $0.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside)
    }
    
    private lazy var skipButton = UIButton().then {
        $0.setTitle("회원가입 없이 시작하기", for: .normal)
        $0.titleLabel?.font = AppFont.body2
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(skipButtonDidTap), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .sub100
        configureUI()
    }
        
    func configureUI() {
        view.backgroundColor = .main
        view.addSubviews(logoImage, catchphraseLabel, signInButton, skipButton)
        configureConstraints()
    }
    
    func configureConstraints() {
        logoImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.562)
            $0.width.equalTo(242)
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
    
    func showAlert(title: String?, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(closeAction)
        present(alert, animated: true, completion: nil)
    }
}
