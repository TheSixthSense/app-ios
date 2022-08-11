//
//  CalendarDayCell.swift
//  Home
//
//  Created by 문효재 on 2022/08/04.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import JTAppleCalendar
import DesignSystem

final class CalendarDayCell: JTACDayCell {
    
    private enum Constants {
        enum View {
            static let todayViewStyle: (UIView) -> Void = {
                $0.backgroundColor = UIColor(red: 244/256, green: 251/256, blue: 245/256, alpha: 1)
            }
        }
        
        enum Label {
            static let textColor: (DateOwner) -> UIColor = {
                $0 == .thisMonth ? .systemBlack : .systemGray300
            }
            
            static let todayTextStyle: (UILabel) -> Void = {
                $0.textColor = .green700
                $0.font = AppFont.captionBold
            }
        }
    }
    
    private let container = UIView().then {
        $0.layer.cornerRadius = 10
    }
    
    private let titleLabel = UILabel().then {
        $0.font = AppFont.caption
        $0.textAlignment = .center
        $0.textColor = AppColor.systemBlack
        $0.backgroundColor = .clear
    }
    
    private let imageView = UIImageView().then {
        $0.image = HomeAsset.challengeDayEmpty.image
    }

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureViews()
        self.setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }

    func configure(state: CellState) {
        configureItem(by: state)
    }
    
    func configureItem(by state: CellState) {
        titleLabel.text = state.text
        titleLabel.textColor = Constants.Label.textColor(state.dateBelongsTo)
        imageView.isHidden = state.dateBelongsTo != .thisMonth
        configureTodayItem(isToday: Calendar.current.isDateInToday(state.date))
    }
    
    func configureTodayItem(isToday: Bool) {
        guard isToday else { return }
        titleLabel.do(Constants.Label.todayTextStyle)
        container.do(Constants.View.todayViewStyle)
    }
    
    func configureViews() {
        self.setNeedsUpdateConstraints()
        contentView.addSubviews(container)
        container.addSubviews(titleLabel, imageView)
    }

    func setupConstraints() {
        container.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.size.equalTo(49).priority(.required)
            $0.bottom.equalToSuperview().inset(6)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(2)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(16)
        }
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.bottom.equalToSuperview().inset(2)
        }
    }
}
