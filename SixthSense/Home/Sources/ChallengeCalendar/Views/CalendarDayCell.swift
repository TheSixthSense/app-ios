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
        enum Label {
            static let textColor: (DateOwner) -> UIColor = {
                $0 == .thisMonth ? .systemBlack : .systemGray300
            }
        }
    }
    
    let contentBackView = UIView().then {
        $0.backgroundColor = .white
    }

    let titleLabel = UILabel().then {
        $0.font = AppFont.caption
        $0.textAlignment = .center
        $0.textColor = AppColor.systemBlack
        $0.backgroundColor = .clear
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

    func configure(state: CellState) {
        self.titleLabel.text = state.text
        self.titleLabel.textColor = Constants.Label.textColor(state.dateBelongsTo)
    }

    func configureViews() {
        self.setNeedsUpdateConstraints()
        contentView.addSubviews(contentBackView)
        contentBackView.addSubviews(titleLabel)
    }

    func setupConstraints() {

        contentBackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
