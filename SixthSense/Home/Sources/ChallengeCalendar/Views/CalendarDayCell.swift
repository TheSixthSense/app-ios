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
            static let viewStyle: (UIView) -> Void = {
                $0.backgroundColor = .clear
            }
            static let todayViewStyle: (UIView) -> Void = {
                $0.backgroundColor = UIColor(red: 244/256, green: 251/256, blue: 245/256, alpha: 1)
            }
        }
        
        enum Label {
            static let todayTextStyle: (UILabel) -> Void = {
                $0.textColor = .green700
                $0.font = AppFont.captionBold
            }
            
            static let textStyle: (UILabel) -> Void = {
                $0.textColor = .systemBlack
                $0.font = AppFont.caption
            }
        }
    }
    
    private let container = UIView().then {
        $0.layer.cornerRadius = 24.5
    }
    
    private let titleLabel = UILabel()
        .then(Constants.Label.textStyle)
        .then {
            $0.textAlignment = .center
            $0.backgroundColor = .clear
        }
    
    private let imageView = UIImageView()

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
        invalidateViewState()
    }
    
    func invalidateViewState() {
        titleLabel.do(Constants.Label.textStyle)
        container.do(Constants.View.viewStyle)
    }

    func configure(state: DateState) {
        configureItem(by: state)
        configureTodayItem(isToday: state.isToday)
    }
    
    func configureItem(by state: DateState) {
        titleLabel.text = state.title
        titleLabel.textColor = state.belongsToMonth ? .systemBlack : .systemGray300
        imageView.isHidden = !state.belongsToMonth
        imageView.image = state.challengeIcon
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
            $0.width.equalTo(49).priority(.required)
            $0.height.equalTo(54).priority(.required)
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
            $0.width.equalTo(19)
            $0.height.equalTo(24)
        }
    }
}

extension ChallengeCalendarDayState {
    var icon: UIImage {
        switch self {
            case .zero:
                return HomeAsset.challengeDayZero.image
            case .overZero:
                return HomeAsset.challengeDayOverZero.image
            case .almost:
                return HomeAsset.challengeDayAlmost.image
            case .done:
                return HomeAsset.challengeDayDone.image
            case .waiting:
                return HomeAsset.challengeDayWaiting.image
        }
    }
}
