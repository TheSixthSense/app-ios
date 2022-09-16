//
//  MyPageModifyInfoInteractor.swift
//  Home
//
//  Created by Allie Kim on 2022/09/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import Foundation
import Account
import RxRelay
import RxSwift
import Repository
import Then

protocol MyPageModifyInfoRouting: ViewableRouting { }

protocol MyPageModifyInfoPresentable: Presentable {
    var handler: MyPageModifyInfoPresenterHandler? { get set }
    var action: MyPageModifyInfoPresenterAction? { get set }
}

protocol MyPageModifyInfoPresenterHandler: AnyObject {
    var nicknameInputValid: Observable<Bool> { get }
    var genderInputValid: Observable<Int> { get }
    var birthInputValid: Observable<Bool> { get }
    var veganStageInputValid: Observable<Int> { get }
    var nicknameCheckValid: Observable<String> { get }
    var enableButton: Observable<Bool> { get }
    var showErrorToast: Observable<String> { get }
}

protocol MyPageModifyInfoPresenterAction: AnyObject {
    var didTapBackButton: Observable<Void> { get }
    var nicknameDidInput: Observable<String> { get }
    var genderDidInput: Observable<GenderInfo> { get }
    var birthDidInput: Observable<[String]> { get }
    var veganStageDidInput: Observable<VeganStageInfo> { get }
    var didTapDoneButton: Observable<ModifyType> { get }
    var modifyNickname: Observable<Void> { get }
}

protocol MyPageModifyInfoListener: AnyObject {
    func popModifyInfoView(userInfo: UserInfoPayload?)
}

final class MyPageModifyInfoInteractor: PresentableInteractor<MyPageModifyInfoPresentable>, MyPageModifyInfoInteractable {

    weak var router: MyPageModifyInfoRouting?
    weak var listener: MyPageModifyInfoListener?

    private let component: MyPageModifyInfoComponent
    private var userInfoRequest: UserInfoRequest = .init()

    private let enableButtonRelay: PublishRelay<Bool> = .init()

    private let visibleNicknameValidRelay: BehaviorRelay<Bool> = .init(value: true)
    private let genderInputValidRelay: PublishRelay<Int> = .init()
    private let visibleBirthInputValidRelay: BehaviorRelay<Bool> = .init(value: true)
    private let veganStageInputValidRelay: PublishRelay<Int> = .init()
    private let nicknameCheckValidRelay: PublishRelay<String> = .init()

    private let errorToastRelay: PublishRelay<String> = .init()

    init(presenter: MyPageModifyInfoPresentable,
         component: MyPageModifyInfoComponent) {
        self.component = component
        super.init(presenter: presenter)
        presenter.handler = self
        configureRequestModel()
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        bind()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    private func configureRequestModel() {
        self.userInfoRequest = userInfoRequest.with {
            $0.nickname = component.userInfoPayload.nickname
            $0.gender = component.userInfoPayload.gender.rawValue
            $0.birthDay = component.userInfoPayload.birthDate
            $0.vegannerStage = component.userInfoPayload.vegannerStage.rawValue
        }
    }

    private func bind() {
        guard let action = presenter.action else { return }
        action.didTapBackButton
            .withUnretained(self)
            .bind(onNext: { owner, _ in
            owner.listener?.popModifyInfoView(userInfo: nil)
        }).disposeOnDeactivate(interactor: self)

        action.didTapDoneButton
            .filter { $0 != .nickname }
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
            owner.modifyUserInfo()
        }).disposeOnDeactivate(interactor: self)

        action.didTapDoneButton
            .filter { $0 == .nickname }
            .withUnretained(self)
            .subscribe(onNext: { owner, type in
            owner.isUseableNickname(owner.userInfoRequest.nickname)
        }).disposeOnDeactivate(interactor: self)

