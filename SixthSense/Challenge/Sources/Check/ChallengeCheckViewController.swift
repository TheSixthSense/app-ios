//
//  ChallengeCheckViewController.swift
//  Challenge
//
//  Created by 문효재 on 2022/08/23.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Foundation
import DesignSystem
import UICore
import PhotosUI

protocol ChallengeCheckPresentableListener: AnyObject {}

final class ChallengeCheckViewController: UIViewController, ChallengeCheckPresentable, ChallengeCheckViewControllable {
    private let disposeBag = DisposeBag()
    weak var handler: ChallengeCheckPresenterHandler?
    weak var action: ChallengeCheckPresenterAction?
    
    private enum Constants { }
    
    private let backButton = UIBarButtonItem().then {
        $0.image = AppIcon.back
        $0.tintColor = .systemGray500
    }
    private let contentsView = UIView()
    
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.alignment = .fill
        $0.distribution = .fill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let titleView = UIView()
    
    private let imageHeaderLabel = UILabel().then {
        $0.text = "오늘 나의 챌린지?"
        $0.textColor = .systemBlack
        $0.font = AppFont.body1Bold
        $0.numberOfLines = 1
        $0.sizeToFit()
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "* 사진 추가는 필수예요"
        $0.textColor = .main
        $0.font = AppFont.caption
        $0.numberOfLines = 1
        $0.sizeToFit()
    }
    
    private let photoButton = PhotoButton().then {
        $0.layer.cornerRadius = 30
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = true
    }
    
    let commentHeaderLabel = UILabel().then {
        $0.text = "자유롭게 써도 좋아"
        $0.textColor = .systemBlack
        $0.font = AppFont.body1Bold
        $0.numberOfLines = 1
        $0.sizeToFit()
    }
    
    let commentField = CommentInputField(maxCount: 200).then {
        $0.translatesAutoresizingMaskIntoConstraints = true
    }
    
    private let button = AppButton(title: "인증까지 완료!").then {
        $0.layer.cornerRadius = 10
    }
    
    // MARK: Properties
    let imageRelay: PublishRelay<UIImage?> = .init()
    private let backRelay: PublishRelay<Void> = .init()
    private let doneRelay: PublishRelay<ChallengeCheckRequest> = .init()

    init() {
        super.init(nibName: nil, bundle: nil)
        action = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureViews()
        configureConstraints()
        bind()
        scrollView.delegate = self
    }
    
    private func configureViews() {
        view.backgroundColor = .white
        view.addSubviews(contentsView, button)
        contentsView.addSubviews(scrollView)
        stackView.do {
            $0.addArrangedSubviews(titleView, photoButton, commentHeaderLabel, commentField)
            $0.setCustomSpacing(16, after: titleView)
            $0.setCustomSpacing(30, after: photoButton)
            $0.setCustomSpacing(12, after: commentHeaderLabel)
        }
        scrollView.addSubview(stackView)
        titleView.addSubviews(imageHeaderLabel, descriptionLabel)
    }
    
    private func configureConstraints() {
        contentsView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalTo(button.snp.top).offset(-32)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.edges.equalTo(scrollView.contentLayoutGuide.snp.edges)
            $0.height.equalTo(scrollView.frameLayoutGuide.snp.height).priority(1)
        }
        
