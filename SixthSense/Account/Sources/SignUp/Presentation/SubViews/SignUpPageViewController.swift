//
//  SignUpPageViewController.swift
//  Account
//
//  Created by Allie Kim on 2022/07/17.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

enum SignUpPageTransition {
    case forward
    case backward
}

class SignUpPageViewController: UIPageViewController {

    // MARK: - UI
    let nickNameInputView: NicknameStepViewController = .init()
    let genderInputView: GenderStepViewController = .init()
    let birthInputView: BirthStepViewController = .init()
    let veganInputView: VeganStepViewController = .init()

    private lazy var pageViews: [UIViewController] = {
        var subViews = [UIViewController]()
        subViews.append(contentsOf: [
            nickNameInputView,
            genderInputView,
            birthInputView,
            veganInputView
        ])
        return subViews
    }()

    // MARK: - Rx

    lazy var stepDrvier: Driver<SignUpSteps> = stepRelay.asDriver(onErrorJustReturn: SignUpSteps.nickname)
    private var stepRelay: PublishRelay<SignUpSteps>

    // MARK: - LifeCycle

    override init(transitionStyle style: UIPageViewController.TransitionStyle,
                  navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey: Any]? = nil) {
        stepRelay = PublishRelay()
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        stepRelay = PublishRelay()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        isPagingEnabled = false

        setViewControllers([pageViews[0]],
                           direction: .forward,
                           animated: false,
                           completion: nil)
    }

    func pageTransition(type: SignUpPageTransition) {
        switch type {
        case .forward:
            goToNextPage()
        case .backward:
            goToPreviousPage()
        }
    }
}

private extension SignUpPageViewController {

    private func goToNextPage() {
        if let currentViewController = viewControllers?[0],
            let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) {
            sendRelay(where: nextPage)
            setViewControllers([nextPage], direction: .forward, animated: true, completion: nil)
        }
    }

    private func goToPreviousPage() {
        if let currentViewController = viewControllers?[0] {

            guard currentViewController is NicknameStepViewController == false else {
                sendRelay(where: nil)
                return
            }

            if let previousPage = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) {
                sendRelay(where: previousPage)
                setViewControllers([previousPage], direction: .reverse, animated: true, completion: nil)
            }
        }
    }

    private func sendRelay(where nextPage: UIViewController?) {
        guard let nextPage = nextPage else {
            stepRelay.accept(SignUpSteps.exit)
            return
        }

        if nextPage is NicknameStepViewController {
            stepRelay.accept(SignUpSteps.nickname)
        } else if nextPage is GenderStepViewController {
            stepRelay.accept(SignUpSteps.gender)
        } else if nextPage is BirthStepViewController {
            stepRelay.accept(SignUpSteps.birthday)
        } else {
            stepRelay.accept(SignUpSteps.veganStage)
        }
    }
}


// MARK: - UIPageViewControllerDataSource
extension SignUpPageViewController: UIPageViewControllerDataSource {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {

        guard let viewControllerIndex = pageViews.firstIndex(of: viewController) else { return nil }

        let previousIndex = viewControllerIndex - 1

        return pageViews[previousIndex]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pageViews.firstIndex(of: viewController) else { return nil }

        let nextIndex = viewControllerIndex + 1

        return pageViews[safe: nextIndex]
    }
}

private extension UIPageViewController {
    var isPagingEnabled: Bool {
        get {
            var isEnabled: Bool = true
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    isEnabled = subView.isScrollEnabled
                }
            }
            return isEnabled
        }
        set {
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    subView.isScrollEnabled = newValue
                }
            }
        }
    }
}