        bindNickname(action: action)
        bindBirth(action: action)
        bindGender(action: action)
        bindVeganStage(action: action)
    }

    private func bindNickname(action: MyPageModifyInfoPresenterAction) {
        action.nicknameDidInput
            .do(onNext: { [weak self] in
            guard !$0.isEmpty else {
                self?.enableButtonRelay.accept(false)
                self?.visibleNicknameValidRelay.accept(true) // 에러메세지 지우기
                return
            }

            guard self?.isValidNickname($0) == true else {
                self?.enableButtonRelay.accept(false)
                self?.visibleNicknameValidRelay.accept(false)
                return
            }
        })
            .filter { [weak self] in !$0.isEmpty && (self?.isValidNickname($0) == true) }
            .withUnretained(self)
            .subscribe(onNext: { owner, nickname in
            owner.visibleNicknameValidRelay.accept(true)
            owner.userInfoRequest.nickname = nickname
            owner.enableButtonRelay.accept(true)
        }).disposeOnDeactivate(interactor: self)

        action.modifyNickname
            .withUnretained(self)
            .bind(onNext: { owner, _ in
            owner.modifyUserInfo()
        }).disposeOnDeactivate(interactor: self)
    }

    private func bindBirth(action: MyPageModifyInfoPresenterAction) {
        action.birthDidInput
            .withUnretained(self)
            .subscribe(onNext: { owner, strings in
            let birthText = strings.joined()
            guard !birthText.isEmpty else {
                owner.enableButtonRelay.accept(false)
                owner.visibleBirthInputValidRelay.accept(true)
                return
            }

            guard birthText.count == 8 && self.isValidBirth(birthText) else {
                owner.visibleBirthInputValidRelay.accept(false)
                owner.enableButtonRelay.accept(false)
                return
            }
            owner.visibleBirthInputValidRelay.accept(true)
            owner.userInfoRequest.birthDay = birthText
            owner.enableButtonRelay.accept(true)
        }).disposeOnDeactivate(interactor: self)
    }

    private func bindGender(action: MyPageModifyInfoPresenterAction) {

        action.genderDidInput
            .withUnretained(self)
            .subscribe(onNext: { owner, gender in
            owner.userInfoRequest.gender = gender.rawValue
            owner.enableButtonRelay.accept(true)
            owner.genderInputValidRelay.accept(gender.intValue)
        }).disposeOnDeactivate(interactor: self)
    }

    private func bindVeganStage(action: MyPageModifyInfoPresenterAction) {
        action.veganStageDidInput
            .withUnretained(self)
            .subscribe(onNext: { owner, veganStage in
            owner.veganStageInputValidRelay.accept(veganStage.intValue)
            owner.userInfoRequest.vegannerStage = veganStage.rawValue
            owner.enableButtonRelay.accept(true)
        }).disposeOnDeactivate(interactor: self)
    }

    private func isUseableNickname(_ nickname: String) {
        component.useCase
            .validateUserNickname(request: nickname)
            .catch { error in
            guard let apiError = error as? APIError,
                let statusCode = apiError.errorStatusCode else {
                return .just(error.localizedDescription)
            }
            return .just(statusCode)
        }
            .bind(to: nicknameCheckValidRelay)
            .disposeOnDeactivate(interactor: self)
    }

    private func modifyUserInfo() {
        component.useCase.modifyUserInfo(userInfo: userInfoRequest)
            .catch({ [weak self] _ in
            self?.errorToastRelay.accept("오류가 발생했어요ㅠㅠ 다시 눌러주세요!")
            return .just(nil)
        })
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe(onNext: { owner, model in
            owner.listener?.popModifyInfoView(userInfo: model)
        }).disposeOnDeactivate(interactor: self)
    }

    private func isValidNickname(_ nickname: String) -> Bool {
        let nicknameRegex = "^[ㄱ-ㅎ|가-힣|a-z|A-Z|0-9]+$"
        let nicknameTest = NSPredicate(format: "SELF MATCHES %@",
                                       nicknameRegex)
        return nicknameTest.evaluate(with: nickname)
    }

    private func isValidBirth(_ birth: String) -> Bool {
        let birthRegex = "^(19[0-9][0-9]|20\\d{2})(0[0-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1])$"
        let birthTest = NSPredicate(format: "SELF MATCHES %@", birthRegex)
        return birthTest.evaluate(with: birth)
    }
}

extension MyPageModifyInfoInteractor: MyPageModifyInfoPresenterHandler {
    var nicknameInputValid: Observable<Bool> { visibleNicknameValidRelay.asObservable() }
    var genderInputValid: Observable<Int> { genderInputValidRelay.asObservable() }
    var birthInputValid: Observable<Bool> { visibleBirthInputValidRelay.asObservable() }
    var veganStageInputValid: Observable<Int> { veganStageInputValidRelay.asObservable() }
    var nicknameCheckValid: Observable<String> { nicknameCheckValidRelay.asObservable() }
    var enableButton: Observable<Bool> { enableButtonRelay.asObservable() }
    var showErrorToast: Observable<String> { errorToastRelay.asObservable() }
}

extension UserInfoRequest: Then { }