        imageHeaderLabel.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
        }
        imageHeaderLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        descriptionLabel.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.left.equalTo(imageHeaderLabel.snp.right).offset(12)
        }
        
        photoButton.snp.makeConstraints {
            $0.height.equalTo(photoButton.snp.width)
        }
                
        button.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(68)
        }
    }
    
    private func bind() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        
        photoButton.rx.tap
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                self?.showActionSheet()
            })
            .disposed(by: self.disposeBag)
        
        imageRelay
            .subscribe(onNext: { [weak self] in
                self?.photoButton.preview.image = $0
            })
            .disposed(by: self.disposeBag)
        
        backButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.showBackConfirmAlert()
            })
            .disposed(by: self.disposeBag)
        
        button.rx.tap
            .withLatestFrom(imageRelay.asObservable()) { $1 }
            .withLatestFrom(commentField.rx.text) { image, text in
                ChallengeCheckRequest(image: image, text: text)
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, request in
                owner.showRequestConfirmAlert(request)
            })
            .disposed(by: self.disposeBag)

        guard let handler = handler else { return }
        
        handler.doneButtonActive
            .bind(to: button.rx.hasFocused)
            .disposed(by: self.disposeBag)
        
        handler.showDonePopUp
            .asDriver(onErrorJustReturn: .init())
            .drive(onNext: { [weak self] in
                self?.showCompletePopUp($0)
            })
            .disposed(by: self.disposeBag)
    }

    private func configureNavigationBar() {
        navigationItem.titleView = UILabel().then {
            $0.text = "챌린지 등록"
            $0.font = AppFont.body1Bold
            $0.textColor = AppColor.systemBlack
            $0.numberOfLines = 1
            $0.sizeToFit()
        }
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func showActionSheet() {
        let cameraAction = UIAlertAction(title: "사진 찍기", style: .default) { [weak self] _ in
            self?.checkCameraPermission()
        }
        
        let albumAction = UIAlertAction(title: "사진 선택", style: .default) { [weak self] _ in
            self?.showPhotoPickerView()
        }
        
        let cancleAction = UIAlertAction(title: "취소", style: .cancel)
        
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: UIAlertController.Style.actionSheet)

        [cameraAction, albumAction, cancleAction].forEach { alert.addAction($0) }
        self.present(alert, animated: true)
    }
    
    private func showBackConfirmAlert() {
        showAlert(title: "챌린지 인증을 종료할거야?",
                        message: "아쉽지만🥲 다음에 다른 챌린지로 또 만나요!",
                        actions: [.action(title: "앗..실수였어..", style: .negative),
                                  .action(title: "응, 종료할게", style: .positive)])
        .filter { $0 == .positive }
        .withUnretained(self)
        .subscribe(onNext: { owner, _ in
            owner.backRelay.accept(())
        })
        .disposed(by: self.disposeBag)
    }
    
    private func showRequestConfirmAlert(_ request: ChallengeCheckRequest) {
        showAlert(title: "🚨 챌린지 인증 주의사항 🚨",
                        message: "인증 후에는 수정이 어려우니\n한번 더 꼼꼼히 확인하는 걸 추천해요",
                        actions: [.action(title: "앗, 다시 보고올게", style: .negative),
                                  .action(title: "응, 문제없어", style: .positive)])
        .filter { $0 == .positive }
        .withUnretained(self)
        .subscribe(onNext: { owner, _ in
            owner.doneRelay.accept(request)
        })
        .disposed(by: self.disposeBag)
    }
    
    private func showCompletePopUp(_ data: ChallengeCheckComplete) {
        let popUpViewController = ChallengeCheckCompletePopUp(dismissRelay: backRelay, data: data)
        popUpViewController.modalPresentationStyle = .overCurrentContext
        present(popUpViewController, animated: true, completion: nil)
    }
    
    private func showCameraView() {
        let camera = UIImagePickerController().then {
            $0.sourceType = .camera
            $0.allowsEditing = true
            $0.cameraDevice = .rear
            $0.cameraCaptureMode = .photo
        }
        camera.delegate = self
        present(camera, animated: true, completion: nil)
    }
    
    private func checkCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] isAuthorized in
            DispatchQueue.main.async {
                guard isAuthorized else {
                    self?.showPermissionRequestAlert()
                    return
                }
                self?.showCameraView()
            }
        }
    }
    
    private func showPermissionRequestAlert() {
        showAlert(title: "사진을 입력하려면 사진 접근 권한을 허용해야 합니다.",
                  message: .init(),
                        actions: [.action(title: "유지", style: .negative),
                                  .action(title: "설정 이동", style: .positive)])
        .filter { $0 == .positive }
        .withUnretained(self)
        .subscribe(onNext: { owner, _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        })
        .disposed(by: self.disposeBag)
    }

    
    private func showPhotoPickerView() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
}

extension ChallengeCheckViewController: ChallengeCheckPresenterAction {
    var backDidTap: Observable<Void> { backRelay.asObservable() }
    var imageDidLoaded: Observable<UIImage?> { imageRelay.asObservable() }
    var commentAvailable: Observable<Bool> { commentField.rx.available }
    var doneDidTap: Observable<ChallengeCheckRequest> { doneRelay.asObservable() }
}
