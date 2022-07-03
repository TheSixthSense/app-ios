//
//  UserTableViewCell.swift
//  SixthSense
//
//  Created by Allie Kim on 2022/07/03.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class UserTableViewCell: UITableViewCell {

    private var disposeBag = DisposeBag()

    private lazy var userIdLabel = UILabel()
    private lazy var idLabel = UILabel()
    private lazy var usernameLabel = UILabel()
    private let userStackView = UIStackView().then { stack in
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
    }

    private lazy var emailLabel = UILabel()
    private lazy var addressLabel = UILabel()
    private lazy var phoneLabel = UILabel()
    private let userContactStackView = UIStackView().then { stack in
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillEqually
    }

    private lazy var websiteLabel = UILabel()
    private lazy var companyLabel = UILabel()
    private let userCompanyStackView = UIStackView().then { stack in
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillEqually
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
        arrangedSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }

    func configure() {
        userIdLabel.text = "USER ID"
        idLabel.text = "ID"
        usernameLabel.text = "USER NAME"
        emailLabel.text = "EMAIL"
        addressLabel.text = "ADDRESS"
        phoneLabel.text = "PHONE"
        websiteLabel.text = "WEBSITE"
        companyLabel.text = "COMPANY"
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        bindLayout()
    }

    private func addSubViews() {
        addSubview(userStackView)
        addSubview(userContactStackView)
        addSubview(userCompanyStackView)
    }

    private func arrangedSubViews() {
        userStackView.addArrangedSubview(userIdLabel)
        userStackView.addArrangedSubview(idLabel)
        userStackView.addArrangedSubview(usernameLabel)

        userContactStackView.addArrangedSubview(emailLabel)
        userContactStackView.addArrangedSubview(addressLabel)
        userContactStackView.addArrangedSubview(phoneLabel)

        userCompanyStackView.addArrangedSubview(websiteLabel)
        userCompanyStackView.addArrangedSubview(companyLabel)
    }

    private func bindLayout() {
        userStackView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(150)
        }

        userContactStackView.snp.makeConstraints { make in
            make.top.equalTo(userStackView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(userStackView)
        }

        userCompanyStackView.snp.makeConstraints { make in
            make.top.equalTo(userContactStackView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
