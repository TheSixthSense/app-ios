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
    
    lazy var stepDrvier: Driver<SignUpStep> = stepRelay.asDriver(onErrorJustReturn: SignUpStep.one)
    private var stepRelay: PublishRelay<SignUpStep>

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
        delegate = self

        setViewControllers([pageViews[0]],
                           direction: .forward,
                           animated: false,
                           completion: nil)
    }
}
// MARK: - UIPageViewControllerDelegate
extension SignUpPageViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed,
            let currentVC = pageViewController.viewControllers?.first else { return }

        if currentVC is SignUpFirstStepViewController {
            stepRelay.accept(SignUpStep.one)
        } else if currentVC is SignUpSecondStepViewController {
            stepRelay.accept(SignUpStep.two)
        } else if currentVC is SignUpThirdStepViewController {
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
