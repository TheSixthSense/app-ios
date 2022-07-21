//
//  SignUpPageViewController.swift
//  VegannerApp
//
//  Created by Allie Kim on 2022/07/17.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class SignUpPageViewController: UIPageViewController {

    // MARK: - UI

    private lazy var pageViews: [UIViewController] = {
        var subViews = [UIViewController]()
        subViews.append(contentsOf: [
            SignUpFirstStepViewController(),
            SignUpSecondStepViewController(),
            SignUpThirdStepViewController(),
            SignUpLastStepViewController()
        ])
        return subViews
    }()

    // MARK: - Rx

    lazy var stepDrvier: Driver<SignUpStep> = stepRelay.asDriver(onErrorJustReturn: SignUpStep.one)
    private var stepRelay: PublishRelay<SignUpStep>

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
}

extension SignUpPageViewController {

    func goToNextPage() -> Bool {
        if let currentViewController = viewControllers?[0] {
            if let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) {
                sendRelay(where: nextPage)
                setViewControllers([nextPage], direction: .forward, animated: true, completion: nil)
                return true
            }
        }
        return false
    }

    func goToPreviousPage() {
        if let currentViewController = viewControllers?[0] {

            guard currentViewController is SignUpFirstStepViewController == false else {
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
            stepRelay.accept(SignUpStep.exit)
            return
        }

        if nextPage is SignUpFirstStepViewController {
            stepRelay.accept(SignUpStep.one)
        } else if nextPage is SignUpSecondStepViewController {
            stepRelay.accept(SignUpStep.two)
        } else if nextPage is SignUpThirdStepViewController {
            stepRelay.accept(SignUpStep.three)
        } else {
            stepRelay.accept(SignUpStep.four)
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

        guard previousIndex >= 0 else { return nil }

        guard pageViews.count > previousIndex else { return nil }

        return pageViews[previousIndex]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pageViews.firstIndex(of: viewController) else { return nil }

        let nextIndex = viewControllerIndex + 1

        guard nextIndex < pageViews.count else { return nil }

        guard pageViews.count > nextIndex else { return nil }

        return pageViews[nextIndex]
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
