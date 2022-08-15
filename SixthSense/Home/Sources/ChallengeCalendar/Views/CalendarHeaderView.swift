//
//  CalendarHeaderView.swift
//  Home
//
//  Created by 문효재 on 2022/08/04.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import UIKit
import RxSwift
import DesignSystem

final class CalendarHeaderView: UIView {
    private let headerView = UIView()
    let monthLabel = UITextField().then {
        $0.font = AppFont.body1Bold
        $0.sizeToFit()
    }
    private let monthSelectButton = UIButton().then {
        $0.setImage(DesignSystemAsset.chevronDown.image, for: .normal)
    }
    private let disposeBag = DisposeBag()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
        configureConstraints()
        bind()
    }
    
    func configureViews() {
        addSubviews(monthLabel, monthSelectButton, addButton)
    }
    
    func configureConstraints() {
        monthLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        monthSelectButton.snp.makeConstraints {
            $0.left.equalTo(monthLabel.snp.right).offset(7)
            $0.centerY.equalTo(monthLabel)
            $0.width.equalTo(11)
            $0.height.equalTo(6)
        }
    }
    
    func bind() {
        monthSelectButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.monthLabel.becomeFirstResponder()
            })
            .disposed(by: self.disposeBag)
    }
}


extension Reactive where Base: CalendarHeaderView {
    var tap: Observable<Void> {
        base.monthLabel.rx.controlEvent(.editingDidBegin).map { _ in () }
    }
}
