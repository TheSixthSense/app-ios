//
//  ChallengeRegisterViewController.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol ChallengeRegisterPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class ChallengeRegisterViewController: UIViewController, ChallengeRegisterPresentable, ChallengeRegisterViewControllable {

    weak var listener: ChallengeRegisterPresentableListener?
}
