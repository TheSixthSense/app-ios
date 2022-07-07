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

    private var disposeBag: DisposeBag = DisposeBag()

    private lazy var userIdLabel = UILabel().then { label in
        label.frame.size.width = 10
    }
    private lazy var usernameLabel = UILabel()
    private let userStackView = UIStackView().then { stack in
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
    }

    private lazy var emailLabel = UILabel().then { label in
        label.frame.size.height = 20
    }
    private lazy var addressLabel = UILabel().then { label in
        label.numberOfLines = 0
    }
    private lazy var phoneLabel = UILabel()
    private let userContactStackView = UIStackView().then { stack in
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillProportionally
    }

    private lazy var websiteLabel = UILabel()
    private lazy var companyLabel = UILabel().then { label in
        label.numberOfLines = 0
    }
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
        configure(using: UserTableViewModel(model: User()))
    }

    func configure(using viewModel: UserTableViewModel) {
        userIdLabel.text = "ID: \(viewModel.userId)"
        usernameLabel.text = "NAME: \(viewModel.username)"
        emailLabel.text = "EMAIL: \(viewModel.email)"
        let address = viewModel.address
        addressLabel.text = "ADDRESS: [\(address.zipcode)]\n\(address.city), \(address.street), \(address.suite)\n- lat: \(address.geo.lat)\n- lon: \(address.geo.lng)"
        phoneLabel.text = "PHONE: \(viewModel.phone)"
        websiteLabel.text = "WEBSITE: \(viewModel.website)"
        let company = viewModel.company
        companyLabel.text = "COMPANY: \(company.companyName)\n\(company.catchPhrase)\n\(company.bs)"
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        bindLayout()
    }

    private func addSubViews() {
        let stackViews = [userStackView, userContactStackView, userCompanyStackView]
        addSubviews(stackViews)
    }

    private func arrangedSubViews() {
        let userLabels = [userIdLabel, usernameLabel]
        userStackView.addArrangedSubviews(userLabels)

        let userContactLabels = [emailLabel, addressLabel, phoneLabel]
        userContactStackView.addArrangedSubviews(userContactLabels)

        let userCompanyLabels = [websiteLabel, companyLabel]
        userCompanyStackView.addArrangedSubviews(userCompanyLabels)
    }

    private func bindLayout() {
        userIdLabel.frame.size.width = 20

        userStackView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        userContactStackView.snp.makeConstraints { make in
            make.top.equalTo(userStackView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }

        userCompanyStackView.snp.makeConstraints { make in
            make.top.equalTo(userContactStackView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }
}
