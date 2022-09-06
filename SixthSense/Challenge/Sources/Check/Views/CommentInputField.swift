//
//  CommentInputField.swift
//  Challenge
//
//  Created by 문효재 on 2022/08/29.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import DesignSystem
import AVFAudio

final class CommentInputField: UIView {
    enum Constants {
        static let placeholderText = "챌린지 실천 내용이나 느낀 점을 기록해볼까?"
        static let tintColor: (Bool) -> UIColor = {
            $0 ? UIColor.systemGray300 : UIColor.red500
        }
    }
    
    private let containerView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = Constants.tintColor(true).cgColor
        $0.layer.borderWidth = 1
    }
    
    let inputArea = UITextView().then {
        $0.text = Constants.placeholderText
        $0.font = AppFont.body1
        $0.textColor = .systemGray500
        $0.isScrollEnabled = false
    }
    
    let maxCount: Int
    private let indicator = UILabel().then {
        $0.font = AppFont.caption
        $0.textColor = .systemGray300
        $0.numberOfLines = 1
        $0.sizeToFit()
    }
    
    private lazy var errorView = TextFieldErrorView(maxCount: maxCount).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isHidden = true
    }
    
    private let disposeBag = DisposeBag()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
        configureConstraints()
        bind()
    }
    
    init(maxCount: Int) {
        self.maxCount = maxCount
        super.init(frame: .zero)
        inputArea.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateIndicator() {
        self.indicator.text = "\(inputArea.text.count) / \(maxCount)"
    }
    
    func configureViews() {
        addSubviews(containerView, errorView)
        containerView.addSubviews(inputArea, indicator)
    }
    
    func configureConstraints() {
        containerView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        
        inputArea.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(10)
            $0.height.equalTo(110).priority(1)
        }
        inputArea.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        indicator.snp.makeConstraints {
            $0.top.equalTo(inputArea.snp.bottom).offset(10)
            $0.right.bottom.equalToSuperview().inset(10)
        }
        indicator.setContentHuggingPriority(.required, for: .vertical)
        
        errorView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).offset(2)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    func bind() {
        inputArea.rx.text
            .compactMap(\.?.count)
            .withUnretained(self)
            .subscribe(onNext: { owner, count in
                owner.showErrorStatus(count > owner.maxCount)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func showErrorStatus(_ visible: Bool) {
        containerView.layer.borderColor = Constants.tintColor(!visible).cgColor
        indicator.textColor = Constants.tintColor(!visible)
        errorView.isHidden = !visible
    }
}

extension CommentInputField: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateIndicator()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard inputArea.text == Constants.placeholderText else { return }
        textView.do {
            $0.text = nil
            $0.textColor = .systemBlack
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        textView.do {
            $0.text = Constants.placeholderText
            $0.textColor = .systemGray500
        }
    }
}

extension Reactive where Base: CommentInputField {
    var text: Observable<String?> {
        base.inputArea.rx.text
            .map { $0 != CommentInputField.Constants.placeholderText ? $0 : nil }
            .asObservable()
    }
    
    var available: Observable<Bool> {
        base.inputArea.rx.text
            .compactMap(\.?.count)
            .map { $0 <= base.maxCount }
            .asObservable()
    }
}
