//
//  SignUpViewController.swift
//  VegannerApp
//
//  Created by Allie Kim on 2022/07/14.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import DesignSystem

protocol SignUpPresentableListener: AnyObject {
}

final class SignUpViewController: UIViewController, SignUpPresentable, SignUpViewControllable {

    weak var listener: SignUpPresentableListener?

    private var signUpContainerView: UIView

    private var signUpPageView: SignUpPageViewController

    private lazy var bottomButton = AppButton(title: "다음")

    init() {
        signUpContainerView = UIView()
        signUpPageView = SignUpPageViewController()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubviews([signUpContainerView,
                          signUpPageView.view,
                          bottomButton])

        signUpContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        signUpPageView.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        bottomButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(44)
        }

        signUpPageView.didMove(toParent: self)
    }
}

class SignUpPageViewController: UIPageViewController {

    private lazy var pageViews: [UIViewController] = {
        var subViews = [UIViewController]()
        subViews.append(contentsOf: [
            SignUpFirstStepVIewController(),
            SignUpSecondStepVIewController(),
            SignUpThirdStepVIewController(),
            SignUpLastStepVIewController()
        ])
        return subViews
    }()

    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey: Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = nil

        setViewControllers([pageViews[0]],
                           direction: .forward,
                           animated: false,
                           completion: nil)
    }
}

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
