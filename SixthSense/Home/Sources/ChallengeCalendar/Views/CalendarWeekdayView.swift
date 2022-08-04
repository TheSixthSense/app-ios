//
//  CalendarWeekdayView.swift
//  Home
//
//  Created by 문효재 on 2022/08/04.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//
import UIKit
import DesignSystem

final class CalendarWeekdayView: UIView {
    private enum Constants {
        enum Label {
            static let defaultStyle: (UILabel) -> Void = {
                $0.font = AppFont.caption
                $0.textColor = AppColor.systemGray500
                $0.textAlignment = .center
                $0.numberOfLines = 1
                $0.sizeToFit()
            }
        }
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let weekdays: [UILabel] = ["일", "월", "화", "수", "목", "금", "토"]
        .map { day in
            UILabel()
            .then(Constants.Label.defaultStyle)
            .then { $0.text = day }
        }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
        configureConstraints()
    }
    
    func configureViews() {
        self.addSubviews(stackView)
        stackView.addArrangedSubviews(weekdays)
    }
    
    func configureConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 18, left: 0, bottom: 12, right: 0))
        }
    }
}
